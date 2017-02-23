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
          return if @messaging['postback']['referral'].nil?
          @referral ||= Referral::Referral.new(
            @messaging['postback']['referral']
          )
        end
      end
    end
  end
end
