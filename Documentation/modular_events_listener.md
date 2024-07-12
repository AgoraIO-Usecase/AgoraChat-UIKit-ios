# Listening for callback events on main pages

The monitoring of IM SDK callback events and UI trigger events is in their respective ViewModels.

## 1. Conversation list

You can inherit `ConversationViewModel`, assign values ​​to register it in `ComponentsRegister.shared.ConversationViewService`, and then overload the following monitoring methods you want to intercept.

| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `loadExistLocal is IfEmptyFetchServer` | Callback triggered when an error occurs in pulling the conversation list. This method will re-acquire the conversation list. | Yes |
| `pin` | Callback triggered when a user clicks the pin button after swiping a conversation towards left. | Yes |
| `unpin` | Callback triggered when a user clicks the unpin button after swiping a conversation towards left. | Yes |
| `mute` | Callback triggered when a user clicks the mute button after swiping a conversation towards left. | Yes |
| `unmute` | Callback triggered when a user clicks the unmute button after swiping a conversation towards left. | Yes |
| `delete` | Callback triggered when a user clicks the delete button after swiping a conversation towards left. list | Yes |
| `read` | Callback triggered when a user clicks the read button after swiping a conversation towards left. | Yes |
| `conversationDidSelected` | Callback triggered after clicking a conversation. | Yes |
| `conversationLongPressed` | Callback triggered after long pressing a conversation. | Yes |
| `moreAction` | Callback triggered when a user clicks `...` after swiping a conversation towards right.  | Yes |
| `conversationLastMessageUpdate` | Callback triggered when the last message in a conversation is updated. | Yes |
| `playNewMessageSound` | Playing the audio when a new message is received. | Yes |
| `conversationMessageAlreadyReadOnOtherDevice` | Messages in the conversation have been read on other devices | Yes |
| `conversationEventDidChanged` | Callback triggered when an operation is performed on a conversation on another device in a multi-device scenario. | Yes |
| `mapper` | mapping to the `ConversationInfo` object. | Yes |

## 2. Message list

You can inherit `MessageListViewModel`, assign values ​​to register it in `ComponentsRegister.shared.MessagesViewModel`, and then overload the following listening methods you want to intercept.

| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `messageDidReceived` | Callback triggered when a new message is received. | Yes |
| `messageDidRecalled` | Callback triggered when a message is recalled. | Yes |
| `onMessageDidEdited` | Callback triggered when a message is edited. | Yes |
| `messageStatusChanged` | Callback triggered when the status of a message is changed. | Yes |
| `messageAttachmentStatusChanged` | Callback triggered when the status of a message attachment is changed. | Yes |

For UI event callbacks, see "Intercept click redirection events on main pages".

## 3. Contact list

You can inherit `ContactViewModel`, assign a value to register it in `ComponentsRegister.shared.ContactViewService`, and then overload the following monitoring methods you want to intercept.

| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `processFriendDidAgree` | Callback triggered when a friend request is accepted. | Yes |
| `processFriendRequestDidDecline` | Callback triggered when a friend request is declined. | Yes |
| `processFriendshipDidRemove` | Callback triggered when a friend is removed. | Yes |
| `processFriendshipDidAddSuccessful` | Callback triggered when a friend is added successfully. | Yes |
| `processFriendRequestDidReceive` | Callback triggered when a friend request is received. | Yes |
| `contactEventDidChanged` | Callback triggered when a contact-related event occurs on another device in a multi-device scenario. | Yes |
