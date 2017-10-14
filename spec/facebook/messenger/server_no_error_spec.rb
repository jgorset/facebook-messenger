require 'spec_helper'
require 'rack/test'

describe Facebook::Messenger::ServerNoError do
  include Rack::Test::Methods

  let(:verify_token) { 'verify token' }
  let(:app_secret) { 'app secret' }
  let(:access_token) { 'access token' }
  let(:challenge) { 'challenge' }

  def app
    Facebook::Messenger::ServerNoError
  end

  before do
    ENV['VERIFY_TOKEN'] = verify_token
    ENV['ACCESS_TOKEN'] = access_token
    ENV['APP_SECRET'] = nil
  end

  describe 'GET' do
    context 'with the right verify token' do
      it 'responds with the challenge' do
        get '/', 'hub.verify_token' => verify_token,
                 'hub.challenge' => challenge

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq(challenge)
      end
    end

    context 'with the wrong verify token' do
      it 'responds with an error' do
        get '/', 'hub.verify_token' => 'foo',
                 'hub.challenge' => challenge

        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('Error; wrong verify token')
      end
    end
  end

  describe 'PATCH' do
    it 'returns HTTP 405 Method Not Allowed' do
      patch '/'
      expect(last_response.status).to eq(405)
    end
  end

  describe 'POST' do
    let :payload do
      JSON.generate(
        object: 'page',
        entry: [
          {
            id: '1',
            time: 145_776_419_824_6,
            messaging: [
              {
                sender: {
                  id: '2'
                },
                recipient: {
                  id: '3'
                },
                timestamp: 145_776_419_762_7,
                message: {
                  mid: 'mid.1457764197618:41d102a3e1ae206a38',
                  seq: 73,
                  text: 'Hello, bot!'
                }
              }
            ]
          }
        ]
      )
    end

    it 'triggers the bot' do
      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:message, any_args)

      post '/', payload
    end

    context 'without messaging' do
      let :payload do
        JSON.generate(
          object: 'page',
          entry: [
            {
              id: '1',
              time: 145_776_419_824_6
            }
          ]
        )
      end

      it 'does not trigger the bot' do
        expect(Facebook::Messenger::Bot).to_not receive(:trigger)
      end
    end

    context 'with invalid JSON' do
      let(:payload) { 'invalid:json' }

      it 'returns HTTP 400 Bad Request' do
        post '/', payload

        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Error parsing request body format')
        expect(last_response['Content-Type']).to eq('text/plain')
      end
    end

    context 'integrity check' do
      before do
        ENV['APP_SECRET'] = app_secret
      end

      after do
        ENV['APP_SECRET'] = nil
      end

      it 'do not trigger if fails' do
        expect(Facebook::Messenger::Bot).to_not receive(:trigger)

        post '/', {}, 'HTTP_X_HUB_SIGNATURE' => 'sha1=64738239'
      end

      it 'triggers if succeeds' do
        expect(Facebook::Messenger::Bot).to receive(:trigger)

        signature = OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha1'),
          ENV['APP_SECRET'],
          payload
        )

        post '/', payload, 'HTTP_X_HUB_SIGNATURE' => "sha1=#{signature}"
      end

      it 'returns bad request if signature is not present' do
        begin
          old_stream = $stderr.dup
          $stderr.reopen('/dev/null')
          $stderr.sync = true

          post '/', payload
        ensure
          $stderr.reopen(old_stream)
          old_stream.close
        end

        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Error getting integrity signature')
        expect(last_response['Content-Type']).to eq('text/plain')
      end

      it 'returns bad request if signature is invalid' do
        post '/', payload, 'HTTP_X_HUB_SIGNATURE' => 'sha1=64738239'

        expect(last_response.status).to eq(400)
        expect(last_response.body).to eq('Error checking message integrity')
        expect(last_response['Content-Type']).to eq('text/plain')
      end
    end
  end
end
