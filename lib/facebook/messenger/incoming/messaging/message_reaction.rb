module Facebook
  module Messenger
    module Incoming
      module Messaging
        # The Message echo class represents an incoming Facebook Messenger message
        # @see https://developers.facebook.com/docs/messenger-platform/reference/webhook-events/message-reactions
        class MessageReaction
          include Facebook::Messenger::Incoming::Messaging::Common

          def action
            @messaging['reaction']['action']
          end

          def emoji
            @messaging['reaction']['emoji']
          end

          def reaction
            @messaging['reaction']['reaction']
          end
        end
      end
    end
  end
end
