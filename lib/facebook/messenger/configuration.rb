module Facebook
  module Messenger
    # This module holds the configuration.
    class Configuration
      attr_accessor :access_token
      attr_accessor :app_secret
      attr_accessor :verify_token

      attr_accessor :config_provider_class
    end
  end
end
