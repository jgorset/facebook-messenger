module Facebook
  module Messenger
    module Incoming
      # The Referral class represents an incoming Facebook Messenger pass_thread_control.
      #
      # https://developers.facebook.com/docs/messenger-platform/referral-params
      class PassThreadControl
        include Facebook::Messenger::Incoming::Common

        class PassThreadControl
          def initialize(pass_thread_control)
            @pass_thread_control = pass_thread_control
          end
          
          def metadata
            @referral['metadata']
          end
        end

        def pass_thread_control
          @pass_thread_control ||= PassThreadControl.new(@messaging['pass_thread_control'])
        end

      end
    end
  end
end
