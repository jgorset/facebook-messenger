module Facebook
  module Messenger
    # The Message class represents a Facebook Messenger message.
    class Message
      # messaging - A Hash describing a payload from Facebook.
      def initialize(messaging)
        @messaging = messaging
      end

      def id
        @messaging['message']['mid']
      end

      def sender
        @messaging['sender']
      end

      def seq
        @messaging['message']['seq']
      end

      def sent_at
        Time.at @messaging['timestamp']
      end

      def text
        @messaging['message']['text']
      end
    end
  end
end
