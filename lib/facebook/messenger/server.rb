require 'rack'
require 'json'
require 'openssl'

module Facebook
  module Messenger
    class BadRequestError < Error; end

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

      def verify_token
        Facebook::Messenger.config.verify_token
      end

      def receive
        body = @request.body.read

        check_integrity(body) if app_secret

        events = parse_events(body)

        trigger_events(events)
      rescue BadRequestError => error
        respond_with_error(error)
      end

      WARNING = 'The X-Hub-Signature header is not present in the request. ' \
        'This is expected for the first webhook requests. If this ' \
        'continues after some time, check your app\'s secret token.'.freeze

      def check_integrity(body)
        x_hub_signature = @request.env['HTTP_X_HUB_SIGNATURE'.freeze].to_s

        unless x_hub_signature.start_with?('sha1='.freeze)
          $stderr.puts(WARNING)

          raise BadRequestError, 'Error getting integrity signature'.freeze
        end

        unless secure_compare(x_hub_signature, signature(body))
          raise BadRequestError, 'Error checking message integrity'.freeze
        end
      end

      def secure_compare(x, y)
        Rack::Utils.secure_compare(x, y)
      end

      def signature(body)
        format('sha1=%s'.freeze, generate_hmac(body))
      end

      def generate_hmac(content)
        OpenSSL::HMAC.hexdigest('sha1'.freeze, app_secret, content)
      end

      def app_secret
        Facebook::Messenger.config.app_secret
      end

      def parse_events(body)
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
