require 'httparty'

module Facebook
  module Messenger
    # This module handles setting welcome messages.
    #
    # https://developers.facebook.com/docs/messenger-platform/send-api-reference#welcome_message_configuration
    module Welcome
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def set(message)
        response = post '/thread_settings',
                        body: welcome_setting_for(message).to_json

        raise_errors(response)

        true
      end

      def unset
        response = post '/thread_settings',
                        body: welcome_setting_for(nil).to_json

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

      def welcome_setting_for(payload)
        {
          setting_type: 'call_to_actions',
          thread_state: 'new_thread',
          call_to_actions: payload ? [{ message: payload }] : []
        }
      end

      class Error < Facebook::Messenger::Error; end
    end
  end
end
