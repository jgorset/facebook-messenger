module Facebook
  module Messenger
    module Incoming
      module Messaging
        # The Optin class represents an incoming Facebook Messenger optin,
        # which occurs when a user engages by using the Send-to-Messenger Plugin.
        #
        # https://developers.facebook.com/docs/messenger-platform/plugin-reference
        class Optin
          include Facebook::Messenger::Incoming::Messaging::Common

          def ref
            @messaging['optin']['ref']
          end
        end
      end
    end
  end
end
