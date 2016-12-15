module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback
        include Facebook::Messenger::Incoming::Common
        attr_reader :referral

        def initialize(messaging)
          super

          @referral = Referral::Referral.new(
            messaging['postback']['referral']
          ) if messaging['postback'] && messaging['postback']['referral']
        end

        def payload
          @messaging['postback']['payload']
        end
      end
    end
  end
end
