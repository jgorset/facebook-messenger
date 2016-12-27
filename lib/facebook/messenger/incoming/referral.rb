module Facebook
  module Messenger
    module Incoming
      # The Referral class represents an incoming Facebook Messenger referral.
      #
      # https://developers.facebook.com/docs/messenger-platform/referral-params
      class Referral
        include Facebook::Messenger::Incoming::Common

        # The referral portion of the payload.
        class Referral
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

        def referral
          @referral ||= Referral.new(@messaging['referral'])
        end

        def ref
          referral.ref
        end
      end
    end
  end
end
