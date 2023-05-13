module Facebook
  module Messenger
    module Incoming
      class Leadgen
        include Facebook::Messenger::Incoming::FeedCommon

        def id
          @change['value']['leadgen_id']
        end
      end
    end
  end
end
