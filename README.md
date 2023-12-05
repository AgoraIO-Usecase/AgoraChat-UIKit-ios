
# Get Started with Agora Chat UIKit for iOS

Agora Chat UIKit for iOS is a UI component library built on top of Agora Chat SDK. It provides a set of general UI components, such as a conversation list and chat UI, which allow developers to easily craft an Chat app to suit actual business needs. Also, this library calls methods in the Agora Chat SDK to implement Chat related logics and data processing, allowing developers to only focus on their own business and personalized extensions.

Source code URL of Agora Chat UIKit for iOS:

- https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git

URL of Agora Chat app using Agora Chat UIKit for iOS:

- https://github.com/AgoraIO-Usecase/AgoraChat-ios.git

# Important features
- Message extension functions  
    - Reactions
    - Message threading
    - Reply messages
    - Chat group @ mentions
    - Modify sent messages
    - Recall sent messages
    - Forward messages
- Common functions
    - Conversation list
    - Chatting in a conversation
    - Voice message
    - Typing indicator
    - Delivery receipt
    - Read receipt

## Prerequisites

System compatibility:

- chat-uikit: iOS 11.0 and later
- Chat app: iOS 11.0 and later

##  Project setup

### Import chat-uikit

#### Install CocoaPods

1. Install CocoaPods. For details, see [Getting Started with CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).

2. In the Terminal, open the root directory of the project and run the `pod init` command. Then the text file `Podfile` will be generated in the project folder.

chat-uikit can be integrated using a pod or source code. The detailed procedures are as follows:

#### Integrate the Agora Chat UIKit for iOS by using a pod

1. In the `Podfile` file, add dependencies of chat-uikit. Remember to replace `ProjectName` with your project name.

```
platform :ios, '11.0'

# Import CocoaPods sources
source 'https://github.com/CocoaPods/Specs.git'

target 'ProjectName' do
    pod 'chat-uikit'
end
```

2. In the Terminal, run the `cd` command to switch to the directory where the `Podfile` file is located. Then run the following command to integrate the SDK.

```
pod install
```

3. After pod installation is complete, the message `Pod installation complete!` will be displayed in the Terminal. At this time, the `xcworkspace` file will be generated in the project folder. You can open this new file to run the project.

**Note**

Depending on AgoraChat SDK, chat-uikit provides such functions as taking photos and sending voice messages, image messages, and attachments and requires access to the recording, camera, and album. Therefore, you need to add related permissions in `info.plist`.

##### Integrate the Agora Chat UIKit for iOS using source code

1. Download source code from github:

Download URL: https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git

Terminal command: git clone https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git

1. Add source code dependencies of chat-uikit in the project.

Open the `Podfile` file and add dependencies of chat-uikit.

`Podfile` file example:

```
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'ProjectName' do
    pod 'chat-uikit',  :path => "../chat-uikit"
end

#The chat-uikit path should point to the directory where chat-uikit.podspec resides.
```

1. Integrate the local source code of Agora Chat UIKit for iOS in the project.

In the Terminal, run the `cd` command to switch to the directory where the `Podfile` file is located. Then run the `pod install` command to install local source code of Agora Chat UIKit for iOS.

After the command execution is complete, you can find the source code of Agora Chat UIKit for iOS in the Xcode project directory Pods/Development Pods/ and adapt it to align with your project objectives.

### Add privileges

Add privileges in `info.plist` of your project.

```
Privacy - Photo Library Usage Description //Album privileges.
Privacy - Microphone Usage Description //Microphone privileges.
Privacy - Camera Usage Description //Camera privileges.
App Transport Security Settings -> Allow Arbitrary Loads //Enable the network service.
```

### Reference

If you have made any general customizations during source code customization, please submit them to our repository https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git to become a contributor of our community.


### III. Initialization

#### 1. Import the header file
```
#import <chat-uikit/EaseChatKit.h>
```

#### 2. Initialize the chat-uikit

In AppDelegate.m in the project, call the initialization method in EaseChatKitManager to initialize AgoraChat SDK (note that it is unnecessary to repeatedly call this method).

```
(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	AgoraChatOptions *options = [AgoraChatOptions optionsWithAppkey:@"You created APPKEY"];
	[EaseChatKitManager initWithAgoraChatOptions:options];
	//Login operation.
	return YES;
}
```

#### 3. Callback for receiving the number of unread messages in all conversations

EaseChatKitManagerDelegate is the callback for the total number of unread messages in all conversations.

You need to register your class in EaseChatKitManagerDelegate to receive the callback for the change to the total number of unread messages.

```
/*
 @method
 @brief   Callback triggered when the total number of unread messages is changed.
 @param   unreadCount     The total number of unread messages in all conversations.
 */

- (void)conversationsUnreadCountUpdate:(NSInteger)unreadCount;
```

### IV. Rapid setup

#### Rapidly set up a chat conversation

##### 1.Import the header file

```
#import <chat-uikit/EaseChatKit.h>
```

##### 2.Load the conversation page

Agora Chat UIKit for iOS provides `ViewController` for chat conversations. You can create an `EaseChatViewController` instance and embed your chat controller (see `ACDChatViewController.m` in Agora Chat) in this instance to integrate the chat conversation function of this library. To create a chat conversation page instance, you need to pass the conversation ID, group ID, conversation type (`AgoraChatConversationType`), and `EaseChatViewModel` (chat view configuration data model) instance.

```
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init];
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"custom"
                                              conversationType:AgoraChatConversationTypeChat
                                                  chatViewModel:viewModel];
[self addChildViewController:chatController];
[self.view addSubview:chatController.view];
chatController.view.frame = self.view.bounds;
```

#### Rapidly set up the conversation list

##### 1. Import the header file.

```
#import <chat-uikit/EaseChatKit.h>
```

##### 2.Load the conversation list.

In your chat controller, you can embed EaseConversationsViewController for the conversation list in the Agora Chat UIKit for iOS.

Create a conversation list instance. When instantiating the conversation list, ensure that you pass the EaseConversationViewModel instance.

```
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init];

EaseConversationsViewController *easeConvsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
easeConvsVC.delegate = self;
[self addChildViewController:easeConvsVC];
[self.view addSubview:easeConvsVC.view];
[easeConvsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.equalTo(self.view);
}];
```

### V. Set styles

#### Set chat conversation styles

For a chat conversation, you need to configure the following parameters:

```
// The background color of the chat view.
@property (nonatomic, strong) UIColor *chatViewBgColor;

// The background color of the timeline.
@property (nonatomic, strong) UIColor *msgTimeItemBgColor;

// The timeline font.
@property (nonatomic, strong) UIFont *msgTimeItemFont;

// The font color of the timeline.
@property (nonatomic, strong) UIColor *msgTimeItemFontColor;

// The bubble background image of the received message.
@property (nonatomic, strong) UIImage *receiverBubbleBgImage;

// The bubble background image of the sent message.
@property (nonatomic, strong) UIImage *senderBubbleBgImage;

// Right align image/video/attachment message bubble cornerRadius.
@property (nonatomic) BubbleCornerRadius rightAlignmentCornerRadius;

// Left align image/video/attachment message bubble cornerRadius.
@property (nonatomic) BubbleCornerRadius leftAlignmentCornerRadius;

// Message bubble background protected area.
@property (nonatomic) UIEdgeInsets bubbleBgEdgeInsets;

// The font color of the sent message.
@property (nonatomic, strong) UIColor *sentFontColor;

// The font color of the receiver message.
@property (nonatomic, strong) UIColor *reveivedFontColor;

// The font of the text message.
@property (nonatomic) UIFont *textMessaegFont;

// Input menu background color and input menu gradient color mutually exclusive. display background color first.
@property (nonatomic, strong) UIColor *inputMenuBgColor;

// Input menu type.
@property (nonatomic) EaseInputMenuStyle inputMenuStyle;

// Input menu extend view model.
@property (nonatomic) EaseExtendMenuViewModel *extendMenuViewModel;

// Whether to display the sent avatar.
@property (nonatomic) BOOL displaySentAvatar;

// Whether to display the received avatar.
@property (nonatomic) BOOL displayReceivedAvatar;

// Whether to display the sent name.
@property (nonatomic) BOOL displaySentName;

// Whether to display the received name.
@property (nonatomic) BOOL displayReceiverName;

// The avatar style.
@property (nonatomic) EaseChatAvatarStyle avatarStyle;

// The corner radius of the avatar. 
// The default value is 0, indicating that only the rounded corner style is allowed.
@property (nonatomic) CGFloat avatarCornerRadius;

// The message alignment style of in the chat view.
@property (nonatomic) EaseAlignmentStyle msgAlignmentStyle;
```

extendMenuViewModel (the model for extension function data configuration in the input area, like the camera or album area on the chat conversation page) contains the following configurable parameters:

```
/*
 *  inputMenu "+" extend view style
 */
typedef NS_ENUM(NSInteger, EaseExtendViewStyle) {
    EaseInputMenuExtFuncView = 1,  //inputMenu view
    EasePopupView,                //viewcontroller popup view
};

// The background color of the icon.
@property (nonatomic, strong) UIColor *iconBgColor;

// The background color of the view.
@property (nonatomic, strong) UIColor *viewBgColor;

// The font color.
@property (nonatomic, strong) UIColor *fontColor;

// The font size.
@property (nonatomic, assign) CGFloat fontSize;

// The view size.
@property (nonatomic, assign) CGSize collectionViewSize;

// The extension view style.
@property (nonatomic) EaseExtendViewStyle extendViewStyle;
```

inputMenuStyle (input area) can be one of the following styles:

```
/*
 *  Input menu style
 */
typedef NS_ENUM(NSInteger, EaseInputMenuStyle) {
    EaseInputMenuStyleAll = 1,          //All functions
    EaseInputMenuStyleNoAudio,          //No Audio
    EaseInputMenuStyleNoEmoji,          //No Emoji
    EaseInputMenuStyleNoAudioAndEmoji,  //No Audio And Emoji
    EaseInputMenuStyleOnlyText,         //Only Text
};
```

The EaseAlignmentStyle parameter (the message alignment mode, valid only for group chats) can be either of the following message alignment modes:

```
/*
 *  Message alignment
 */
typedef NS_ENUM(NSInteger, EaseAlignmentStyle) {
    EaseAlignmentLeft_Right = 1,     //Left Right alignment
    EaseAlignmentlAll_Left,          //The left alignment
};
```

An instantiated chat controller can refresh the chat page by resetting the chat view UI configuration model.

```
// Resets the chat controller.

- (void)resetChatVCWithViewModel:(EaseChatViewModel *)viewModel;
```

##### Customize the chat UI

Agora Chat UIKit for iOS uses default UI styles. You can customize your user interface by reference to the following paragraphs.

- Example of default styles:

To customize the chat UI, you only need to modify style parameters in the EaseChatViewModel instance and then pass them to EaseChatViewController.

```
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init]; //Default styles.
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"Conversation ID" conversationType:AgoraChatConversationTypeChat chatViewModel:viewModel];
```

The following figure is an example of a chat page with default styles:

![img](./chatDefaultStyle.png)

- Configuration example of a chat page with custom styles:

Create an EaseChatViewModel instance with custom styles and pass this instance to the constructor of EaseChatViewController for the chat page.

```
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init];
viewModel.chatViewBgColor = [UIColor systemGrayColor];  //The chat background color.
viewModel.inputMenuBgColor = [UIColor systemPinkColor]; //The background color of the input area.
viewModel.sentFontColor = [UIColor redColor];           //The sender's text color.
viewModel.inputMenuStyle = EaseInputMenuStyleNoAudio;   //The menu style of the input area.
viewModel.msgTimeItemFontColor = [UIColor blackColor];  //The message time font color.
viewModel.msgTimeItemBgColor = [UIColor greenColor];    //The background color of the message time area.
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"Conversation ID" conversationType:AgoraChatConversationTypeChat chatViewModel:viewModel];
```

The following figure is a configuration example of some custom styles:

![img](./chatCustomStyle.png)

For details on more APIs, see APIs provided by EaseChatViewController and callback APIs in the EaseChatViewControllerDelegate protocol.

#### Configure conversation list styles

For the conversation list, you can configure the following parameters:

```
// Whether to display the chat room. By default, the chat room is displayed.
@property (nonatomic) BOOL displayChatroom;

// The avatar style.
@property (nonatomic) EaseChatAvatarStyle avatarType;

// The avatar size.
@property (nonatomic) CGSize avatarSize;

// The corner radius of the avatar.
@property (nonatomic) CGFloat avatarCornerRadius;

// The avatar edge insets.
@property (nonatomic) UIEdgeInsets avatarEdgeInsets;

// The top style of the conversation.
@property (nonatomic) EaseChatConversationTopStyle conversationTopStyle;

// The top background color of the conversation.
@property (nonatomic, strong) UIColor *conversationTopBgColor;

// The top icon of the conversation.
@property (nonatomic, strong) UIImage *conversationTopIcon;

// The insets of the top icon.
@property (nonatomic) UIEdgeInsets conversationTopIconInsets;

// The size of the top icon.
@property (nonatomic) CGSize conversationTopIconSize;

// The nickname font.  
@property (nonatomic, strong) UIFont *nameLabelFont;

// The nickname color.
@property (nonatomic, strong) UIColor *nameLabelColor;

// The edge insets of the nickname.
@property (nonatomic) UIEdgeInsets nameLabelEdgeInsets;

// The font of message details.
@property (nonatomic, strong) UIFont *detailLabelFont;

// The text font of message details.
@property (nonatomic, strong) UIColor *detailLabelColor;

// The edge insets of message details.
@property (nonatomic) UIEdgeInsets detailLabelEdgeInsets;

// The font of the message time.
@property (nonatomic, strong) UIFont *timeLabelFont;

// The color of the message time.
@property (nonatomic, strong) UIColor *timeLabelColor;

// The location of the message time.
@property (nonatomic) UIEdgeInsets timeLabelEdgeInsets;

// Whether to display the number of unread messages.     
@property (nonatomic) BOOL needsDisplayBadge;

// The position of the unread message badge.
@property (nonatomic) EaseChatUnReadCountViewPosition badgeLabelPosition;

// The style of the unread message badge.
@property (nonatomic) EaseChatUnReadBadgeViewStyle badgeViewStyle;

// The font of the unread message badge. 
@property (nonatomic, strong) UIFont *badgeLabelFont;

// The color of the badge title of the unread messages.
@property (nonatomic, strong) UIColor *badgeLabelTitleColor;

// The background color of the unread message badge.
@property (nonatomic, strong) UIColor *badgeLabelBgColor;

// The height of the unread message badge.
@property (nonatomic) CGFloat badgeLabelHeight;

// The height of the red dot for the unread messages.
@property (nonatomic) CGFloat badgeLabelRedDotHeight;

// The deviation of the unread message badge from the center.
@property (nonatomic) CGVector badgeLabelCenterVector;

// The displayed maximum number of unread messages. If the upper limit is exceeded, the maximum number will be followed by `+`.
@property (nonatomic) int badgeMaxNum;

// The do-not-disturb image.
@property (nonatomic, strong) UIImage *noDisturbImg;

// The insets of the do-not-disturb image.
@property (nonatomic) UIEdgeInsets noDisturbImgInsets;

// The size of the do-not-disturb image.
@property (nonatomic) CGSize noDisturbImgSize;
```

The parent class of the conversation class involves the following configurable parameters:

```
// Whether to refresh by pull-down.
@property (nonatomic) BOOL canRefresh;

// The background view of TableView.
@property (nonatomic, strong) UIView *bgView;

// The background color of UITableViewCell.
@property (nonatomic, strong) UIColor *cellBgColor;

// The insets of the dividing line of UITableViewCell.
@property (nonatomic) UIEdgeInsets cellSeparatorInset;

// The color of the dividing line of UITableViewCell.
@property (nonatomic, strong) UIColor *cellSeparatorColor;
```

##### Customize the conversation list UI

Agora Chat UIKit for iOS uses default UI styles. You can customize your conversation list by reference to the following paragraphs.

- Example of default styles:

To customize the conversation list UI, you only need to create an EaseChatViewModel instance and pass it as a parameter to the constructor of EaseChatViewController for the chat page.

```
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init]; //Default styles.
EaseConversationsViewController *chatsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
```

The following figure is an example of the conversation list with default styles:


![img](./chatsDefault.png)

- Configuration example of custom styles:

Create an EaseChatViewModel instance with custom styles and pass this instance to the constructor of EaseChatViewController for the chat page.

```
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init];
viewModel.canRefresh = YES;                                //Whether to enable refresh.
viewModel.badgeLabelCenterVector = CGVectorMake(-16, 0);   //The Badge offset of the number of unread messages.
viewModel.avatarType = Rectangular;                        //The avatar type.
viewModel.nameLabelColor = [UIColor blueColor];            //The color of the conversation name.
viewModel.detailLabelColor = [UIColor redColor];           //The color of conversation details.
viewModel.timeLabelColor = [UIColor systemPinkColor];      //The color of conversation time.
viewModel.cellBgColor = [UIColor lightGrayColor];          //The background color of the conversation cell.
viewModel.badgeLabelBgColor = [UIColor purpleColor];       //The background color of the number of unread messages.

EaseConversationsViewController *chatsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
```

The following figure is a configuration example of some custom styles:

![img](./chatsCustom.png)

For details on more APIs, see APIs provided by EaseConversationsViewController and callback APIs in the EaseConversationsViewControllerDelegate protocol.

### Custom function extensions

#### Custom conversation function extensions

After EaseChatViewController is instantiated, you can implement the EaseChatViewControllerDelegate protocol (chat controller callback delegate) to receive the callback of EaseChatViewController and further implement custom extensions.

```
EaseChatViewControllerDelegate
```

#### Callback for a custom message cell

You can get the custom message cell by implementing the conversation list callback protocol.

If nil is returned, the default message cell will be used; if cell is returned, a custom message cell will be used.

```
/**
 * Customize cell.
 *
 * @param tableView        The table view of the current message view.
 * @param messageModel     The message data model.
 *
 */
- (UITableViewCell *)cellForItem:(UITableView *)tableView messageModel:(EaseMessageModel *)messageModel;
```

##### Callback of a selected message

Callback of a selected message (chat-uikit does provide callback for a selected message cell and you need to implement the callback yourself).

```
/**
 * Message click callback.
   
 * It returns whether the default click event needs to be executed: 
 * - `YES`: The event needs to be executed.
 * - `NO`: The event does not need to be executed.
 *
 * @param   message         The selected message.
 * @param   userData        The user profile contained in the selected message.
 *
 */
- (BOOL)didSelectMessageItem:(AgoraChatMessage *)message userProfile:(id<EaseUserProfile>)userData;
```

##### User profile callback

Callback of the user profile (such as the avatar and nickname).

```
/**
 * User profile callback
 *
 * @discussion  Users will match the user ID against those in their own user system. If a match is found, the related user profile is returned; if `nil` is returned, the default implementation is used.
 *
 * @param   userID        The user ID.
 *
 */
- (id<EaseUserProfile>)userProfile:(NSString *)userID;
```

Example of user profile callback in the Chat app:

```
- (id<EaseUserProfile>)userProfile:(NSString *)userID
{
    AgoraChatUserDataModel *model = nil;
    AgoraChatUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:userID];
    if(userInfo) {
        model = [[AgoraChatUserDataModel alloc]initWithUserInfo:userInfo];
    }else{
        [[UserInfoStore sharedInstance] fetchUserInfosFromServer:@[userID]];
    }
    return model;
}
```

##### Callback for a selected avatar

```
/**
 * Occurs when an avatar is selected.
 *
 * @param   userData        The user profile that contains the selected avatar.
 *
 */
- (void)avatarDidSelected:(id<EaseUserProfile>)userData;
```

##### Callback for holding down the avatar

```
/**
 * Occurs when the avatar is held down.
 *
 * @param   userData        Occurs when the avatar is held down.
 *
 */
- (void)avatarDidLongPress:(id<EaseUserProfile>)userData;
```

##### Callback for the input area

The data model group for the input extension area of the current conversation (UI configurations can be implemented in the chat view configuration data model).

```
/**
 * The data model group for the input extension area.
 *
 * @param   defaultInputBarItems        The data model group for the input extension area (default order: album, camera attachments).
 * @param   conversationType            The current conversation type: single chat, group chat, chat room.
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)inputBarExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultInputBarItems conversationType:(AgoraChatConversationType)conversationType;
```

##### Callback for a keyboard input change

```
/**
 * Example of callback for a keyboard input change in the input area: @ group member
 *
 * @brief Example of callback for a keyboard input change: @ group member
 */
- (BOOL)textView:(UITextView*)textView ShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
```

##### Callback for the input status of the other party

The callback triggered when the peer user is typing. This callback is valid only for one-to-one chats.

```
/**
 * Occurs when the peer user is typing during a one-to-one chat.
 */
- (void)peerTyping;
```

Callback triggered when the other party completes typing. This callback is valid only for one-to-one chats.

```
/**
 * Occurs when the peer user completes typing.
 */
- (void)peerEndTyping;
```

##### Callback for a message holding down event

###### Callback for holding down the default message cell

```
/**
 * Occurs when the default message cell is held down.
 *
 * @param   defaultLongPressItems   A list of action options (copy, delete, and recall) shown when the default message cell is held down (the delivery time is less than 2 minutes).
 * @param   message                  The default message cell.
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)messageLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems message:(AgoraChatMessage*)message;
```

###### Callback for holding down a custom message cell

Callback for holding down a custom message cell.

```
/**
 * Occurs when a custom message cell is held down.
 *
 * @param   defaultLongPressItems       A list of default action options (copy, delete, and recall) shown when a custom message cell is held down (the delivery time is less than 2 minutes).
 * @param   customCell                  The custom message cell that is held down.
 */
- (NSMutableArray<EaseExtendMenuModel *> *)customCellLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems customCell:(UITableViewCell*)customCell;
```

#### Custom function extension of the conversation list

After EaseConversationsViewController is instantiated, you can implement the EaseConversationsViewControllerDelegate protocol (conversation list callback delegate) to receive the callback of EaseConversationsViewController and further implement custom extensions.

```
EaseConversationsViewControllerDelegate
```
 
#### Callback for a custom conversation cell

You can obtain the custom conversation cell by implementing the conversation list callback.

If `nil` is returned, the default conversation cell will be used; if cell is returned, a custom conversation cell will be used.

```
/*
 *@method
 *@brief  Occurs when a custom conversation cell is used.
 *@discussion  Returns nil to use the default cell; otherwise, a custom cell will be used.
 *@param  tableView  The table view of the current message view.
 *@param  indexPath  The indexPath of the conversation cell.
 *@result The custom conversation cell.
 */
- (EaseConversationCell *)easeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

##### Callback for cell selection on the the conversation list

```
/*
 *@method
 *@brief     Occurs when a cell is selected on the conversation list.
 *@param     tableView        The table view of the current message view.
 *@param     indexPath        The indexPath of the cell for sideslip.
 */
- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//Example for cell selection on the conversation list (valid only for the Chat app).
  
- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EaseConversationCell *cell = (EaseConversationCell*)[tableView cellForRowAtIndexPath:indexPath];
    ACDChatViewController *chatViewController = [[ACDChatViewController alloc] initWithConversationId:cell.model.easeId conversationType:cell.model.type];
    chatViewController.navTitle = cell.model.showName;
    chatViewController.hidesBottomBarWhenPushed = YES;
  
    //Jump to the chat page.
    [self.navigationController pushViewController:chatViewController animated:YES];
}
```

##### Callback for the user profile of the conversation list

```
/*
 @method
 @brief         Callback for the user profile of the conversation list.
 @discussion    The user profile dataset can be returned according to the ID or type of conversation.
 @param   conversationId    The conversation ID.
 @param   type              The conversation Type.
 */
- (id<EaseUserProfile>)easeUserProfileAtConversationId:(NSString *)conversationId
                                      conversationType:(AgoraChatConversationType)type;
//Example of callback for the user profile of the conversation list (valid only for the Chat app).

- (id<EaseUserProfile>)easeUserProfileAtConversationId:(NSString *)conversationId conversationType:(AgoraChatConversationType)type
{
    AgoraChatConvUserDataModel *userData = nil;
    if(type == AgoraChatConversationTypeChat) {
        AgoraChatUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:conversationId];
        if(userInfo) {
            userData = [[AgoraChatConvUserDataModel alloc]initWithUserInfo:userInfo conversationType:type];
        }else{
            [[UserInfoStore sharedInstance] fetchUserInfosFromServer:@[conversationId]];
        }
    }
    return userData;
}
```

##### Callback for cell sideslip items of the conversation list

```
/*
 *@method
 *@brief     Occurs when a cell on the conversation list sideslips.
 *@param     tableView     tableView of the current message view.
 *@param     indexPath     The indexPath of the cell for sideslip.
 *@param     actions       A collection of cell sideslip items.
 */
- (NSArray<UIContextualAction *> *)easeTableView:(UITableView *)tableView
      trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath
                                    actions:(NSArray<UIContextualAction *> *)actions;
```

##### Callback for the cell sideslip status of the conversation list

```
- (void)easeTableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)easeTableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
```

#### Live Streaming Chat Room

#### 1.The message list of a live streaming chat room

##### Create a message list of the live streaming chat room

```
/// Initializes a chat view.
/// @param frame           The frame of the chat view.
/// @param chatroom        An Agora chat room.
/// @param customMsgHelper The custom message helper.
/// @param customOption    The custom option of the chat view.
- (instancetype)initWithFrame:(CGRect)frame
                     chatroom:(AgoraChatroom*)chatroom
              customMsgHelper:(EaseCustomMessageHelper*)customMsgHelper
                 customOption:(EaseChatViewCustomOption *)customOption;
```

##### Send a gift message in the chat room

```
/// Sends a gift.
/// @param giftId  The gift ID.
/// @param num     The number of gifts.
/// @param aCompletion The callback for sending a gift message.
- (void)sendGiftAction:(NSString *)giftId
                   num:(NSInteger)num
            completion:(void (^)(BOOL success))aCompletion;
```

##### Whether to display the chat view

```
/// Whether to display or hide the chat view.
/// @param isHidden Whether to hide the chat view.
- (void)updateChatViewWithHidden:(BOOL)isHidden;
```

##### Update the title of sendTextButton

```
/// Updates the title of sendTextButton.
/// @param hint sendTextButton title
- (void)updateSendTextButtonHint:(NSString *)hint;
```

##### Chat room delegate methods

###### The custom message cell

```
/// Displays the custom message cell position, i.e., the indexpath in the table view.
/// @param indexPath indexPath
- (UITableViewCell *)easeMessageCellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

###### The height of the custom message cell

```
/// Displays the height of the custom message cell.
/// @param indexPath indexPath
- (CGFloat)easeMessageCellHeightAtIndexPath:(NSIndexPath *)indexPath;
```

###### The custom join cell

```
/// Displays the custom join cell.
/// @param indexPath indexPath
- (UITableViewCell *)easeJoinCellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

###### The height of the custom join cell

```
/// Displays the height of the custom join cell.
/// @param indexPath indexPath
- (CGFloat)easeJoinCellHeightAtIndexPath:(NSIndexPath *)indexPath;
```

###### The message tap callback

```
/// The message tap callback.
/// @param message  The tapped message.
- (void)didSelectUserWithMessage:(AgoraChatMessage*)message;
```

###### The callback for popping up an input box

```
/// Changes the offset of the chat view from the bottom edge of the current window. 
/// @param offset  The offset of the chat view from the bottom edge of the current window.
- (void)chatViewDidBottomOffset:(CGFloat)offset;
```

###### The message sending callback

```
/// Sends a message in the EaseChatView.
/// @param message The message that is sent.
/// @param error The error information.
- (void)chatViewDidSendMessage:(AgoraChatMessage *)message
                         error:(AgoraChatError *)error;
```

##### 2. Set custom chat room options

```
/**
 * Set the custom message cell in the EaseChatView.   
 */
@property (nonatomic, assign) BOOL customMessageCell;
/**
 * Set the custom join cell.
 */
@property (nonatomic, assign) BOOL customJoinCell;

/**
 * Set the background color of the EaseChatView.
 */
@property (nonatomic, strong) UIColor *tableViewBgColor;

/**
 * Set the right margin of EaseChatView.
 */
@property (nonatomic, assign) CGFloat tableViewRightMargin;

/**
 * Set the bottom margin of the sendTextButton of EaseChatView.
 */
@property (nonatomic, assign) CGFloat sendTextButtonBottomMargin;

/**
 * Set the right margin of the sendTextButton of EaseChatView.
 */
@property (nonatomic, assign) CGFloat sendTextButtonRightMargin;

/**
 * Set whether to display the sender avatar view.
 */
@property (nonatomic, assign) BOOL   displaySenderAvatar;

/**
 * Set whether to display the sender nickname.
 */
@property (nonatomic, assign) BOOL   displaySenderNickname;

/**
 * Set the avatar style.
 */
@property (nonatomic) EaseChatAvatarStyle avatarStyle;

/**
 * Set the corner radius of the avatar.
 * 
 * The default value is 0, indicating that only the rounded corner style is allowed.
 */
@property (nonatomic) CGFloat avatarCornerRadius;

/**
 * Set the background color of the content view of a message cell.
 */
@property (nonatomic, strong) UIColor *cellBgColor;

/**
 * Set the text font size of the name label.
 */
@property (nonatomic, assign) CGFloat nameLabelFontSize;
/**
 * Set the text color of the name label.
 */
@property (nonatomic, strong) UIColor *nameLabelColor;
/**
 * Set the font size of the message label.
 */
@property (nonatomic, assign) CGFloat messageLabelSize;

/**
 * Set the text color of the message label.
 */
@property (nonatomic, strong) UIColor *messageLabelColor;
```

##### 3. Send a custom message

###### Create the class for the custom message helper

```
/// Creates a EaseCustomMessageHelper instance.
/// @param customMsgImp   The delegate which implements EaseCustomMessageHelperDelegate.
/// @param chatId         The chat room ID.
- (instancetype)initWithCustomMsgImp:(id<EaseCustomMessageHelperDelegate>)customMsgImp chatId:(NSString*)chatId;
```

###### Send a custom message

```
/*
 Sends a custom message (such as a gift, like, or barrage).
 @param text                 The message content.
 @param num                  Number of message content
 @param messageType          chat type
 @param customMsgType        The custom message type
 @param aCompletionBlock     The completion block.
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;
```

###### Send a custom message (with extension parameters)

```
/*
 Sends a custom message (such as a gift, like, or barrage) (with extension parameters).
 @param text                 The message content.
 @param num                  Number of message content
 @param messageType          chat type
 @param customMsgType        The custom message type
 @param ext                  The message extension.
 @param aCompletionBlock     The completion block.
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
                      ext:(NSDictionary*)ext
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;
```

###### Event for sending a custom message body (other custom message body events)

```
/*
 Sends a custom message (other custom message body events).
 
@param event                The event for sending a custom message body.
@param customMsgBodyExt     The extension parameters in the custom message body.
@param to                   The message recipient.
@param messageType          The message type.
@param aCompletionBlock     The completion block.
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;
```

###### Event for sending a custom message body (with extension parameters)

```
/*
 Sends a custom message (Other custom message body events) (extension parameters).
 
@param event                The event for sending a custom message body.
@param customMsgBodyExt     The extension parameters in the custom message body.
@param to                   The message recipient.
@param messageType          The message type.
@param ext                  The message extension.
@param aCompletionBlock     The completion block.
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                          ext:(NSDictionary*)ext
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;
```

##### 4. Get user information

###### Create a user information manager helper class

```
/// create EaseUserInfoManagerHelper instance.
+ (EaseUserInfoManagerHelper *)sharedHelper;
```

###### Get user information by user IDs

```
/// Gets user information.
/// @param userIds The user IDs.
/// @param completion The completion block.
+ (void)fetchUserInfoWithUserIds:(NSArray<NSString *> *)userIds
                      completion:(void(^)(NSDictionary *userInfoDic))completion;
```

###### Get user information by user IDs and information types

```
/// Gets user information by user ID and information type.
/// @param userIds The user IDs.
/// @param userInfoTypes The user information types.
/// @param completion The completion block.
+ (void)fetchUserInfoWithUserIds:(NSArray<NSString *> *)userIds
                   userInfoTypes:(NSArray<NSNumber *> *)userInfoTypes
                      completion:(void(^)(NSDictionary *userInfoDic))completion;
```

###### Update user information

```
/// Updates user information.
/// @param userInfo The user information.
/// @param completion The completion block.
+ (void)updateUserInfo:(AgoraChatUserInfo *)userInfo
            completion:(void(^)(AgoraChatUserInfo *aUserInfo))completion;
```

###### Update user information by user ID

```
/// Updates user information by user ID.
/// @param userId The user ID.
/// @param type The user information type.
/// @param completion The completion block.
+ (void)updateUserInfoWithUserId:(NSString *)userId
                        withType:(AgoraChatUserInfoType)type
                      completion:(void(^)(AgoraChatUserInfo *aUserInfo))completion;
```

###### Get the information of the current logged-in user

```
/// Gets the information of the current logged-in user.
/// @param completion The completion block.
+ (void)fetchOwnUserInfoCompletion:(void(^)(AgoraChatUserInfo *ownUserInfo))completion;
+ ``` 
```
