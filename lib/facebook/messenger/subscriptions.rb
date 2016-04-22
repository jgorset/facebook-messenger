require 'httparty'

module Facebook
  module Messenger
    # This module handles subscribing and unsubscribing Applications to Pages.
    module Subscriptions
      include HTTParty

      URL = 'https://graph.facebook.com/v2.6/me/subscribed_apps'.freeze

      def self.subscribe(access_token)
        response = post URL, query: { access_token: access_token }

        raise_errors(response)

        true
      end

      def self.unsubscribe(access_token)
        response = delete URL, query: { access_token: access_token }

        raise_errors(response)

        true
      end

      class Error < Facebook::Messenger::Error; end

      def self.raise_errors(response)
        raise Error, response['error']['message'] if response.key? 'error'
      end
    end
  end
end
