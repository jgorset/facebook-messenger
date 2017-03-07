require 'httparty'

module Facebook
  module Messenger
    # This module handles subscribing and unsubscribing Applications to Pages.
    module Subscriptions
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def subscribe(access_token:)
        response = post '/subscribed_apps', query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def unsubscribe(access_token:)
        response = delete '/subscribed_apps', query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def raise_errors(response)
        raise Error, response['error'] if response.key? 'error'
      end

      class Error < Facebook::Messenger::FacebookError; end
    end
  end
end
