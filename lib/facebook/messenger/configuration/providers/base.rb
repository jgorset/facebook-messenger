module Facebook
  module Messenger
    class Configuration
      module Providers
        class Base
          def valid_verify_token?(verify_token)
            raise NotImplementedError
          end

          def app_secret_for(page_id)
            raise NotImplementedError
          end

          def access_token_for(page_id)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
