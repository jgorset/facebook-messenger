module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback

        attr_reader :raw_payload

        def initialize(raw_payload)
          @raw_payload = raw_payload
        end

        def sender
          @raw_payload['sender']
        end

        def recipient
          @raw_payload['recipient']
        end

        def sent_at
          Time.at(@raw_payload['timestamp'] / 1000)
        end

        def payload
          @raw_payload['postback']['payload']
        end
      end
    end
  end
end
