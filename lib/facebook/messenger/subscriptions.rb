require 'httparty'

module Facebook
  module Messenger
    # This module handles subscribing and unsubscribing Applications to Pages.
    module Subscriptions
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def subscribe(access_token)
        options = { query: { access_token: access_token } }

        response = post '/subscribed_apps', options

        raise_errors(response)

        true
      end

      def unsubscribe
        response = delete '/subscribed_apps'

        raise_errors(response)

        true
      end

      def raise_errors(response)
        raise Error, response['error']['message'] if response.key? 'error'
      end

      def default_options
        super.merge({})
      end

      class Error < Facebook::Messenger::Error; end
    end
  end
end
