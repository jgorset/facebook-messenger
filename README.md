<p align="center">
  <img src="https://rawgit.com/hyperoslo/facebook-messenger/master/docs/logo.png">
</p>

## Installation

    $ gem install facebook-messenger

## Usage

You can reply to messages:

```ruby
# bot.rb
require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |message|
  message.id      # => 'mid.1457764197618:41d102a3e1ae206a38'
  message.sender  # => { id: '1008372609250235' }
  message.seq     # => 73
  message.sent_at # => 2016-04-22 21:30:36 +0200
  message.text    # => 'Hello, bot!'

  Bot.deliver(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
```

Or even send messages out of the blue:

```ruby
Bot.deliver(
  recipient: {
    id: '45123'
  },
  message: {
    text: 'Human?'
  }
)
```

Messages can be just text, text with images or even text with images and
options. See Facebook's [documentation][message-documentation] for an
exhaustive reference.

<p align="center">
  <img src="https://rawgit.com/hyperoslo/facebook-messenger/master/docs/example_conversation.png">
</p>

You can listen to postbacks for buttons pressed by the human:

```ruby
Bot.on :postback do |postback|
  postback.sender    # => { id: '1008372609250235' }
  postback.recipient # => { id: '2015573629214912' }
  postback.sent_at   # => 2016-04-22 21:30:36 +0200
  postback.payload    # => 'EXTERMINATE'

  puts "Human #{postback.recipient} marked for extermination"
end
```

You can also observe when the human received your message:

```ruby
Bot.on :delivery do |delivery|
  delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
  delivery.sender    # => { id: '1008372609250235' }
  delivery.recipient # => { id: '2015573629214912' }
  delivery.at        # => 2016-04-22 21:30:36 +0200
  delivery.seq       # => 37

  puts "Human received messages before #{delivery.at}"
end
```

The bot runs on [Rack][rack], so you hook it up like you would an ordinary
web application:

```ruby
# config.ru
require 'facebook/messenger'
require_relative 'bot'

run Facebook::Messenger::Server
```

```
$ rackup
```

## Configuration

### Create an Application on Facebook

Create an Application on [developers.facebook.com][facebook-developers] and go
to the Messenger tab. Select the Page you want to install your bot on.

Create a new webhook, enter the domain your bot is connected to and a verify
token of your choosing.

![Application settings](https://scontent-amt2-1.xx.fbcdn.net/hphotos-xfp1/t39.2178-6/12057143_211110782612505_894181129_n.png)

Use the generated access token and your verify token to configure your bot:

```ruby
Facebook::Messenger.configure do |config|
  config.access_token = 'EAAG6WgW...'
  config.verify_token = 'my_voice_is_my_password_verify_me'
end
```

### Subscribe your Application to a Page

Once you've configured your bot, subscribe it to the Page to get messages
from Facebook:

```ruby
Facebook::Messenger::Subscriptions.subscribe
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run
`bin/console` for an interactive prompt that will allow you to experiment.

Run `rspec` to run the tests, `rubocop` to lint, or `rake` to do both.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hyperoslo/facebook-messenger.

## Hyper loves you

[Hyper] made this. We're a bunch of folks who love building things. You should
[tweet us] if you can't get it to work. In fact, you should tweet us anyway.
If you're using Facebook Messenger, we probably want to [hire you].

[Hyper]: https://github.com/hyperoslo
[tweet us]: http://twitter.com/hyperoslo
[hire you]: http://www.hyper.no/jobs/engineers
[MIT License]: http://opensource.org/licenses/MIT
[rubygems.org]: https://rubygems.org
[message-documentation]: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
[facebook-developers]: https://developers.facebook.com
[rack]: https://github.com/rack/rack
