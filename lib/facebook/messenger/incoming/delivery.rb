module Facebook
  module Messenger
    module Incoming
      # The Delivery class represents the receipt of a delivered message.
      class Delivery
        def initialize(payload)
          @payload = payload
        end

        def ids
          @payload['delivery']['mids']
        end

        def last_message_delivered_at
          Time.at(@payload['delivery']['watermark'] / 1000)
        end

        def seq
          @payload['delivery']['seq']
        end

        def sender
          @payload['sender']
        end

        def recipient
          @payload['recipient']
        end
      end
    end
  end
end
