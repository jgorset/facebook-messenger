module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message
        include Facebook::Messenger::Incoming::Common

        def id
          @messaging['message']['mid']
        end

        def seq
          @messaging['message']['seq']
        end

        def text
          @messaging['message']['text']
        end

        def echo?
          @messaging['message']['is_echo']
        end

        def attachments
          @messaging['message']['attachments']
        end

        def quick_reply
          return unless @messaging['message']['quick_reply']

          @messaging['message']['quick_reply']['payload']
        end
      end
    end
  end
end
