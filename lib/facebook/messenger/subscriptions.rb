require 'httparty'

module Facebook
  module Messenger
    # This module handles subscribing and unsubscribing Applications to Pages.
    module Subscriptions
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def subscribe(options = {})
        access_token = options[:access_token]

        req_options = {}
        if access_token.present?
          req_options[:query] = { access_token: access_token }
        end

        response = post '/subscribed_apps', req_options

        raise_errors(response)

        true
      end

      def unsubscribe(options = {})
        access_token = options[:access_token]

        req_options = {}
        if access_token.present?
          req_options[:query] = { access_token: access_token }
        end

        response = delete '/subscribed_apps', req_options

        raise_errors(response)

        true
      end

      def raise_errors(response)
        raise Error, response['error']['message'] if response.key? 'error'
      end

      def default_options
        super.merge(
          query: {
            access_token: Facebook::Messenger.config.access_token
          }
        )
      end

      class Error < Facebook::Messenger::Error; end
    end
  end
end
