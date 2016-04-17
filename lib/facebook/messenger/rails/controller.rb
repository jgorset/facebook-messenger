module Facebook
  module Messenger
    module Rails
      # The Ruby on Rails engine to mount.
      class Controller < ::ActionController::Base
        def validation
          if params['hub.verify_token'] == verify_token
            return render json: params['hub.challenge'], status: 200
          end

          render body: 'Verify token mismatch', status: 400
        end

        def receive
          # Facebook may batch several items in the 'entry' array during
          # periods of high load.
          params['entry'].each do |entry|
            # Facebook may batch several items in the 'messaging' array
            # during periods of high load.
            entry['messaging'].each do |messaging|
              delegate(messaging)
            end
          end

          render status: 200
        end

        private

        def delegate(messaging)
          if messaging['message']
            Facebook::Messenger.message(
              messaging['sender']['id'], messaging['recipient']['id'],
              messaging['message']
            )
          elsif messaging['postback']
            Facebook::Messenger.postback(
              messaging['sender']['id'], messaging['recipient']['id'],
              messaging['postback']
            )
          end
        end

        def verify_token
          Facebook::Messenger::Configuration.verify_token
        end
      end
    end
  end
end
