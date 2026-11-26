# SDK 5 and SPM migration

## Baselines and delivery

- Agora UIKit baseline: `d012f31`.
- Easemob implementation/package baseline: `7e389468212e06ae15824a0f77f023141625c6ac` (`sdk-5.0`).
- GitHub Actions baseline: `main` commit `3b93fa59`.
- SDK: supplied AgoraChat 5.2.0 binary; official AgoraChat SPM tags were checked and
  only the 1.x line was available. The package therefore carries the exact SDK snapshot.
- SPM release version: **2.0.0** (not published). Product `AgoraChatUIKit`, module `chat_uikit`.
- The current fork has no `2.0.0` tag. Official upstream already has a historical
  `2.0.0` (`373b429f79109ede14b690e3024764e1e0610cdd`); preserve it and do not
  use it for this migration. Remote consumers must select the actual release repository.
- Existing CocoaPods identity/version: `chat-uikit` **2.2.0**, retained independently.

## Migration map

| Source | Migrated behavior / destination |
| --- | --- |
| `98e92de6`, `32031d9c`, `8eed6bbb`, `643d645a`, `fd9d05f9` and prerequisite profile changes | Service protocols/implementations, SDK aliases, UI list and message consumers; database/data-sync notifications, local lists, group configs/events, history cursors, sender info and receipts |
| `8ecdd754` and prerequisite image fix | UI optional handling, explicit imports, media selection and image conversion; preserve image format |
| `94e7fe9e`, `67a48e38` | SDK conversation display name/avatar fallbacks |
| `9e631fe0`, `7e389468` | Navigation safe-area metrics and legacy-window fallback, navigation tests |
| `333e0353`, `ea7093ed` | AMR conversion/recording/playback plus repository-contained codec XCFramework |
| `adfc253a` | Contact/group notification preferences without requiring an existing local conversation |
| `867f84f0` | Five-second typing-event throttle |
| `70002f39`, relevant `76198c97` content | SPM manifest, local example, shared resource/AMR tests, CocoaPods test host, artifact verifier |
| `3b93fa59` | Adapted GitHub Actions and local CI script for both integration methods |

Merge commits are not applied twice. SDK-dependent source is mapped to actual
Agora headers, including the retained `EMDataSyncType` spelling. Branding, accounts,
tokens, user-specific Xcode state, and Easemob release version bumps are excluded.
The remote SPM example is documented as a post-publication validation procedure;
it does not resolve an unpublished tag or silently use the Easemob product.

## Public API changes

- `ChatGroupOption` now aliases `AgoraChatGroupConfigs`; replace `style` with
  `isPublic`, `allowInvites`, and `joinApprovalRequired` as appropriate.
- Server conversation/contact/joined-group list fetch wrappers are removed. Enable
  `.conversations`, `.contacts`, `.joinedGroups` before initialization, read the local
  lists, and observe `ChatDataSyncListener` including its `type` argument.
- History methods accept/return opaque cursors. Keep each paging sequence's cursor
  and time window; do not reuse a cursor for a different conversation or direction.
- Read receipt listeners receive `MessageReadReceipt` values. Clearing unread counts
  is independent of sending receipts. `markMessageAsRead` now requests a message
  receipt; `markAllMessagesAsRead` clears the current conversation's unread count.
- Group member events carry user arrays. SDK login uses explicit Token login and
  the new other-device-login information callback.
- Report controllers, component registrations, menu options, and dedicated assets
  are removed with the upstream SDK 5 change.
- `ChatUIKit_VERSION` is 2.0.0 for SPM and 2.2.0 for the retained CocoaPods identity.

## SDK API replacement reference

The table covers SDK APIs used by the starting UIKit, checked against the supplied
5.2.0 headers. Long selectors omit unchanged arguments.

| Old API used by UIKit | Replacement / behavior |
| --- | --- |
| `AgoraChatGroupOptions`, `style = .privateMemberCanInvite` | `AgoraChatGroupConfigs` with `isPublic = false`, `allowInvites = true` |
| `createGroup(withSubject:description:invitees:message:setting:completion:)` | New selector adds `avatar:`; pass the new group config |
| `getJoinedGroupsFromServer(...)` | Enable `.joinedGroups` sync, read local `getJoinedGroups()`, refresh after sync |
| `getAllContactsFromServer(...)` | Enable `.contacts` sync, read local `getAllContacts()`, refresh after sync |
| `getConversationsFromServer(...)`, `getPinnedConversationsFromServer(...)` | Enable conversation sync, use local `getAllConversations(...)` and pinned properties |
| `asyncFetchHistoryMessages(fromServer:...startMessageId:fetch:...)` | `fetchMessagesFromServer(by:conversationType:cursor:pageSize:option:completion:)`; opaque cursor and a stable time window |
| `modifyMessage(_:body:completion:)` | New selector adds `ext:`; `nil` preserves existing extensions |
| `conversation.markMessageAsRead(withId:error:)`, `markAllMessages(asRead:)` | `chatManager.clearConversationUnreadMessageCount(...)` clears conversation unread counts; no equivalent per-message local read operation |
| `sendMessageReadAck(...)`, `ackConversationRead(...)` | `sendMessageReadReceipts(...)`; clearing unread counts is a separate operation |
| `message.isReadAcked`, `messagesDidRead(...)` | `isPeerRead`, `onMessageReadReceipts(...)` with `AgoraChatMessageReadReceipt` values |
| `AgoraChatManagerDelegate.conversationListDidUpdate(...)` | Separate `AgoraChatConversationDelegate`, registered with `addConversation(delegate:queue:)` |
| `onConversationRead(_:to:)` | Removed; peer read state uses message receipts, same-account unread clearing uses multi-device events |
| `option.isAutoLogin`, `autoLoginDidCompleteWithError(...)` | Explicit Token login completion; separate database-open and data-sync callbacks |
| `userAccountDidLogin(fromOtherDevice:)` | `userAccountDidLoginFromOtherDevice(with:)` with `AgoraChatLoginExtensionInfo` |
| `joinGroupRequestDidDecline(_:reason:)` | New selector includes `decliner` and `applicant` |
| `userDidJoin(_:user:)`, `userDidLeave(_:user:)` | New callbacks receive `users: [String]` |
| `reportMessage(withId:tag:reason:completion:)` | No client SDK replacement; removed report UI/resources with upstream |

`loadMessages(...fromUser:...scope:completion:)` is deprecated, not deleted; calls
now use `fromUsers: [userId]`. Database-open does not imply sync completion:
listen separately for each sync type. For received messages, `isPeerRead` records
that a receipt has been sent. Receipt batches must belong to one conversation,
contain at most 50 messages, and use messages requesting a receipt.

The Easemob [migration guide](https://doc.easemob.com/document/ios/migration_guide.html#群组配置模型重构)
provides the corresponding EM-prefixed API guidance; the supplied Agora headers
remain authoritative for exact names and selectors.

## Fixes beyond upstream

Correct the Agora data-sync alias, optional sync listener signatures, independent
conversation delegate registration, group-sync refresh, group rejection selector,
and erroneous successful-initialization error return. Restore working public user
info completion handlers, retain legacy message-profile fallback, centralize read
receipt eligibility/in-flight suppression, and restore notification switches on
request failure. History paging retains its initial time window, preserves messages
with equal timestamps, filters duplicate IDs, and uses cursor presence to decide
whether more pages exist. Concurrent page requests are suppressed and failed
requests can retry. Tests cover these migration-sensitive behaviors.

## Validation

Use `bash scripts/ci_ios.sh spm` and `bash scripts/ci_ios.sh pods` on a macOS host
with Xcode/iOS Simulator. Each runs hosted tests serially, creates an unsigned
Release archive, and checks resources plus AMRCodec/AgoraChat/aosl embedding.
CI runs for pull requests, main/sdk-5.0/SwiftUIKit pushes, and manual dispatch. Logs and XCTest
results are uploaded even on failure. No IM account or signing identity is required.

Local verification on 2026-11-26 used Xcode 26.0.1 and an iOS 26.2 simulator:

| Integration | Hosted XCTest | Unsigned Release archive | Artifact checks |
| --- | --- | --- | --- |
| SPM | 31 passed, 0 failures | Passed | Passed (Debug and Release) |
| CocoaPods | 31 passed, 0 failures | Passed | Passed (Release) |

Artifact checks covered 328 PNGs, both localizations, the privacy manifest,
AMRCodec/AgoraChat/aosl embedding and dynamic dependencies. The 168 SDK snapshot
files match the supplied XCFramework byte for byte. Manifest, podspec, shell,
Python and workflow syntax checks passed; `git diff --check` passed. The remote
`sdk-5.0` branch was rechecked and still points to the baseline above.

CI explicitly selects Xcode 26.3 on macos-15 using the
[official runner image inventory](https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md).
A local pass is not proof of a GitHub Actions run or a published SPM 2.0.0 release. Real login, online synchronization,
push preferences, typing delivery, microphone/speaker behavior, and signed device
installation require test accounts/devices and are reported separately.
