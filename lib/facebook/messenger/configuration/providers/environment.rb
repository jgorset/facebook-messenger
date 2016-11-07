module Facebook
  module Messenger
    class Configuration
      module Providers
        class Environment
          def valid_verify_token?(verify_token)
            verify_token == ENV['VERIFY_TOKEN']
          end

          def app_secret_for(page_id)
            ENV['APP_SECRET']
          end

          def access_token_for(page_id)
            ENV['ACCESS_TOKEN']
          end
        end
      end
    end
  end
end
