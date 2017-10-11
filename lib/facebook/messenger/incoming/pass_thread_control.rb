module Facebook
  module Messenger
    module Incoming
      # The PassThreadControl class represents the callback when thread
      # ownership for a user has been passed to your application
      #
      # https://developers.facebook.com/docs/messenger-platform/handover-protocol/pass-thread-control
      class PassThreadControl
        include Facebook::Messenger::Incoming::Common

        # The take_thread_control portion of the payload.
        class PassThreadControl
          def initialize(thread_control)
            @thread_control = thread_control
          end

          def new_owner_app_id
            @thread_control['new_owner_app_id']
          end

          def metadata
            @thread_control['metadata']
          end
        end

        def thread_control
          @thread_control ||= PassThreadControl.new(@messaging['pass_thread_control'])
        end
      end
    end
  end
end
