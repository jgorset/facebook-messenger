module Facebook
  module Messenger
    module Incoming
      #
      # Common attributes for all incoming data from Facebook.
      #
      module Common
        attr_reader :messaging

        #
        # Assign message to instance variable
        #
        # @param [Object] messaging Object of message.
        #
        def initialize(messaging)
          @messaging = messaging
        end

        #
        # Function return PSID of sender.
        # @see https://developers.facebook.com/docs/messenger-platform/identity
        #   Info about PSID.
        # @see https://developers.facebook.com/docs/messenger-platform/webhook#format
        #   Webhook event format.
        #
        # @return [String] PSID of sender.
        #
        def sender
          @messaging['sender']
        end

        #
        # Function return the page of id from which the message is arrived.
        #
        # @return [String] Facebook page id.
        #
        def recipient
          @messaging['recipient']
        end

        #
        # If the user responds to your message, the appropriate event
        # (messages, messaging_postbacks, etc.) will be sent to your webhook,
        # with a prior_message object appended. The prior_message object
        # includes the source of the message the user is responding to, as well
        # as the user_ref used for the original message send.
        #
        # @return [Hash] The 'prior_message' hash.
        #
        def prior_message
          @messaging['prior_message']
        end

        #
        # Function return timestamp when message is sent.
        #
        #
        # @return [Object] Message time sent.
        #
        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        #
        # Function send sender_action of 'typing_on' to sender.
        # @see https://developers.facebook.com/docs/messenger-platform/send-messages/sender-actions
        #   Info about sender actions.
        #
        # @return Send message to sender.
        #
        def typing_on
          payload = {
            recipient: sender,
            sender_action: 'typing_on'
          }

          deliver_payload(payload)
        end

        #
        # Function send sender_action of 'typing_off' to sender.
        # @see https://developers.facebook.com/docs/messenger-platform/send-messages/sender-actions
        #   Info about sender actions.
        #
        # @return Send message to sender.
        #
        def typing_off
          payload = {
            recipient: sender,
            sender_action: 'typing_off'
          }

          deliver_payload(payload)
        end

        #
        # Function send sender_action of 'mark_seen' to sender.
        # @see https://developers.facebook.com/docs/messenger-platform/send-messages/sender-actions
        #   Info about sender actions.
        #
        # @return Send message to sender.
        #
        def mark_seen
          payload = {
            recipient: sender,
            sender_action: 'mark_seen'
          }

          deliver_payload(payload)
        end

        #
        # Send reply to sender.
        #
        # @param [Hash] message Hash defining the message.
        #
        # @return Send reply to sender.
        #
        def reply(message)
          payload = {
            recipient: sender,
            message: message,
            message_type: Facebook::Messenger::Bot::MessageType::RESPONSE
          }

          deliver_payload(payload)
        end

        #
        # Function returns the configured access token.
        #
        # @return [String] Access token.
        #
        def access_token
          Facebook::Messenger.config.provider.access_token_for(recipient)
        end

        def app_secret_proof
          Facebook::Messenger.config.provider.app_secret_proof_for(recipient)
        end

        private

        def deliver_payload(payload)
          Facebook::Messenger::Bot.deliver(payload,
                                           access_token: access_token,
                                           app_secret_proof: app_secret_proof)
        end
      end
    end
  end
end
