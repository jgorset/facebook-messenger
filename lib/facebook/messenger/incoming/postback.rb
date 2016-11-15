module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback
        include Facebook::Messenger::Incoming::Common
        attr_reader :referral_param

        def initialize(messaging)
          super
          @referral_param ||= Facebook::Messenger::Incoming::Referral::Param.new(messaging['postback']['referral']) if messaging['postback']['referral']
        end

        def payload
          @messaging['postback']['payload']
        end
      end
    end
  end
end
