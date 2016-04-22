module Facebook
  module Messenger
    # This module handles subscribing and unsubscribing Applications to Pages.
    class Bot
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      def initialize(access_token)
        @access_token = access_token
      end

      # Send a message with the given payload.
      #
      # payload - A Hash describing the recipient and the message*.
      #
      # * https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
      #
      # Returns a String describing the message ID if the message was sent,
      # or raises an exception if it was not.
      def message(payload)
        response = self.class.post '/messages', query: {
          access_token: @access_token
        }, body: payload

        raise_errors_from(response)

        response['message_id']
      end

      # Raise any errors in the given response.
      #
      # response - A HTTParty::Response object..
      #
      # Returns nil if no errors were found, otherwises raises appropriately.
      def raise_errors_from(response)
        return unless response.key? 'error'
        error = response['error']

        raise error_class_from_error_code(error['code']), error['error_data']
      end

      # Find the appropriate error class for the given error code.
      #
      # error_code - An Integer describing an error code.
      #
      # Returns an error class, or raises KeyError if none was found.
      def error_class_from_error_code(error_code)
        {
          100 => RecipientNotFound,
          10 => PermissionDenied,
          2 => InternalError
        }.fetch(error_code)
      end

      class RecipientNotFound < Facebook::Messenger::Error; end
      class PermissionDenied < Facebook::Messenger::Error; end
      class InternalError < Facebook::Messenger::Error; end
    end
  end
end
