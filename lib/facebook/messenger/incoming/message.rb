module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message

        attr_reader :raw_payload

        def initialize(raw_payload)
          @raw_payload = raw_payload
        end

        def id
          @raw_payload['message']['mid']
        end

        def sender
          @raw_payload['sender']
        end

        def seq
          @raw_payload['message']['seq']
        end

        def sent_at
          Time.at(@raw_payload['timestamp'] / 1000)
        end

        def text
          @raw_payload['message']['text']
        end
      end
    end
  end
end
