require 'facebook/messenger/incoming/message'
require 'facebook/messenger/incoming/delivery'

module Facebook
  module Messenger
    # The Incoming module parses and abstracts incoming requests from
    # Facebook Messenger.
    module Incoming
      # Parse the given payload.
      #
      # payload - A Hash describing a payload from Facebook.
      #
      # * https://developers.facebook.com/docs/messenger-platform/webhook-reference
      def self.parse(payload)
        {
          'message' => Message,
          'delivery' => Delivery
        }.each do |key, klass|
          return klass.new(payload) if payload.key? key
        end

        raise UnknownPayload, payload
      end

      class UnknownPayload < Facebook::Messenger::Error; end
    end
  end
end
