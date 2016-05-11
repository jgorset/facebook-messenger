module Facebook
  module Messenger
    module Incoming
      # The Optin class represents an incoming Facebook Messenger optin,
      # which occurs when a user engages by using the Send-to-Messenger Plugin.
      #
      # https://developers.facebook.com/docs/messenger-platform/plugin-reference
      class Optin

        attr_reader :raw_payload

        def initialize(raw_payload)
          @raw_payload = raw_payload
        end

        def sender
          @raw_payload['sender']
        end

        def recipient
          @raw_payload['recipient']
        end

        def sent_at
          Time.at(@raw_payload['timestamp'] / 1000)
        end

        def ref
          @raw_payload['optin']['ref']
        end
      end
    end
  end
end
