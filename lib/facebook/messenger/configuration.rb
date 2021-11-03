require 'facebook/messenger/configuration/providers'

module Facebook
  module Messenger
    #
    # Class Configuration holds the configuration for bot.
    #
    class Configuration
      attr_accessor :provider, :fallback_library
    end
  end
end
