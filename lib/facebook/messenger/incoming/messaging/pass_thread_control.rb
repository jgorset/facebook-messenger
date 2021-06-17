module Facebook
  module Messenger
    module Incoming
      module Messaging
        # The PassThreadControl class represents an incoming Facebook Messenger
        # pass thread control event.
        #
        # @see https://developers.facebook.com/docs/messenger-platform/handover-protocol/pass-thread-control
        # @see https://developers.facebook.com/docs/messenger-platform/reference/handover-protocol/pass-thread-control
        class PassThreadControl
          include Facebook::Messenger::Incoming::Messaging::Common

          def new_owner_app_id
            @messaging['pass_thread_control']['new_owner_app_id']
          end

          def metadata
            @messaging['pass_thread_control']['metadata']
          end
        end
      end
    end
  end
end
