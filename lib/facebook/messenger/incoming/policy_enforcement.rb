module Facebook
  module Messenger
    module Incoming
      class PolicyEnforcement
        include Facebook::Messenger::Incoming::Common

        def action
          @messaging['policy-enforcement']['action']
        end

        def reason
          @messaging['policy-enforcement']['reason']
        end
      end
    end
  end
end
