require 'spec_helper'

describe Facebook::Messenger::Subscriptions do
  let(:subscribed_apps_url) do
    Facebook::Messenger::Subscriptions.base_uri + '/subscribed_apps'
  end

  describe '.subscribe' do
    let(:access_token) { '<access token>' }

    context 'with a successful response' do
      before do
        stub_request(:post, subscribed_apps_url)
          .with(query: { access_token: access_token })
          .to_return(
            body: JSON.dump('success' => true),
            status: 200,
            headers: default_graph_api_response_headers
          )
      end

      it 'returns true' do
        expect(subject.subscribe(access_token)).to be true
      end
    end

    context 'with an unsuccessful response' do
      let(:error_message) { 'Invalid OAuth access token.' }

      before do
        stub_request(:post, subscribed_apps_url)
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
        expect { subject.subscribe(access_token) }.to raise_error(
          Facebook::Messenger::Subscriptions::Error, error_message
        )
      end
    end
  end

  describe '.unsubscribe' do
    let(:access_token) { '<access token>' }

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
        expect(subject.unsubscribe(access_token)).to be true
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
        expect { subject.unsubscribe(access_token) }.to raise_error(
          Facebook::Messenger::Subscriptions::Error, error_message
        )
      end
    end
  end
end
