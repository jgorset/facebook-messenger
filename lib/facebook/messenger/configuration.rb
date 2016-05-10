module Facebook
  module Messenger
    # This module holds the configuration.
    module Configuration
      class << self
        attr_accessor :access_token
        attr_accessor :app_secret
        attr_accessor :verify_token
      end
    end
  end
end
