require 'facebook/messenger'

Facebook::Messenger.config do |config|
  config.access_token = 'access token'
  config.verify_token = 'verify token'
end

include Facebook::Messenger

Bot.on :message do |message|
  Bot.message(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
