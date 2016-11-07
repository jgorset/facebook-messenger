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

        def reply(message)
          access_token = Facebook::Messenger.config.provider.access_token_for(
            recipient
          )

          Facebook::Messenger::Bot.deliver(message, access_token: access_token)
        end
      end
    end
  end
end
