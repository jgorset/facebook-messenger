module Facebook
  module Messenger
    module Incoming
      module FeedCommon
        attr_reader :change

        def initialize(change)
          @change = change
        end

        def item
          @change['item']
        end
      end
    end
  end
end
