module Facebook
  module Messenger
    module Incoming
      # The Delivery class represents the receipt of a delivered message.
      class Delivery
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def ids
          @messaging['delivery']['mids']
        end

        def at
          Time.at(@messaging['delivery']['watermark'] / 1000)
        end

        def seq
          @messaging['delivery']['seq']
        end

        def sender
          @messaging['sender']
        end

        def recipient
          @messaging['recipient']
        end
      end
    end
  end
end
