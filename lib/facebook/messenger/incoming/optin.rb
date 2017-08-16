module Facebook
  module Messenger
    module Incoming
      # The Optin class represents an incoming Facebook Messenger optin,
      # which occurs when a user engages by using the Send-to-Messenger Plugin.
      #
      # https://developers.facebook.com/docs/messenger-platform/plugin-reference
      class Optin
        include Facebook::Messenger::Incoming::Common

        def ref
          @messaging['optin']['ref']
        end

        def user_ref
          @messaging['optin']['user_ref']
        end
      end
    end
  end
end
