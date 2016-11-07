require 'spec_helper'

describe Facebook::Messenger::Bot do
  let(:verify_token) { 'verify token' }
  let(:app_secret) { 'app secret' }
  let(:access_token) { 'access token' }

  before do
    ENV['ACCESS_TOKEN'] = access_token
    ENV['APP_SECRET'] = app_secret
    ENV['ACCESS_TOKEN'] = access_token
  end

  subject { Facebook::Messenger::Bot }

  describe '.on' do
    let(:hook) { proc { |_args| } }

    context 'with a valid event' do
      before { subject.on :message, &hook }

      it 'registers a hook' do
        expect(subject.hooks[:message]).to eq(hook)
      end
    end

    context 'with an invalid event' do
      it 'raises ArgumentError' do
        expect { subject.on :foo, &hook }.to raise_error(
          ArgumentError, /foo is not a valid event/
        )
      end
    end
  end

  describe '.receive' do
    context 'with a message' do
      let(:message) { Facebook::Messenger::Incoming::Message.new({}) }

      it 'triggers a :message' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(message)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:message, message)

        subject.receive({})
      end
    end

    context 'with a delivery' do
      let(:delivery) { Facebook::Messenger::Incoming::Delivery.new({}) }

      it 'triggers a :delivery' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(delivery)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:delivery, delivery)

        subject.receive({})
      end
    end

    context 'with a postback' do
      let(:postback) { Facebook::Messenger::Incoming::Postback.new({}) }

      it 'triggers a :delivery' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(postback)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:postback, postback)

        subject.receive({})
      end
    end

    context 'with an optin' do
      let(:optin) { Facebook::Messenger::Incoming::Optin.new({}) }

      it 'triggers a :delivery' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(optin)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:optin, optin)

        subject.receive({})
      end
    end

    context 'with a read' do
      let(:read) { Facebook::Messenger::Incoming::Read.new({}) }

      it 'triggers a :read' do
        expect(Facebook::Messenger::Incoming).to receive(:parse)
          .and_return(read)

        expect(Facebook::Messenger::Bot).to receive(:trigger)
          .with(:read, read)

        subject.receive({})
      end
    end
  end

  describe '.trigger' do
    let(:hook) { proc { |args| args } }

    context 'with a registered event' do
      before { subject.on :message, &hook }

      it 'runs the hook' do
        expect(subject.trigger(:message, 'foo')).to eq('foo')
      end
    end

    context 'with an invalid event' do
      it 'ignores hookless trigger' do
        expect { subject.trigger(:foo, 'bar') }
          .to output("Ignoring foo (no hook registered)\n").to_stderr
      end
    end
  end

  describe '.deliver' do
    let(:messages_url) do
      Facebook::Messenger::Subscriptions.base_uri + '/messages'
    end

    let(:payload) do
      {
        recipient: {
          id: '123'
        },
        message: {
          text: 'Hello, human!'
        }
      }
    end

    def stub_request_to_return(hash)
      stub_request(:post, messages_url)
        .with(
          query: { access_token: access_token },
          body: payload,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(
          body: JSON.dump(hash),
          headers: default_graph_api_response_headers
        )
    end

    context 'when all is well' do
      let(:message_id) { 'mid.1456970487936:c34767dfe57ee6e339' }

      before do
        stub_request_to_return(
          recipient_id: '1008372609250235',
          message_id: message_id
        )
      end

      it 'sends a message' do
        result = subject.deliver(payload, access_token: access_token)

        expect(result).to eq(message_id)
      end
    end

    context 'when the recipient could not be found' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid parameter',
            type: 'FacebookApiException',
            code: 100,
            error_data: 'No matching user found.',
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises RecipientNotFound' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::RecipientNotFound,
          'No matching user found.'
        )
      end
    end

    context 'when the application does not have permission to use the API' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid parameter',
            type: 'FacebookApiException',
            code: 10,
            error_data: 'Application does not have permission ' \
                        'to use the Send API.',
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionDenied' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionDenied,
          'Application does not have permission to use the Send API.'
        )
      end
    end

    context 'when Facebook had an internal server error' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid parameter',
            type: 'FacebookApiException',
            code: 2,
            error_data: 'Send message failure. Internal server error.',
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises InternalError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::InternalError,
          'Send message failure. Internal server error.'
        )
      end
    end
  end
end
