<p align="center">
  <img src="https://rawgit.com/hyperoslo/facebook-messenger/master/docs/logo.png">
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'facebook-messenger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install facebook-messenger

## Usage

### Subscribe your Application (bot) to a Page

Once you've created an Application on Facebook, select the Facebook Page you want to
install it on and use the corresponding Page Access Token to subscribe it:

```ruby
Facebook::Messenger::Subscriptions.subscribe('token')
```

### Sending and receiving messages

When your Page receives messages on Messenger, Facebook sends them to your
Application's Messenger webhook:

![Application settings](https://scontent-amt2-1.xx.fbcdn.net/hphotos-xfp1/t39.2178-6/12057143_211110782612505_894181129_n.png)

You can reply to messages:

```ruby
include Facebook::Messenger

Bot.on :message do |message|
  message.id      # => 'mid.1457764197618:41d102a3e1ae206a38'
  message.sender  # => { id: '1008372609250235' }
  message.seq     # => 73
  message.sent_at # => 2016-04-22 21:30:36 +0200
  message.text    # => 'Hello, bot!'

  Bot.message(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
```

Or even send messages out of the blue:

```ruby

Bot.message(
  recipient: {
    id: '45123'
  },
  message: {
    text: 'Hello, human!'
  }
)
```

Messages can be just text, text with images or even text with images and
options. See Facebook's [documentation][message-documentation] for an
exhaustive reference.

### Receive messages

When your Page receives messages on Messenger, Facebook sends them to your
Application's Messenger webhook:

![Application settings](https://scontent-amt2-1.xx.fbcdn.net/hphotos-xfp1/t39.2178-6/12057143_211110782612505_894181129_n.png)

```ruby
Bot.on :message do |message|
  message.id     # => 'mid.1457764197618:41d102a3e1ae206a38'
  message.sender # => { id: '1008372609250235' }
  message.text   # => 'Hello, bot!'

  Bot.message(
    recipient: message.sender,
    message: {
      text: 'Hello, human!'
    }
  )
end
```

*This is a work in progress; more features and documentation to follow.*

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
[cuba]: https://github.com/soveran/cuba
