# Intercept click events in components in chat-uikit

Note: Developers need to implement the post-interception business logic and UI refresh logic. It is recommended to address requirements via registration based on inheritance.

## 1. Conversations List

- swipeAction: occurs when a conversation is swiped.
        
- longPressed: occurs when a conversation is long pressed.
        
- didSelected: occurs when a conversation is clicked. 

## 2. Contacts List

- didSelectedContact: occurs when a contact is clicked.

- groupWithSelected: occurs when a user is selected or added to the group during group creation.

## 3. Messages List

- replyClicked: occurs when a message bubble quoted in a message reply is clicked. 
        
- bubbleClicked: occurs when a message bubble is clicked.
        
- bubbleLongPressed: occurs when a message is long pressed.
        
- avatarClicked: occurs when a message avatar is clicked.
        
- avatarLongPressed: occurs when a message avatar is long pressed.
        
