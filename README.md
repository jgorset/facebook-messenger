<p align="center">
  <img src="https://rawgit.com/hyperoslo/facebook-messenger/master/docs/conversation_with_logo.gif">
</p>


[![Gem Version](https://img.shields.io/gem/v/facebook-messenger.svg?style=flat)](https://rubygems.org/gems/facebook-messenger)
[![Build Status](https://img.shields.io/travis/hyperoslo/facebook-messenger.svg?style=flat)](https://travis-ci.org/hyperoslo/facebook-messenger)
[![Dependency Status](https://img.shields.io/gemnasium/hyperoslo/facebook-messenger.svg?style=flat)](https://gemnasium.com/hyperoslo/facebook-messenger)
[![Code Climate](https://img.shields.io/codeclimate/github/hyperoslo/facebook-messenger.svg?style=flat)](https://codeclimate.com/github/hyperoslo/facebook-messenger)
[![Coverage Status](https://img.shields.io/coveralls/hyperoslo/facebook-messenger.svg?style=flat)](https://coveralls.io/r/hyperoslo/facebook-messenger)
[![Join the chat at https://gitter.im/hyperoslo/facebook-messenger](https://badges.gitter.im/hyperoslo/facebook-messenger.svg)](https://gitter.im/hyperoslo/facebook-messenger?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Installation

    $ gem install facebook-messenger

## Usage

#### Sending and receiving messages

You can reply to messages sent by the human:

```ruby
# bot.rb
require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |message|
  message.id      # => 'mid.1457764197618:41d102a3e1ae206a38'
  message.sender  # => { 'id' => '1008372609250235' }
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

... or even send the human messages out of the blue:

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

##### Messages with images

The human may require visual aid to understand:

```ruby
Bot.deliver(
  recipient: {
    id: '45123'
  },
  message: {
    attachment: {
      type: 'image',
      payload: {
        url: 'http://sky.net/visual-aids-for-stupid-organisms/pig.jpg'
      }
    }
  }
)
```

##### Messages with buttons

The human may require simple options to communicate:

```ruby
Bot.deliver(
  recipient: {
    id: '45123'
  },
  message: {
    attachment: {
      type: 'template',
      payload: {
        template_type: 'button',
        text: 'Human, do you like me?',
        buttons: [
          { type: 'postback', title: 'Yes', payload: 'HARMLESS' },
          { type: 'postback', title: 'No', payload: 'EXTERMINATE' }
        ]
      }
    }
  }
)
```

When the human has selected an option, you can act on it:

```ruby
Bot.on :postback do |postback|
  postback.sender    # => { 'id' => '1008372609250235' }
  postback.recipient # => { 'id' => '2015573629214912' }
  postback.sent_at   # => 2016-04-22 21:30:36 +0200
  postback.payload   # => 'EXTERMINATE'

  if postback.payload == 'EXTERMINATE'
    puts "Human #{postback.recipient} marked for extermination"
  end
end
```

*See Facebook's [documentation][message-documentation] for all message options.*

#### Send to Facebook

When the human clicks the [Send to Messenger button][send-to-messenger-plugin]
embedded on a website, you will receive an `optin` event.

```ruby
Bot.on :optin do |optin|
  optin.sender    # => { 'id' => '1008372609250235' }
  optin.recipient # => { 'id' => '2015573629214912' }
  optin.sent_at   # => 2016-04-22 21:30:36 +0200
  optin.ref       # => 'CONTACT_SKYNET'

  Bot.deliver(
    recipient: optin.sender,
    message: {
      text: 'Ah, human!'
    }
  )
end
```

#### Message delivery receipts

You can stalk the human:

```ruby
Bot.on :delivery do |delivery|
  delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
  delivery.sender    # => { 'id' => '1008372609250235' }
  delivery.recipient # => { 'id' => '2015573629214912' }
  delivery.at        # => 2016-04-22 21:30:36 +0200
  delivery.seq       # => 37

  puts "Human was online at #{delivery.at}"
end
```

## Configuration

### Create an Application on Facebook

Create an Application on [developers.facebook.com] and go to the Messenger
tab. Select the Page you want to install your bot on.

Create a new webhook, enter the domain your bot is connected to and a verify
token of your choosing.

![Application settings](https://scontent-amt2-1.xx.fbcdn.net/hphotos-xfp1/t39.2178-6/12057143_211110782612505_894181129_n.png)

Use the generated access token and your verify token to configure your bot:

##### ... pass a block, or

```ruby
Facebook::Messenger.configure do |config|
  config.access_token = 'EAAG6WgW...'
  config.app_secret = '__app_secret_here__'
  config.verify_token = 'my_voice_is_my_password_verify_me'
end
```

##### ... set directly

```ruby
Facebook::Messenger.config.access_token = 'EAAG6WgW...'
Facebook::Messenger.config.app_secret = '__app_secret_here__'
Facebook::Messenger.config.verify_token = 'my_voice_is_my_password_verify_me'
```

### Subscribe your Application to a Page

Once you've configured your bot, subscribe it to the Page to get messages
from Facebook:

```ruby
Facebook::Messenger::Subscriptions.subscribe
```

### Run it

##### ... on Rack

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

##### ... on Rails

Rails doesn't give you much that you'll need for a bot, but if you have an
existing application that you'd like to launch it from or just like Rails
a lot, you can mount it:

```ruby
# config/routes.rb

Rails.application.routes.draw do
  # ...

  mount Facebook::Messenger::Server, at: 'bot'
end
```

We suggest that you put your bot code in `app/bot`.

```ruby
# app/bot/example.rb

include Facebook::Messenger

Bot.on :message do |message|
  Bot.deliver(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
```

Remember that Rails only eager loads everything in its production environment.
In the development and test environments, it only requires files as you
reference constants. You'll need to explicitly load `app/bot`, then:

```ruby
# config/initializers/bot.rb
unless Rails.env.production?
  Dir["#{Rails.root}/app/bot/**/*.rb"].each { |file| require file }
end
```

To test your locally running bot, you can use [ngrok]. This will create a secure
tunnel to localhost so that Facebook can reach the webhook.

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
[developers.facebook.com]: https://developers.facebook.com/
[rack]: https://github.com/rack/rack
[send-to-messenger-plugin]: https://developers.facebook.com/docs/messenger-platform/plugin-reference
[ngrok]: https://ngrok.com/
