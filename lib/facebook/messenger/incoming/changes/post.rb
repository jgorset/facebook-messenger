module Facebook
  module Messenger
    module Incoming
      module Changes
        class Post
          include Facebook::Messenger::Incoming::Changes::Common

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
