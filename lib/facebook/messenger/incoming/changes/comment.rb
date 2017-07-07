module Facebook
  module Messenger
    module Incoming
      module Changes
        class Comment
          include Facebook::Messenger::Incoming::Changes::Common

          def comment_id
            @changes['comment_id']
          end

          def sender
            @changes['from']
          end

          def sent_at
            Time.parse(@changes['created_time'])
          end

          def url
            @changes['permalink_url']
          end
        end
      end
    end
  end
end
