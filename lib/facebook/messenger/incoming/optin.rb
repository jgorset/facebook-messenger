module Facebook
  module Messenger
    module Incoming
      # The Optin class represents an incoming Facebook Messenger optin,
      # which occurs when a user engages by using the Send-to-Messenger Plugin.
      #
      # https://developers.facebook.com/docs/messenger-platform/plugin-reference
      class Optin
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def sender
          @messaging['sender']
        end

        def recipient
          @messaging['recipient']
        end

        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        def ref
          @messaging['optin']['ref']
        end
      end
    end
  end
end
