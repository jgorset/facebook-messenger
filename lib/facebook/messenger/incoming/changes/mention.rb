module Facebook
  module Messenger
    module Incoming
      module Changes
        class Mention
          include Facebook::Messenger::Incoming::Changes::Common

          def comment_id
            @changes['comment_id']
          end

          def sender
            { 'id' => @changes['sender_id'], 'name' => @changes['sender_name'] }
          end

          def sent_at
            Time.at(@changes['created_time'])
          end

          def from_comment?
            @changes['item'] == 'comment'
          end

          def from_post?
            @changes['item'] == 'post'
          end
        end
      end
    end
  end
end
