module Facebook
  module Messenger
    module Incoming
      class Feed
        include Facebook::Messenger::Incoming::FeedCommon

        def id
          @change['value']['post_id']
        end
        def message
          @change['value']['message']
        end
      end
    end
  end
end
