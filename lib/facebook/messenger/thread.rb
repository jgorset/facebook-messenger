require 'httparty'

module Facebook
  module Messenger
    # This module handles changing thread settings.
    #
    # https://developers.facebook.com/docs/messenger-platform/thread-settings
    module Thread
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def set(settings, access_token:)
        response = post '/thread_settings', body: settings.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def unset(settings, access_token:)
        response = delete '/thread_settings', body: settings.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def raise_errors(response)
        raise Error, response['error'] if response.key? 'error'
      end

      def default_options
        super.merge(
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      end

      class Error < Facebook::Messenger::FacebookError; end
    end
  end
end
