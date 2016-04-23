module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message
        def initialize(payload)
          @payload = payload
        end

        def id
          @payload['message']['mid']
        end

        def sender
          @payload['sender']
        end

        def seq
          @payload['message']['seq']
        end

        def sent_at
          Time.at(@payload['timestamp'] / 1000)
        end

        def text
          @payload['message']['text']
        end
      end
    end
  end
end
