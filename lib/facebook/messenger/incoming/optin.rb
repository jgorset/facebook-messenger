module Facebook
  module Messenger
    module Incoming
      # The Optin class represents an incoming Facebook Messenger optin,
      # which occurs when a user engages by using the Send-to-Messenger Plugin.
      #
      # https://developers.facebook.com/docs/messenger-platform/plugin-reference
      class Optin

        attr_reader :payload

        def initialize(payload)
          @payload = payload
        end

        def sender
          @payload['sender']
        end

        def recipient
          @payload['recipient']
        end

        def sent_at
          Time.at(@payload['timestamp'] / 1000)
        end

        def ref
          @payload['optin']['ref']
        end
      end
    end
  end
end
