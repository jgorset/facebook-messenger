module Facebook
  module Messenger
    module Incoming
      # Common attributes for all incoming data from Facebook.
      module Common
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def sender
          @messaging['sender']
        end

        def recipient
          @messaging['recipient']
        end

        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        def type
          payload = {
            recipient: sender,
            sender_action: 'typing_on'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def reply(message)
          payload = {
            recipient: sender,
            message: message
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def access_token
          Facebook::Messenger.config.provider.access_token_for(recipient)
        end
      end
    end
  end
end
