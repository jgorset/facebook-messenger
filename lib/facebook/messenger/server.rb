require 'rack'
require 'json'
require 'openssl'

module Facebook
  module Messenger
    class BadRequestError < Error; end

    X_HUB_SIGNATURE_MISSING_WARNING = <<-HEREDOC.freeze
      The X-Hub-Signature header is not present in the request. This is
      expected for the first webhook requests. If it continues after
      some time, check your app's secret token.
    HEREDOC

    #
    # This module holds the server that processes incoming messages from the
    # Facebook Messenger Platform.
    #
    class Server
      def self.call(env)
        new.call(env)
      end

      # Rack handler for request.
      def call(env)
        @request = Rack::Request.new(env)
        @response = Rack::Response.new

        if @request.get?
          verify
        elsif @request.post?
          receive
        else
          @response.status = 405
        end

        @response.finish
      end

      # @private
      private

      #
      # Function validates the verification request which is sent by Facebook
      #   to validate the entered endpoint.
      # @see https://developers.facebook.com/docs/graph-api/webhooks#callback
      #
      def verify
        if valid_verify_token?(@request.params['hub.verify_token'])
          @response.write @request.params['hub.challenge']
        else
          @response.write 'Error; wrong verify token'
        end
      end

      #
      # Function handles the webhook events.
      # @raise BadRequestError if the request is tampered.
      #
      def receive
        check_integrity

        trigger(parsed_body)
      rescue BadRequestError => error
        respond_with_error(error)
      end

      #
      # Check the integrity of the request.
      # @see https://developers.facebook.com/docs/messenger-platform/webhook#security
      #
      # @raise BadRequestError if the request has been tampered with.
      #
      def check_integrity
        # If app secret is not found in environment, return.
        # So for the security purpose always add provision in
        #   configuration provider to return app secret.
        return unless app_secret_for(parsed_body['entry'][0]['id'])

        unless signature.start_with?('sha1='.freeze)
          warn X_HUB_SIGNATURE_MISSING_WARNING

          raise BadRequestError, 'Error getting integrity signature'.freeze
        end

        raise BadRequestError, 'Error checking message integrity'.freeze \
          unless valid_signature?
      end

      # Returns a String describing the X-Hub-Signature header.
      def signature
        @request.env['HTTP_X_HUB_SIGNATURE'.freeze].to_s
      end

      #
      # Verify that the signature given in the X-Hub-Signature header matches
      # that of the body.
      #
      # @return [Boolean] true if request is valid else false.
      #
      def valid_signature?
        Rack::Utils.secure_compare(signature, signature_for(body))
      end

      #
      # Sign the given string.
      #
      # @return [String] A string describing its signature.
      #
      def signature_for(string)
        format('sha1=%<string>s'.freeze, string: generate_hmac(string))
      end

      # Generate a HMAC signature for the given content.
      def generate_hmac(content)
        content_json = JSON.parse(content, symbolize_names: true)
        facebook_page_id = content_json[:entry][0][:id]

        OpenSSL::HMAC.hexdigest('sha1'.freeze,
                                app_secret_for(facebook_page_id),
                                content)
      end

      # Returns a String describing the bot's configured app secret.
      def app_secret_for(facebook_page_id)
        Facebook::Messenger.config.provider.app_secret_for(facebook_page_id)
      end

      # Checks whether a verify token is valid.
      def valid_verify_token?(token)
        Facebook::Messenger.config.provider.valid_verify_token?(token)
      end

      # Returns a String describing the request body.
      def body
        @body ||= @request.body.read
      end

      #
      # Returns a Hash describing the parsed request body.
      # @raise JSON::ParserError if body hash is not valid.
      #
      # @return [JSON] Parsed body hash.
      #
      def parsed_body
        @parsed_body ||= JSON.parse(body)
      rescue JSON::ParserError
        raise BadRequestError, 'Error parsing request body format'
      end

      #
      # Function hand over the webhook event to handlers.
      #
      # @param [Hash] events Parsed body hash in webhook event.
      #
      #
      # From Messanger
      # {"object"=>"page", "entry"=>[{"id"=>"383797635461484", "time"=>1545920435011, "messaging"=>[{"sender"=>{"id"=>"2082333815123543"}, "recipient"=>{"id"=>"383797635461484"}, "timestamp"=>1545919826000, "message"=>{"mid"=>"lUPg321g3_P8TjjDC42-M6NNHKKIlrHcS9LyQirKytz5aRu21OGAgzqXzPFE03Un-kd96imvF5YAQlwT45hPZw", "seq"=>95144, "text"=>"test"}}]}]}
      # From Update Feed
      # {"entry"=>[{"changes"=>[{"field"=>"feed", "value"=>{"from"=>{"id"=>"383797635461484", "name"=>"Cuk"}, "item"=>"status", "post_id"=>"383797635461484_509921402849106", "verb"=>"add", "published"=>1, "created_time"=>1545920060, "message"=>"Hello"}}], "id"=>"383797635461484", "time"=>1545920061}], "object"=>"page"}
      # {"entry"=>[{"changes"=>[{"field"=>"feed", "value"=>{"from"=>{"id"=>"383797635461484", "name"=>"Cuk"}, "item"=>"status", "post_id"=>"383797635461484_509922592848987", "verb"=>"add", "published"=>1, "created_time"=>1545920243, "message"=>"My name luay"}}], "id"=>"383797635461484", "time"=>1545920244}], "object"=>"page"}
      # From Comment Feed
      # {"entry"=>[{"changes"=>[{"field"=>"feed", "value"=>{"from"=>{"id"=>"383797635461484", "name"=>"Cuk"}, "item"=>"comment", "comment_id"=>"509922592848987_509922852848961", "post_id"=>"383797635461484_509922592848987", "verb"=>"add", "parent_id"=>"383797635461484_509922592848987", "created_time"=>1545920296, "post"=>{"type"=>"status", "updated_time"=>"2018-12-27T14:18:16+0000", "promotion_status"=>"ineligible", "permalink_url"=>"https://www.facebook.com/permalink.php?story_fbid=509922592848987&id=383797635461484", "id"=>"383797635461484_509922592848987", "status_type"=>"mobile_status_update", "is_published"=>true}, "message"=>"test"}}], "id"=>"383797635461484", "time"=>1545920297}], "object"=>"page"}

      def trigger(events)
        # Facebook may batch several items in the 'entry' array during
        # periods of high load.
        events['entry'.freeze].each do |entry|
          next if (!entry['messaging'.freeze] && !entry['changes'.freeze])

          # If the application has subscribed to webhooks other than Messenger,
          # 'messaging' won't be available and it is not relevant to us.
          if entry['messaging'.freeze]
            # Facebook may batch several items in the 'messaging' array during
            # periods of high load.
            entry['messaging'.freeze].each do |messaging|
              Facebook::Messenger::Bot.receive(messaging)
            end
          elsif entry['changes'.freeze]
            entry['changes'.freeze].each do |changes|
              next if Facebook::Messenger.config.fallback_library.blank? && !Facebook::Messenger.config.fallback_library.is_a?(Class)
              Facebook::Messenger.config.fallback_library.new(changes)
            end
          end
        end
      end

      #
      # If received request is tampered, sent 400 code in response.
      #
      # @param [Object] error Error object.
      #
      def respond_with_error(error)
        @response.status = 400
        @response.write(error.message)
        @response.headers['Content-Type'.freeze] = 'text/plain'.freeze
      end
    end
  end
end
