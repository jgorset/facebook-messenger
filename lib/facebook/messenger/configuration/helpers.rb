module Facebook
  module Messenger
    class Configuration
      # The helpers module provides helpers that can be useful for
      # configuration providers
      module Helpers
        def calculate_app_secret_proof(app_secret, access_token)
          OpenSSL::HMAC.hexdigest(
            OpenSSL::Digest.new('SHA256'.freeze),
            app_secret,
            access_token
          )
        end
      end
    end
  end
end
