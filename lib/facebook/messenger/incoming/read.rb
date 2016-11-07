module Facebook
  module Messenger
    module Incoming
      # The Read class represents the user reading a delivered message.
      class Read
        include Facebook::Messenger::Incoming::Common

        def at
          Time.at(@messaging['read']['watermark'] / 1000)
        end

        def seq
          @messaging['read']['seq']
        end
      end
    end
  end
end
