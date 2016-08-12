module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback
        include Facebook::Messenger::Concerns::DefaultOptions

        def payload
          @messaging['postback']['payload']
        end
      end
    end
  end
end
