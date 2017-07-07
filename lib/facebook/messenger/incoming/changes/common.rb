module Facebook
  module Messenger
    module Incoming
      module Changes
        # Common attributes for all incoming data from Facebook.
        module Common
          attr_reader :changes

          def initialize(changes)
            @changes = changes
          end

          def post_id
            @changes['post_id']
          end

          def tags
            Array(@changes['message_tags'])
          end

          def text
            @changes['message']
          end

          def verb
            @changes['verb']
          end

          def typing_on
            payload = {
                recipient: sender,
                sender_action: 'typing_on'
            }

            Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
          end

          def typing_off
            payload = {
                recipient: sender,
                sender_action: 'typing_off'
            }

            Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
          end

          def mark_seen
            payload = {
                recipient: sender,
                sender_action: 'mark_seen'
            }

            Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
          end

          def reply(message)
            payload = {
                recipient: sender,
                message: message
            }

            Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
          end

          def access_token
            Facebook::Messenger.config.provider.access_token_for(recipient)
          end
        end
      end
    end
  end
end
