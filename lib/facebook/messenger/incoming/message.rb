module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def id
          @messaging['message']['mid']
        end

        def sender
          @messaging['sender']
        end

        def recipient
          @messaging['recipient']
        end

        def seq
          @messaging['message']['seq']
        end

        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        def text
          @messaging['message']['text']
        end

        def attachments
          @messaging['message']['attachments']
        end
        
        def quick_replies
          @messaging['message']['quick_reply']
        end
      end
    end
  end
end
