module Facebook
  module Messenger
    module Incoming
      # The TakeThreadControl class represents the callback when thread
      # ownership for a user has been taken away from your application
      #
      # https://developers.facebook.com/docs/messenger-platform/handover-protocol/take-thread-control
      class TakeThreadControl
        include Facebook::Messenger::Incoming::Common

        # The take_thread_control portion of the payload.
        class TakeThreadControl
          def initialize(thread_control)
            @thread_control = thread_control
          end

          def previous_owner_app_id
            @thread_control['previous_owner_app_id']
          end

          def metadata
            @thread_control['metadata']
          end
        end

        def thread_control
          @thread_control ||= TakeThreadControl.new(@messaging['take_thread_control'])
        end
      end
    end
  end
end
