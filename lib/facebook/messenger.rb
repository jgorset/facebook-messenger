require 'facebook/messenger/version'
require 'facebook/messenger/error'
require 'facebook/messenger/subscriptions'
require 'facebook/messenger/bot'
require 'facebook/messenger/server'
require 'facebook/messenger/configuration'
require 'facebook/messenger/message'

module Facebook
  # All the code for this gem resides in this module.
  module Messenger
    def self.configure
      yield Configuration
    end

    def self.config
      Configuration
    end

    configure do |config|
      config.access_token = ENV['ACCESS_TOKEN']
      config.verify_token = ENV['VERIFY_TOKEN']
    end
  end
end
