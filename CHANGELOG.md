# Changelog

## v1.2.0(Uncoming)

### Added
* Add modify message feature in `defaultMessageLongPressExtMenu`
* Add @ mention feature in group chat
* Add forward messages feature in `defaultMessageLongPressExtMenu`
* Add reply message feature in `defaultMessageLongPressExtMenu`

### Fixed
* Fix a crash while message list refreshed

## v1.1.0(Mar 08, 2023)

### Added
* Add swift language support

### Fixed
* Fix a memory leak in `EaseConversationsViewController`

## v1.0.9(Nov 30, 2022)
### Fixed
* Fix chat view controller can not dealloc in `EaseChatViewController`

## v1.0.8(Sep 19, 2022)
### Added
* Add `messageLongPressExtMenuItemArray` callback function with messageModel param

### Fixed
* Fix a crash while recall a timeString message cell
* Fix some UI operation not in main thread

### Improved
* Use new api instead of deprecated apis
* Improve message cell refresh while message status changed

## v1.0.1(Jan 27, 2022)
First Release