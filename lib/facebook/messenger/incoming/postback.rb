module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback

        attr_reader :payload

        def initialize(payload)
          @payload = payload
        end

        def sender
          @payload['sender']
        end

        def recipient
          @payload['recipient']
        end

        def sent_at
          Time.at(@payload['timestamp'] / 1000)
        end

        def payload
          @payload['postback']['payload']
        end
      end
    end
  end
end
