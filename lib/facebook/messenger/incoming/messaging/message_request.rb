module Facebook
  module Messenger
    module Incoming
      module Messaging
        # The Message request class represents an
        # incoming Facebook Messenger message request accepted by the user
        class MessageRequest < Message
          def accept?
            @messaging['message_request'] == 'accept'
          end
        end
      end
    end
  end
end
