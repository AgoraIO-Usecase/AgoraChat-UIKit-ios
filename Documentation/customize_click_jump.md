# Intercept click redirection events on main pages

## 1. Conversation list page

You can inherit `ConversationListController`, assign a value to register it in `ComponentsRegister.shared.ConversationsController`, and then overload the following click event methods you want to intercept.
| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `createNavigationBar` | Creating a navigation bar | Yes |
| `createSearchBar` | Creating a search box | Yes |
| `createList` | Creating a conversation list | Yes |
| `navigationClick` | Clicking the navigation | Yes |
| `pop` | Returning to the page | Yes |
| `toChat` | Redirecting to the chat page | Yes |
| `searchAction` | Clicking in the search box | Yes |
| `rightActions` | Clicking the button on the right of the navigation | Yes |
| `selectContact` | Redirecting to the contact selection page | Yes |
| `chatToContact` | Redirecting to the contact details page from the chat page | Yes | 
| `createChat` | Creating a one-to-one chat or group chat conversation | Yes | 
| `addContact` | Evoking the contact addition window | Yes |
| `createGroup` | Selecting group members during group creation | Yes |
| `create` | Creating a group | Yes |

## 2. Chat page

You can inherit `MessageListController`, assign a value to register it in `ComponentsRegister.shared.MessageViewController`, and then overload the following click event methods you want to intercept. 

| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `createNavigation` | Creating the navigation bar | Yes |
| `createLoading` | Creating the loading page | Yes |
| `navigationClick` | All navigation bar click methods | Yes | 
| `viewDetail` | Viewing the contact details page or group details page | Yes |
| `rightItemsAction` | Clicking the button on the right of the navigation | Yes |
| `pop` | Returning to the previous level of the page  | Yes  |
| `messageWillSendFillExtensionInfo` | Adding extension information before sending the message | Yes |
| `filterMessageActions` | Filtering menu items shown on the pop-up menu after long press | Yes |
| `showMessageLongPressedDialog` | Displaying the menu that appears upon long press of a message | Yes |
| `processMessage` | Processing the window click event after long press of a message | Yes |
| `editAction` | Displaying the message edit window after clicking the `edit` button in the menu that appears after long press of a message | Yes |
| `reportAction` | Displaying the report window after clicking the `report` button in the menu that appears after long press of a message | Yes |
| `messageAttachmentLoading` | Whether to show the loading page after an image, video, or attachment message is clicked. Displaying the loading page after clicking an image, video or attachment message | Yes |
| `messageBubbleClicked` | Clicking the message bubble | Yes |
| `viewContact` | Viewing the contact page | Yes |
| `messageAvatarClick` | Clicking the message avatar | Yes | 
| `audioDialog` | Displaying the audio recording window | |
| `mentionAction` | Enter `@` in the input box in the group chat to trigger the event | Yes |
| `attachmentDialog` | Displaying the window for sending an image, video or file message | Yes |
| `selectFile` | Selecting a file | Yes |
| `selectPhoto` | Opening the album to select an image | Yes |
| `openCamera` | Opening the camera to take videos and photos | Yes |
| `selectContact` | Selecting a contact to send a card | Yes |
| `openFile` | Open a file | Yes | 
| `processImagePickerYes` | Processing image selection or sending a video message | Yes | 
| `documentPickerOpenFile` | Opening the file selector | Yes |

## 3. Contact page

You can inherit `ContactViewController`, assign a value to register it in `ComponentsRegister.shared.ContactsController`, and then overload the following click event methods you want to intercept.

| Method | Purpose | Overloadable |
| -------- | -------- | -------- |
| `createNavigation` | Creating the navigation bar | Yes |
| `navigationClick` | All navigation bar click methods | Yes |
| `viewContact` | Viewing the contact details page | Yes |
| `rightItemsAction` | Clicking the button on the right of the navigation | Yes |
| `pop` | Returning to the previous level of the page | Yes |  
| `setupTitle` | Set the navigation titles of the contact page when it is reused in different scenarios | Yes | 
| `receiveContactHeaderAction` | Clicking an item on the header of the contact list page | Yes | 
| `searchAction` | Clicking the search box | Yes |
| `addContact` | Displaying the contact addition window | Yes |
| `confirmAction` | Clicking the text button on the right of the navigation | Yes |  
| `viewNewFriendRequest` | Viewing the friend request page | Yes |
| `viewJoinedGroups` | Viewing the page of listing the groups you have joined | Yes |
