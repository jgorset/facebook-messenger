module Facebook
  module Messenger
    module Incoming
      # Common attributes for all incoming data from Facebook.
      module Common
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

        def show_typing(is_active)
          payload = {
            recipient: sender,
            sender_action: is_active ? 'typing_on' : 'typing_off'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def mark_as_seen
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

        def reply_with_text(text)
          reply(text: text)
        end

        def reply_with_image(image_url)
          reply(
            attachment: {
              type: 'image',
              payload: {
                url: image_url
              }
            }
          )
        end

        def reply_with_audio(audio_url)
          reply(
            attachment: {
              type: 'audio',
              payload: {
                url: audio_url
              }
            }
          )
        end

        def reply_with_video(_video_url)
          reply(
            attachment: {
              type: 'video',
              payload: {
                url: viedo_url
              }
            }
          )
        end

        def reply_with_file(file_url)
          reply(
            attachment: {
              type: 'file',
              payload: {
                url: file_url
              }
            }
          )
        end

        def ask_for_location(text)
          reply(text: text,
                quick_replies: [
                  {
                    content_type: 'location'
                  }
                ])
        end

        def attachments?
          attachments != nil
        end

        def location_attachment?
          attachments? && attachments.first['type'] == 'location'
        end

        def image_attachment?
          attachments? && attachments.first['type'] == 'image'
        end

        def video_attachment?
          attachments? && attachments.first['type'] == 'video'
        end

        def audio_attachment?
          attachments? && attachments.first['type'] == 'audio'
        end

        def file_attachment?
          attachments? && attachments.first['type'] == 'file'
        end

        def location_coordinates
          coordinates = attachments.first['payload']['coordinates']
          [coordinates['lat'], coordinates['long']]
        end

        def access_token
          Facebook::Messenger.config.provider.access_token_for(recipient)
        end
      end
    end
  end
end
