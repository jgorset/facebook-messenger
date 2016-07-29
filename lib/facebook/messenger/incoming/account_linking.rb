module Facebook
  module Messenger
    module Incoming
      # The AccountLinking class represents an incoming Facebook Messenger
      # Account Linking webhook, when the Linked Account
      # or Unlink Account call-to-action have been tapped
      #
      # https://developers.facebook.com/docs/messenger-platform/webhook-reference/account-linking
      class AccountLinking
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

        def status
          @messaging['account_linking']['status']
        end

        def authorization_code
          @messaging['account_linking']['authorization_code']
        end
      end
    end
  end
end
