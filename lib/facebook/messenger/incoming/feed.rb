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

        def verb
          @change['value']['verb']
        end

        def post_id
          @change['value']['post_id']
        end

        def comment_id
          @change['value']['comment_id']
        end

        def parent_id
          @change['value']['parent_id']
        end

        def from
          @change['value']['from']
        end
      end
    end
  end
end
