require 'facebook/messenger/configuration/helpers'

module Facebook
  module Messenger
    class Configuration
      module Providers
        # This is the base configuration provider.
        #   User can overwrite this class to customize the environment variables
        #   Be sure to implement all the functions as it raises
        #   NotImplementedError errors.
        class Base
          include Facebook::Messenger::Configuration::Helpers

          # A default caching implentation of generating the app_secret_proof
          # for a given page_id
          def app_secret_proof_for(page_id)
            app_secret = app_secret_for(page_id)
            access_token = access_token_for(page_id)
            @cached_app_secret_proof ||= {}
            @cached_app_secret_proof[[app_secret, access_token]] =
              calculate_app_secret_proof(app_secret, access_token)
          end

          def valid_verify_token?(*)
            raise NotImplementedError
          end

          def app_secret_for(*)
            raise NotImplementedError
          end

          def access_token_for(*)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
