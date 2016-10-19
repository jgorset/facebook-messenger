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

      def set(settings, options = {})
        access_token = options[:access_token]

        req_options = { body: settings.to_json }
        if access_token.present?
          req_options[:query] = { access_token: access_token }
        end

        response = post '/thread_settings', req_options

        raise_errors(response)

        true
      end

      def unset(settings, options = {})
        access_token = options[:access_token]

        req_options = { body: settings.to_json }
        if access_token.present?
          req_options[:query] = { access_token: access_token }
        end

        response = delete '/thread_settings', req_options

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
          },
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      end

      class Error < Facebook::Messenger::Error; end
    end
  end
end
