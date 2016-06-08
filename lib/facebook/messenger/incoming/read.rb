module Facebook
  module Messenger
    module Incoming
      # The Read class represents the user reading a delivered message.
      class Read
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def at
          Time.at(@messaging['read']['watermark'] / 1000)
        end

        def seq
          @messaging['read']['seq']
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
