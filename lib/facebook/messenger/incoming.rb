require 'facebook/messenger/incoming/changes/common'
require 'facebook/messenger/incoming/changes/comment'
require 'facebook/messenger/incoming/changes/mention'
require 'facebook/messenger/incoming/changes/post'
require 'facebook/messenger/incoming/messaging/common'
require 'facebook/messenger/incoming/messaging/message'
require 'facebook/messenger/incoming/messaging/message_echo'
require 'facebook/messenger/incoming/messaging/message_request'
require 'facebook/messenger/incoming/messaging/delivery'
require 'facebook/messenger/incoming/messaging/postback'
require 'facebook/messenger/incoming/messaging/optin'
require 'facebook/messenger/incoming/messaging/read'
require 'facebook/messenger/incoming/messaging/account_linking'
require 'facebook/messenger/incoming/messaging/referral'
require 'facebook/messenger/incoming/messaging/payment'
require 'facebook/messenger/incoming/messaging/policy_enforcement'
require 'facebook/messenger/incoming/messaging/pass_thread_control'
require 'facebook/messenger/incoming/messaging/game_play'
require 'facebook/messenger/incoming/messaging/message_reaction'

module Facebook
  module Messenger
    #
    # Module Incoming parses and abstracts incoming requests from Messenger.
    #
    module Incoming
      #
      # @return [Hash] Hash containing facebook messenger events and its event
      #   handler classes.
      EVENTS = {
        'message' => Messaging::Message,
        'delivery' => Messaging::Delivery,
        'postback' => Messaging::Postback,
        'optin' => Messaging::Optin,
        'read' => Messaging::Read,
        'account_linking' => Messaging::AccountLinking,
        'referral' => Messaging::Referral,
        'message_echo' => Messaging::MessageEcho,
        'message_request' => Messaging::MessageRequest,
        'payment' => Messaging::Payment,
        'policy_enforcement' => Messaging::PolicyEnforcement,
        'pass_thread_control' => Messaging::PassThreadControl,
        'game_play' => Messaging::GamePlay,
        'reaction' => Messaging::MessageReaction
      }.freeze

      FIELDS = {
        'comments' => Changes::Comment,
        'mention' => Changes::Mention,
        'posts' => Changes::Post,
      }.freeze

      # Parse the given payload and create new object of class related
      #   to event in payload.
      #
      # @see https://developers.facebook.com/docs/messenger-platform/webhook-reference
      #
      # @raise [Facebook::Messenger::Incoming::UnknownPayload] if event is not
      #   registered in EVENTS constant
      #
      # @param [Hash] payload A Hash describing a payload from Facebook.
      #
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

      #
      # Check if event is echo.
      #
      # @param [Hash] payload Request payload from facebook.
      #
      # @return [Boolean] If event is echo return true else false.
      #
      def self.payload_is_echo?(payload)
        payload.key?('message') && payload['message']['is_echo'] == true
      end

      #
      # Class UnknownPayload provides errors related to incoming messages.
      #
      class UnknownPayload < Facebook::Messenger::Error; end
    end
  end
end
