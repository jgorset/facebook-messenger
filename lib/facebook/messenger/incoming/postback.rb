module Facebook
  module Messenger
    module Incoming
      # The Postback class represents an incoming Facebook Messenger postback.
      class Postback
        include Facebook::Messenger::Incoming::Common

        def payload
          @messaging['postback']['payload']
        end

        def referral
          @referral ||= Referral::Referral.new(
            @messaging['postback']['referral']
          ) unless @messaging['postback']['referral'].nil?
        end
      end
    end
  end
end
