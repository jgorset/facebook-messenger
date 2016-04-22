require 'rack'
require 'json'

module Facebook
  module Messenger
    # This module holds the server that processes incoming messages from the
    # Facebook Messenger Platform.
    class Server
      class << self
        def call(env)
          @request = Rack::Request.new(env)
          @response = Rack::Response.new

          case @request.request_method
          when 'GET' then verify
          when 'POST' then receive
          else method_not_allowed
          end
        end

        def verify
          verify_token = Facebook::Messenger.config.verify_token

          if @request.params['hub.verify_token'] == verify_token
            @response.write @request.params['hub.challenge']
          else
            @response.write 'Error; wrong validation token'
          end

          @response.finish
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

          @response.finish
        end

        def method_not_allowed
          @response.status = 405
          @response.finish
        end
      end
    end
  end
end
