# Change Log

## [0.8.0] - 2016-07-05
### Added
- `Incoming::Message` now has a `recipient` method for consistency.
- Thread settings for welcome messages and persistent menu.

### Removed
- Welcome messages (these are now thread settings).

## [0.7.0] - 2016-06-26
### Added
- Welcome messages.

## [0.6.0] - 2016-06-08
### Added
- Support for read messages (although it isn't documented yet, Facebook
  is known to send these).

### Fixed
- Fix an issue that would crash the bot when Facebook neglects to send the
  `X-Hub-Signature` header. This will now fail with a warning and prompt
  Facebook to retry.

## [0.5.0] - 2016-05-26
### Added
- You may now verify that the message is from Facebook by
  configuring `app_secret`.
- Support for Rack 2.
- Support for receiving attachments from the user.

## [0.4.2] - 2016-05-02
### Fixed
- Fix a bug that caused `Subscriptions.subscribe` and
  `Subscriptions.unsubscribe` to not raise errors.

## [0.4.1] - 2016-05-02
### Fixed
- Fix a bug that caused `Bot.deliver` to return `'message_id'` for successful
  deliveries and `nil` for unsuccessful deliveries instead of a message ID or
  appropriate exceptions.

## [0.4.0] - 2016-04-29
### Added
- Support for threaded servers.

### Fixed
- Fix a bug that caused a `NoMethodError` with no hooks at all.

## [0.3.0] - 2016-04-24
### Added
- Add support for optins.

### Fixed
- Fix a bug that prevented registering postbacks.

## [0.2.0] - 2016-04-23
### Added
- Everything!

## [0.1.0] - 2016-04-15
### Added
- Nothing; release an empty codebase to snag the name.
