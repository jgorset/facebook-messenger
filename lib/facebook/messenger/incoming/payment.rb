module Facebook
  module Messenger
    module Incoming
      # The Payment class represents a successful purchase using the Buy Button
      #
      # https://developers.facebook.com/docs/messenger-platform/reference/webhook-events/payment
      class Payment
        include Facebook::Messenger::Incoming::Common

        # The payment portion of the payload.
        class Payment
          def initialize(payment)
            @payment = payment
          end

          def payload
            @payment['payload']
          end

          def user_info
            @payment['requested_user_info']
          end

          def payment_credential
            @payment['payment_credential']
          end

          def amount
            @payment['amount']
          end

          def shipping_option_id
            @payment['shipping_option_id']
          end
        end

        def payment
          @payment ||= Payment.new(@messaging['payment'])
        end
      end
    end
  end
end
