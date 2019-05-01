require 'spec_helper'

describe Facebook::Messenger::Subscriptions do
  let(:access_token) { 'access token' }
  let(:subscribed_fields) { %w[feed mention name] }

  let(:subscribed_apps_url) do
    Facebook::Messenger::Subscriptions.base_uri + '/subscribed_apps'
  end

  before do
    ENV['ACCESS_TOKEN'] = access_token
  end

  describe '.subscribe' do
    context 'with a successful response' do
      before do
        stub_request(:post, subscribed_apps_url)
          .with(headers: { 'Content-Type' => 'application/json' },
                body: {
                  access_token: access_token,
                  subscribed_fields: subscribed_fields
                }.to_json)
          .to_return(
            body: JSON.dump('success' => true),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'returns true' do
        args = {
          access_token: access_token,
          subscribed_fields: subscribed_fields
        }

        expect(subject.subscribe(args)).to be true
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:post, subscribed_apps_url)
          .with(headers: { 'Content-Type' => 'application/json' },
                body: {
                  access_token: access_token,
                  subscribed_fields: subscribed_fields
                }.to_json)
          .to_return(
            body: JSON.dump(
              'error' => {
                'message' => error_message,
                'type' => 'OAuthException',
                'code' => 190,
                'fbtrace_id' => 'Hlssg2aiVlN'
              }
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          subject.subscribe(access_token: access_token,
                            subscribed_fields: subscribed_fields)
        end.to raise_error(
          Facebook::Messenger::Subscriptions::Error, error_message
        )
      end
    end
  end

  describe '.unsubscribe' do
    context 'with a successful response' do
      before do
        stub_request(:delete, subscribed_apps_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump('success' => true),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'returns true' do
        expect(subject.unsubscribe(access_token: access_token)).to be true
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:delete, subscribed_apps_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump(
              'error' => {
                'message' => error_message,
                'type' => 'OAuthException',
                'code' => 190,
                'fbtrace_id' => 'Hlssg2aiVlN'
              }
            ),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'raises an error' do
        expect do
          subject.unsubscribe(access_token: access_token)
        end.to raise_error(
          Facebook::Messenger::Subscriptions::Error, error_message
        )
      end
    end
  end
end
