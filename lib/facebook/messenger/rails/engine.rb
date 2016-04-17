module Facebook
  module Messenger
    module Rails
      # The Ruby on Rails engine to mount.
      class Engine < ::Rails::Engine
        isolate_namespace Engine

        Engine.routes.draw do
          get '/', to: 'controller#validate'
          post '/', to: 'controller#receive'
        end
      end
    end
  end
end
