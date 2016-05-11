module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback

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

        def payload
          @messaging['postback']['payload']
        end
      end
    end
  end
end
