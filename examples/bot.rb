require 'facebook/messenger'

Facebook::Messenger.configure do |config|
  config.access_token = ENV['ACCESS_TOKEN']
  config.verify_token = ENV['VERIFY_TOKEN']
end

include Facebook::Messenger

Bot.on :message do |message|
  puts "Received '#{message.text}' from #{message.sender}"

  Bot.deliver(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
