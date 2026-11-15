module Facebook
  module Messenger
    module Incoming
      module FeedCommon
        attr_reader :change

        def initialize(change)
          @change = change
        end

        def item
          @change['value']['item']
        end

        # The id of the page the change happened on (the webhook entry id).
        def page_id
          @change.dig('entry', 'id')
        end
      end
    end
  end
end
