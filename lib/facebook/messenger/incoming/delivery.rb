module Facebook
  module Messenger
    module Incoming
      # The Delivery class represents the receipt of a delivered message.
      class Delivery

        attr_reader :raw_payload

        def initialize(raw_payload)
          @raw_payload = raw_payload
        end

        def ids
          @raw_payload['delivery']['mids']
        end

        def at
          Time.at(@raw_payload['delivery']['watermark'] / 1000)
        end

        def seq
          @raw_payload['delivery']['seq']
        end

        def sender
          @raw_payload['sender']
        end

        def recipient
          @raw_payload['recipient']
        end
      end
    end
  end
end
