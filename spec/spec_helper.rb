require 'coveralls'
require 'webmock/rspec'
require 'helpers/graph_api_helpers'

Coveralls.wear!

require 'facebook/messenger'

RSpec.configure do |config|
  config.before(:each) do
    Facebook::Messenger::Bot.unhook
  end
end
