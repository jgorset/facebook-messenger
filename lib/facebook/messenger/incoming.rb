require 'facebook/messenger/incoming/common'
require 'facebook/messenger/incoming/message'
require 'facebook/messenger/incoming/delivery'
require 'facebook/messenger/incoming/postback'
require 'facebook/messenger/incoming/optin'
require 'facebook/messenger/incoming/read'
require 'facebook/messenger/incoming/account_linking'
require 'facebook/messenger/incoming/referral'

module Facebook
  module Messenger
    # The Incoming module parses and abstracts incoming requests from
    # Facebook Messenger.
    module Incoming
      EVENTS = {
        'message' => Message,
        'delivery' => Delivery,
        'postback' => Postback,
        'optin' => Optin,
        'read' => Read,
        'account_linking' => AccountLinking,
        'referral' => Referral
      }.freeze

      # Parse the given payload.
      #
      # payload - A Hash describing a payload from Facebook.
      #
      # * https://developers.facebook.com/docs/messenger-platform/webhook-reference
      def self.parse(payload)
        EVENTS.each do |event, klass|
          return klass.new(payload) if payload.key?(event)
        end

        raise UnknownPayload, payload
      end

      class UnknownPayload < Facebook::Messenger::Error; end
    end
  end
end
