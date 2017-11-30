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
        messaging_type: 'RESPONSE',
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
      let(:recipient_id) { '1008372609250235' }
      let(:message_id) { 'mid.1456970487936:c34767dfe57ee6e339' }

      before do
        stub_request_to_return(
          recipient_id: recipient_id,
          message_id: message_id
        )
      end

      it 'sends a message' do
        result = subject.deliver(payload, access_token: access_token)
        expect(result).to eq({ recipient_id: recipient_id,
                               message_id: message_id }.to_json)
      end
    end

    context 'when Facebook had an internal server error' do
      before do
        stub_request_to_return(
          error: {
            message: 'Temporary send message failure. Please try again later.',
            type: 'FacebookApiException',
            code: 1200,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises InternalError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::InternalError,
          'Temporary send message failure. Please try again later.'
        )
      end
    end

    context 'when exceeding the send rate limit' do
      before do
        stub_request_to_return(
          error: {
            message: 'Calls to this API have exceeded the rate limit',
            type: 'FacebookApiException',
            code: 613,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises LimitError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::LimitError,
          'Calls to this API have exceeded the rate limit'
        )
      end
    end

    context 'when passing an invalid facebook psid' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid fbid.',
            type: 'FacebookApiException',
            code: 100,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises BadParameterError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::BadParameterError,
          'Invalid fbid.'
        )
      end
    end

    context 'when the recipient could not be found' do
      before do
        stub_request_to_return(
          error: {
            message: 'No matching user found.',
            type: 'FacebookApiException',
            code: 100,
            error_subcode: 2_018_001,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises BadParameterError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::BadParameterError,
          'No matching user found.'
        )
      end
    end

    context 'when using an invalid OAuth token' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid OAuth access token.',
            type: 'FacebookApiException',
            code: 190,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises AccessTokenError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::AccessTokenError,
          'Invalid OAuth access token.'
        )
      end
    end

    context 'when sending messages the current token does not allow to' do
      before do
        stub_request_to_return(
          error: {
            message: 'This message is sent outside of allowed window. You ' \
            'need page_messaging_subscriptions permission to be able to do it.',
            type: 'FacebookApiException',
            code: 10,
            error_subcode: 2_018_065,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'This message is sent outside of allowed window. You need ' \
          'page_messaging_subscriptions permission to be able to do it.'
        )
      end
    end

    context 'when the person cannot receive messages from the page' do
      before do
        stub_request_to_return(
          error: {
            message: 'This Person Cannot Receive Messages: This person ' \
            'isn\'t receiving messages from you right now.',
            type: 'FacebookApiException',
            code: 10,
            error_subcode: 2_018_108,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'This Person Cannot Receive Messages: This person isn\'t receiving ' \
          'messages from you right now.'
        )
      end
    end

    context 'when the person cannot receive messages from the page' do
      before do
        stub_request_to_return(
          error: {
            message: 'Message Not Sent: This person isn\'t receiving messages' \
            ' from you right now.',
            type: 'FacebookApiException',
            code: 200,
            error_subcode: 1_545_041,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'Message Not Sent: This person isn\'t receiving messages from you ' \
          'right now.'
        )
      end
    end

    context "when the application doesn't have pages_messaging permission" do
      before do
        stub_request_to_return(
          error: {
            message: 'Requires pages_messaging permission to manage the object',
            type: 'OAuthException',
            code: 230,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'Requires pages_messaging permission to manage the object'
        )
      end
    end

    context 'when the application isnt live with pages_messaging permission' do
      before do
        stub_request_to_return(
          error: {
            message: 'Cannot message users who are not admins, developers or ' \
            'testers of the app until pages_messaging permission is reviewed ' \
            'and the app is live.',
            type: 'FacebookApiException',
            code: 200,
            error_subcode: 2_018_028,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'Cannot message users who are not admins, developers or testers of ' \
          'the app until pages_messaging permission is reviewed and the app ' \
          'is live.'
        )
      end
    end

    context 'when the application isnt live with pages_messaging_phone_number' \
    '  permission' do
      before do
        stub_request_to_return(
          error: {
            message: 'Cannot message users who are not admins, developers or ' \
            'testers of the app until pages_messaging_phone_number permission' \
            ' is reviewed and the app is live.',
            type: 'FacebookApiException',
            code: 200,
            error_subcode: 2_018_027,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'Cannot message users who are not admins, developers or testers of ' \
          'the app until pages_messaging_phone_number permission is reviewed ' \
          'and the app is live.'
        )
      end
    end

    context 'when the application is not authorized to do phone matching' do
      before do
        stub_request_to_return(
          error: {
            message: 'Requires phone matching access fee to be paid by this ' \
            'page unless the recipient user is an admin, developer, or tester' \
            ' of the app.',
            type: 'FacebookApiException',
            code: 200,
            error_subcode: 2_018_021,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises PermissionError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::PermissionError,
          'Requires phone matching access fee to be paid by this page unless ' \
          'the recipient user is an admin, developer, or tester of the app.'
        )
      end
    end

    context 'when using an invalid account_linking token' do
      before do
        stub_request_to_return(
          error: {
            message: 'Invalid account_linking_token',
            type: 'FacebookApiException',
            code: 10_303,
            fbtrace_id: 'D2kxCybrKVw'
          }
        )
      end

      it 'raises AccountLinkingError' do
        expect do
          subject.deliver(payload, access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Bot::AccountLinkingError,
          'Invalid account_linking_token'
        )
      end
    end
  end
end
