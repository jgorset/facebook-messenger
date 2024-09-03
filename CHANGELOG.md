# Change Log

## [2.1.2] - 2024-07-18

### Changed
- Updated to Graph API v20.0

### Added
- New method for sending comments in Bot module

## [2.0.2] - 2024-03-20

### Added
- Support for feed events
- Support for leadgen events
- Standby entry for fb messenger

## [2.0.1] - 2020-07-31

### Changed
- App secret proof is no longer optional

## [2.0.0] - 2020-07-31

### Changed
- Bot.deliver now accepts `page_id` instead of `access_token` and `app_secret_proof`

### Added
- Support for message reactions

## [1.5.0] - 2020-04-19

### Added
- Support for message reactions

## [1.4.1] - 2019-09-28

### Fixed
- Fixed a reference to Graph API 2.9 in `Profile`.

## [1.4.0] - 2019-04-17

### Added
- Support for game_plays

## [1.3.0] - 2019-04-16

### Added
- Support for pass_thread_control

## [1.2.0] - 2019-04-13

### Added
- Upgraded to Graph API 3.2 for everything
- Support for appsecret_proof

## [1.1.2] - 2018-12-06

### Added
- Support for Graph API 3.2 in `Subscriptions`.

## [1.1.1] - 2018-07-10

### Fixed
- Fixed a bug that caused messaging types and tags to not be required.

## [1.1.0] - 2018-06-28

### Added
- Support for Rack 1.4.5 or newer (was 1.6.4).
- `Incoming::Optin#user_ref`.
- Support for message requests.
- Support for Facebook's built-in NLP with `Incoming::Message#nlp`.
- Support for payments with `Incoming::Payment`.
- Support for handover.
- Support for message types and tags.
- Support for prior message.
- Support for Graph API v2.9.

### Changed
- Error codes now include subcodes

## [1.0.0] - 2017-05-31

### Added
- You may now subscribe to message echoes without DDOSing yourself.

## [0.13.0] - 2017-05-18

### Added
- `Message#app_id` yields the application ID for message echoes.
- Helpers to determine the attachments of a message (e.g. `Message#image_attachment?`).

### Changed
- `Thread` is now `Profile` to correspond with Facebook's API.

## [0.12.0] - 2017-03-31
### Added
- Various errors from the Facebook Messenger platform are now subclasses of
  `Facebook::Messenger::Errors` to allow easier error handling.
- `Message#mark_seen` will mark the received message as seen.

### Changed
- `type` is now `typing_on` and `typing_off`.

### Fixed
- `Message#referral` now returns `nil` if there is no referral.

## [0.11.1] - 2016-11-23
### Fixed
- Webhooks that don't have messaging will now be ignored rather than crash.
- Refactored use of `dig` for compatibility with Ruby < 2.3.

## [0.11.0] - 2016-11-19
### Added
- `reply` and `type` are now available on any incoming entry (such as messages
  or postbacks).
- With the introduction of configuration providers, bots may now be installed to
  multiple Facebook Pages.
- `Incoming::Message` now has an `echo?` method which returns a boolean
  describing whether the message was an echo.

### Changed
- `Bot.deliver` now requires a keyword argument `access_token`.
- `Facebook::Messenger.configuration.verify_token`, `app_secret` and
  `access_token` are replaced by configuration providers.

## [0.10.0] - 2016-09-23
### Fixed
- Fixed a bug that caused `Message.quick_replies` to crash when a
  quick reply wasn't used.

### Changed
- `Message.quick_replies` is now `Message.quick_reply`.

## [0.9.0] - 2016-08-17
### Added
- Quick replies.
- Account linking.

### Fixed
- Fixed a bug that caused `read` to be ignored.

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
