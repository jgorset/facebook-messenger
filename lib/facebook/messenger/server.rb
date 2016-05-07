require 'rack'
require 'json'

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

        case
        when @request.get? then verify
        when @request.post? then receive
        else @response.status = 405
        end

        @response.finish
      end

      def verify
        if @request.params['hub.verify_token'] == verify_token
          @response.write @request.params['hub.challenge']
        else
          @response.write 'Error; wrong verify token'
        end
      end

      def verify_token
        Facebook::Messenger.configure.verify_token
      end

      def receive
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
    end
  end
end
