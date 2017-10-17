require 'httparty'

module Facebook
  module Messenger
    # This module handles handover protocol (passing/taking thread control, and
    # getting list of secondary receivers)
    #
    # https://developers.facebook.com/docs/messenger-platform/handover-protocol
    module Handover
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      format :json

      module_function

      def pass_thread_control(settings, access_token:)
        response = post '/pass_thread_control', body: settings.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      def take_thread_control(settings, access_token:)
        response = post '/take_thread_control', body: settings.to_json, query: {
          access_token: access_token
        }

        raise_errors(response)

        true
      end

      # From Docs: Only the app with the Primary Receiver role for the page may
      # use this API.
      def secondary_receivers(access_token:)
        response = get '/secondary_receivers', query: {
          fields: 'id,name',
          access_token: access_token
        }

        raise_errors(response)

        response.parsed_response
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