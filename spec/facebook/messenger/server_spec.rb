require 'spec_helper'
require 'rack/test'

describe Facebook::Messenger::Server do
  include Rack::Test::Methods

  let(:verify_token) { 'verify token' }
  let(:challenge) { 'challenge' }

  def app
    Facebook::Messenger::Server
  end

  before do
    Facebook::Messenger.configure do |config|
      config.verify_token = verify_token
    end
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
        expect(last_response.body).to eq('Error; wrong validation token')
      end
    end
  end

  describe 'POST' do
    it 'triggers the bot' do
      expect(Facebook::Messenger::Bot).to receive(:trigger)
        .with(:message, any_args)

      post '/', JSON.dump(
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
  end
end
