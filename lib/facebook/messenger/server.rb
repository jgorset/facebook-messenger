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

    # This module holds the server that processes incoming messages from the
    # Facebook Messenger Platform.
    class Server
      def self.call(env)
        new.call(env)
      end

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

      private

      def verify
        if valid_verify_token_for?(@request.params['hub.verify_token'])
          @response.write @request.params['hub.challenge']
        else
          @response.write 'Error; wrong verify token'
        end
      end

      def receive
        body_json = JSON.parse(body, symbolize_names: true)

        # Get Facebook page id regardless of the entry type
        facebook_page_id = body_json[:entry][0][:id]

        check_integrity if app_secret_for(facebook_page_id)

        events = parse_events

        trigger_events(events)
      rescue BadRequestError => error
        respond_with_error(error)
      end

      # Check the integrity of the request.
      #
      # Raises BadRequestError if the request has been tampered with.
      #
      # Returns nothing.
      def check_integrity
        unless signature.start_with?('sha1='.freeze)
          $stderr.puts(X_HUB_SIGNATURE_MISSING_WARNING)

          raise BadRequestError, 'Error getting integrity signature'.freeze
        end

        raise BadRequestError, 'Error checking message integrity'.freeze \
          unless valid_signature?
      end

      # Returns a String describing the X-Hub-Signature header.
      def signature
        @request.env['HTTP_X_HUB_SIGNATURE'.freeze].to_s
      end

      # Verify that the signature given in the X-Hub-Signature header matches
      # that of the body.
      #
      # Returns a Boolean.
      def valid_signature?
        Rack::Utils.secure_compare(signature, signature_for(body))
      end

      # Sign the given string.
      #
      # Returns a String describing its signature.
      def signature_for(string)
        format('sha1=%s'.freeze, generate_hmac(string))
      end

      # Generate a HMAC signature for the given content.
      def generate_hmac(content)
        content_json = JSON.parse(content, symbolize_names: true)

        # Get Facebook page id regardless of the entry type
        facebook_page_id = content_json.dig(:entry, 0, :id)

        OpenSSL::HMAC.hexdigest('sha1'.freeze,
                                app_secret(facebook_page_id),
                                content)
      end

      # Returns a String describing the bot's configured app secret.
      def app_secret_for(facebook_page_id)
        if Facebook::Messenger.config.config_provider_class
          config_provider = Facebook::Messenger.config.config_provider_class.new
          config_provider.app_secret_for(facebook_page_id)
        else
          Facebook::Messenger.config.app_secret
        end
      end

      # Checks whether a verify token is valid.
      def valid_verify_token_for?(token)
        if Facebook::Messenger.config.config_provider_class
          config_provider = Facebook::Messenger.config.config_provider_class.new
          config_provider.valid_verify_token_for?(token)
        else
          Facebook::Messenger.config.verify_token == token
        end
      end

      # Returns a String describing the request body.
      def body
        @body ||= @request.body.read
      end

      def parse_events
        JSON.parse(body)
      rescue JSON::ParserError
        raise BadRequestError, 'Error parsing request body format'
      end

      def trigger_events(events)
        # Facebook may batch several items in the 'entry' array during
        # periods of high load.
        events['entry'.freeze].each do |entry|
          # Facebook may batch several items in the 'messaging' array during
          # periods of high load.
          entry['messaging'.freeze].each do |messaging|
            Facebook::Messenger::Bot.receive(messaging)
          end
        end
      end

      def respond_with_error(error)
        @response.status = 400
        @response.write(error.message)
        @response.headers['Content-Type'.freeze] = 'text/plain'.freeze
      end
    end
  end
end
