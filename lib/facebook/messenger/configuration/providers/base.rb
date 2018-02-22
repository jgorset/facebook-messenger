module Facebook
  module Messenger
    class Configuration
      module Providers
        # This is the base configuration provider. User can overwrite this class to customize the environment variables.
        # Be sure to implement all the functions as it raises errors.
        class Base
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
