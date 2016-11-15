module Facebook
  module Messenger
    module Incoming
      # The Referral class represents an incoming Facebook Messenger Referral Param webhook
      #
      # https://developers.facebook.com/docs/messenger-platform/referral-params
      class Referral
        include Facebook::Messenger::Incoming::Common

        class Param
          def initialize(referral)
            @referral = referral
          end

          def ref
            @referral['ref']
          end

          def source
            @referral['source']
          end

          def type
            @referral['type']
          end
        end

        def param
          @param ||= Param.new(@messaging['referral'])
        end
      end
    end
  end
end
