require 'facebook/messenger/version'
require 'facebook/messenger/error'
require 'facebook/messenger/subscriptions'

module Facebook
  # All the code for this gem resides in this module.
  module Messenger
    def self.on(event)
      unless [:message, :postback].include? event
        raise "'#{event}' is not a supported event"
      end

      self.class.instance_eval do
        define_method(event.to_sym) do |*args|
          yield args
        end
      end
    end
  end
end
