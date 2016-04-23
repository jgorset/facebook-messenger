module Facebook
  module Messenger
    # The Bot module sends and receives messages.
    module Bot
      include HTTParty

      base_uri 'https://graph.facebook.com/v2.6/me'

      EVENTS = [:message].freeze

      class << self
        def hooks
          @hooks ||= {}
        end

        def unhook
          @hooks = {}
        end

        # Deliver a message with the given payload.
        #
        # message - A Hash describing the recipient and the message*.
        #
        # * https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
        #
        # Returns a String describing the message ID if the message was sent,
        # or raises an exception if it was not.
        def deliver(message)
          response = post '/messages', query: {
            access_token: Facebook::Messenger.config.access_token
          }, body: message

          raise_errors_from(response)

          response['message_id']
        end

        def on(event, &block)
          unless EVENTS.include? event
            raise ArgumentError,
                  "#{event} is not a valid event; " \
                  "available events are #{EVENTS.join(',')}"
          end

          hooks[event] = block
        end

        def receive(messaging)
          trigger(
            event_from_payload(messaging), parse(messaging)
          )
        end

        def trigger(event, *args)
          @hooks.fetch(event).call(*args)
        rescue KeyError
          $stderr.puts "Ignoring #{event} (no hook registered)"
        end

        # Parse the message from Facebook.
        #
        # messaging - A Hash describing a payload from Facebook.
        #
        # Returns a Facebook::Messenger::Message instance.
        def parse(messaging)
          Facebook::Messenger::Message.new(messaging)
        end

        # Raise any errors in the given response.
        #
        # response - A HTTParty::Response object.
        #
        # Returns nil if no errors were found, otherwises raises appropriately.
        def raise_errors_from(response)
          return unless response.key? 'error'
          error = response['error']

          raise(
            error_class_from_error_code(error['code']),
            (error['error_data'] || error['message'])
          )
        end

        # Find the appropriate event for the given payload.
        #
        # payload - A Hash describing a payload from Facebook.
        def event_from_payload(payload)
          {
            'message' => :message,
            'delivery' => :delivery,
            'postback' => :postback,
            'optin' => :optin
          }.each do |key, event|
            return event if payload.key? key
          end
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
          }[error_code] || Facebook::Messenger::Error
        end
      end

      class RecipientNotFound < Facebook::Messenger::Error; end
      class PermissionDenied < Facebook::Messenger::Error; end
      class InternalError < Facebook::Messenger::Error; end
      class UnregisteredEvent < Facebook::Messenger::Error; end
    end
  end
end
