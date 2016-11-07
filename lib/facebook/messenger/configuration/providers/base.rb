module Facebook
  module Messenger
    class Configuration
      module Providers
        # This is the base configuration provider. It raises errors so that you
        # get nice ones.
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
