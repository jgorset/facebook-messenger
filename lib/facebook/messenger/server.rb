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
        if @request.params['hub.verify_token'] == verify_token
          @response.write @request.params['hub.challenge']
        else
          @response.write 'Error; wrong verify token'
        end
      end

      def receive
        check_integrity if app_secret

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
        OpenSSL::HMAC.hexdigest('sha1'.freeze, app_secret, content)
      end

      # Returns a String describing the bot's configured app secret.
      def app_secret
        Facebook::Messenger.config.app_secret
      end

      # Returns a String describing the bot's configured verify token.
      def verify_token
        Facebook::Messenger.config.verify_token
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
