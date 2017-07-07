require 'facebook/messenger/incoming/changes/common'
require 'facebook/messenger/incoming/changes/comment'
require 'facebook/messenger/incoming/changes/mention'
require 'facebook/messenger/incoming/changes/post'
require 'facebook/messenger/incoming/messaging/common'
require 'facebook/messenger/incoming/messaging/message'
require 'facebook/messenger/incoming/messaging/message_echo'
require 'facebook/messenger/incoming/messaging/delivery'
require 'facebook/messenger/incoming/messaging/postback'
require 'facebook/messenger/incoming/messaging/optin'
require 'facebook/messenger/incoming/messaging/read'
require 'facebook/messenger/incoming/messaging/account_linking'
require 'facebook/messenger/incoming/messaging/referral'

module Facebook
  module Messenger
    # The Incoming module parses and abstracts incoming requests from
    # Facebook Messenger.
    module Incoming
      EVENTS = {
        'message' => Messaging::Message,
        'delivery' => Messaging::Delivery,
        'postback' => Messaging::Postback,
        'optin' => Messaging::Optin,
        'read' => Messaging::Read,
        'account_linking' => Messaging::AccountLinking,
        'referral' => Messaging::Referral,
        'message_echo' => Messaging::MessageEcho,
      }.freeze

      FIELDS = {
        'comments' => Changes::Comment,
        'mention' => Changes::Mention,
        'posts' => Changes::Post,
      }.freeze

      # Parse the given payload.
      #
      # payload - A Hash describing a payload from Facebook.
      #
      # * https://developers.facebook.com/docs/messenger-platform/webhook-reference
      def self.parse(payload)
        return Messaging::MessageEcho.new(payload) if payload_is_echo?(payload)

        EVENTS.each do |event, klass|
          return klass.new(payload) if payload.key?(event)
        end

        FIELDS.each do |field, klass|
          return klass.new(payload['value']) if field == payload['field']
        end

        raise UnknownPayload, payload
      end

      def self.payload_is_echo?(payload)
        payload.key?('message') && payload['message']['is_echo'] == true
      end

      class UnknownPayload < Facebook::Messenger::Error; end
    end
  end
end
