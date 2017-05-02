module Facebook
  module Messenger
    module Incoming
      # The Message class represents an incoming Facebook Messenger message.
      class Message
        include Facebook::Messenger::Incoming::Common

        ATTACHMENT_TYPES = ['image', 'audio', 'video', 'file','location','fallback']

        def id
          @messaging['message']['mid']
        end

        def seq
          @messaging['message']['seq']
        end

        def text
          @messaging['message']['text']
        end

        def echo?
          @messaging['message']['is_echo']
        end

        def attachments
          @messaging['message']['attachments']
        end

        def app_id
          @messaging['message']['app_id']
        end

        ATTACHMENT_TYPES.each do |attachment_type|
          define_method "#{attachment_type}_attachment?" do
            attachment_type?(attachment_type)
          end
        end

        def attachment_type
          return nil if attachments == nil
          attachments.first['type']
        end

        def attachment_url
          return nil if attachments == nil
          if ['image', 'audio', 'video', 'file'].include? attachment_type
            url = attachments.first['payload']['url']
          else
            url = nil
          end
          url
        end

        def location_coordinates
          return [] unless attachment_type?('location')
          coordinates_data = attachments.first['payload']
          [coordinates_data['coordinates.lat'], coordinates_data['coordinates.long']]
        end

        def quick_reply
          return unless @messaging['message']['quick_reply']

          @messaging['message']['quick_reply']['payload']
        end

        private

        def attachment_type?(attachment_type)
          attachments != nil && attachments.first['type'] == attachment_type
        end

      end
    end
  end
end
