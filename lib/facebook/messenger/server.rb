require 'rack'
require 'json'
require 'openssl'

module Facebook
  module Messenger
    # This module holds the server that processes incoming messages from the
    # Facebook Messenger Platform.
    class Server
      def self.call(env)
        new.call(env)
      end

      def call(env)
        @request = Rack::Request.new(env)
        @response = Rack::Response.new

        if @request.get? then verify
        elsif @request.post? then receive
        else @response.status = 405
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
        return if app_secret && !integrity?

        hash = JSON.parse(@request.body.read)

        # Facebook may batch several items in the 'entry' array during
        # periods of high load.
        hash['entry'].each do |entry|
          # Facebook may batch several items in the 'messaging' array during
          # periods of high load.
          entry['messaging'].each do |messaging|
            Facebook::Messenger::Bot.receive(messaging)
          end
        end
      end

      def integrity?
        Rack::Utils.secure_compare(x_hub_signature, signature)
      end

      def x_hub_signature
        @request.env['HTTP_X_HUB_SIGNATURE'.freeze]
      end

      def signature
        format('sha1=%s'.freeze, generate_hmac(@request.body.read))
      ensure
        @request.body.rewind
      end

      def generate_hmac(content)
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha1'),
          app_secret,
          content
        )
      end

      def app_secret
        Facebook::Messenger.config.app_secret
      end
    end
  end
end
