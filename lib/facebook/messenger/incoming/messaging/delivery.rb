module Facebook
  module Messenger
    module Incoming
      module Messaging
        # The Delivery class represents the receipt of a delivered message.
        # @see https://developers.facebook.com/docs/messenger-platform/reference/webhook-events/message-deliveries
        class Delivery
          include Facebook::Messenger::Incoming::Messaging::Common

          def ids
            @messaging['delivery']['mids']
          end

          def at
            Time.at(@messaging['delivery']['watermark'] / 1000)
          end

          def seq
            @messaging['delivery']['seq']
          end
        end
      end
    end
  end
end
