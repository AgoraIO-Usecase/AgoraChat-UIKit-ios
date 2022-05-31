# AgoraChatUIKit iOS 使用指南

## 功能描述

chat-uikit 是基于声网 IM SDK 的一款 UI 组件库，它提供了一些通用的 UI 组件，“会话列表”和“聊天界面”，开发者可根据实际业务需求通过该组件库快速地搭建自定义 IM 应用。chat-uikit 中的组件在实现 UI 功能的同时，调用 IM SDK 相应的接口实现 IM 相关逻辑和数据的处理，因而开发者在使用 chat-uikit 时只需关注自身业务或个性化扩展即可。

chat-uikit 源码地址：
  * https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git chat-uikit工程

使用 chat-uikit 的声网 IM App 地址：
  * https://github.com/AgoraIO-Usecase/AgoraChat-ios.git 声网IM

## 前提条件

支持系统版本要求：

  * chat-uikit 支持 iOS 11.0及以上系统版本
  * AgoraChatIM 支持 iOS 11.0及以上系统版本

## 集成步骤

### 一、导入

#### 安装 Cocoapods 工具

1. 开始前确保你已安装 Cocoapods。参考 [Getting Started with CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started) 安装说明。
2. 在终端里进入项目根目录，并运行 `pod init` 命令。项目文件夹下会生成一个 `Podfile` 文本文件。

有两种方式集成，使用 pod 方式集成 chat-uikit 或者源码集成 chat-uikit，具体步骤如下：

#### 使用 pod 方式集成 chat-uikit

1. 打开 `Podfile` 文件，添加 chat-uikit 依赖。注意将 `ProjectName` 替换为你的 Target 名称。

```ruby
platform :ios, '11.0'

# Import CocoaPods sources
source 'https://github.com/CocoaPods/Specs.git'

target 'ProjectName' do
    pod 'chat-uikit'
end
```

2. 在终端 Terminal cd 到 podfile 文件所在目录，执行如下命令集成 SDK。

```objective-c
pod install
```

3. 成功安装后，Terminal 中会显示 `Pod installation complete!`，此时项目文件夹下会生成一个 `xcworkspace` 文件，打开新生成的 `xcworkspace` 文件运行项目。

<alert>
注意：

chat-uikit 依赖于 AgoraChat SDK，其中包含了拍照，发语音，发图片，发视频，发附件等功能，需要使用录音，摄像头，相册权限。需要在您项目的 info.plist 中添加对应权限。
</alert>

##### 源码集成 chat-uikit

1. github 下载源码

源码下载地址：https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git

Terminal command : git clone https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git

2. 项目添加 chat-uikit 源码依赖

打开 `Podfile` 文件，在 podfile 文件里添加 chat-uikit 依赖。

Podfile 文件示例：

```ruby
platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'ProjectName' do
    pod 'chat-uikit',  :path => "../chat-uikit"
end

#chat-uikit path 路径需指向 chat-uikit.podspec 文件所在目录
```

3. 项目集成本地 chat-uikit 源码

终端 Terminal cd 到 Podfile 文件所在目录，执行 pod install 命令在项目中安装 chat-uikit 本地源码

执行完成后，则在 Xcode 项目目录 Pods/Development Pods/ 可找到 chat-uikit 源码

可对源码进行符合自己项目目标的自定义修改

### 二、添加权限

在项目 `info.plist` 中添加相关权限：

```xml
Privacy - Photo Library Usage Description //相册权限
Privacy - Microphone Usage Description //麦克风权限
Privacy - Camera Usage Description //相机权限
App Transport Security Settings -> Allow Arbitrary Loads //开启网络服务
```

### 参考

如果在源码自定义过程中有任何通用自定义都可以给我们仓库 https://github.com/AgoraIO-Usecase/AgoraChat-UIKit-ios.git 提交代码，成为社区贡献者。

### 三、初始化

#### 1. 引入头文件

```objective-c
#import <chat-uikit/EaseChatKit.h>
```

#### 2. 初始化chat-uikit

在工程的 AppDelegate.m 中的以下方法中调用 EaseChatKitManager 的初始化方法一并初始化声网 AgoraChat sdk。(注: 此方法无需重复调用)

```objective-c
(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	AgoraChatOptions *options = [AgoraChatOptions optionsWithAppkey:@"You created APPKEY"];
	[EaseChatKitManager initWithAgoraChatOptions:options];
	//登录操作
	return YES;
}
```

#### 3. 接收未读数回调

EaseChatKitManagerDelegate 主要是会话未读数回调。
用户需要注册自己的类到 EaseChatKitManagerDelegate 才可收到未读总数变化回调。

```objective-c
/*
 @method
 @brief   会话未读总数变化。
 @param   unreadCount     当前会话列表的总未读数。
 */

- (void)conversationsUnreadCountUpdate:(NSInteger)unreadCount;
```

### 四、快速搭建

#### 聊天会话快速搭建

##### 1. 导入头文件

```objective-c
#import <chat-uikit/EaseChatKit.h>
```

##### 2. 加载会话页面

chat-uikit 提供聊天会话 ViewController，可以通过创建 EaseChatViewController 实例，并嵌入进自己的聊天控制器方式（参考 AgoraChatIM 中 ACDChatViewController.m）实现对 chat-uikit 聊天会话的集成。
创建聊天会话页面实例，需传递用户‘会话 ID’或‘群 ID’ ，会话类型（AgoraChatConversationType）以及必须传入聊天视图配置数据模型 EaseChatViewModel 实例。

```objective-c
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init];
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"custom"
                                              conversationType:AgoraChatConversationTypeChat
                                                  chatViewModel:viewModel];
[self addChildViewController:chatController];
[self.view addSubview:chatController.view];
chatController.view.frame = self.view.bounds;
```

#### 会话列表快速搭建

##### 1. 导入头文件

```objective-c
#import <chat-uikit/EaseChatKit.h>
```

##### 2.加载会话列表

在自己聊天控制器内可嵌入 chat-uikit 的会话列表 EaseConversationsViewController，创建会话列表实例，实例化会话列表必须传入会话列表视图数据配置模型 EaseConversationViewModel 实例。

```objective-c
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init];

EaseConversationsViewController *easeConvsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
easeConvsVC.delegate = self;
[self addChildViewController:easeConvsVC];
[self.view addSubview:easeConvsVC.view];
[easeConvsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.equalTo(self.view);
}];
```

### 设置样式

#### 聊天会话样式配置

聊天会话可配置参数如下：

```objective-c
// Chat view background color
@property (nonatomic, strong) UIColor *chatViewBgColor;

// Timeline background color
@property (nonatomic, strong) UIColor *msgTimeItemBgColor;

// Timeline font
@property (nonatomic, strong) UIFont *msgTimeItemFont;

// Timeline font color
@property (nonatomic, strong) UIColor *msgTimeItemFontColor;

// Bubble background image of received message
@property (nonatomic, strong) UIImage *receiverBubbleBgImage;

// Bubble background image of sent message
@property (nonatomic, strong) UIImage *senderBubbleBgImage;

// Right align image/video/attachment message bubble cornerRadius
@property (nonatomic) BubbleCornerRadius rightAlignmentCornerRadius;

// Left align image/video/attachment message bubble cornerRadius
@property (nonatomic) BubbleCornerRadius leftAlignmentCornerRadius;

// Message bubble background protected area
@property (nonatomic) UIEdgeInsets bubbleBgEdgeInsets;

// Sent message font color
@property (nonatomic, strong) UIColor *sentFontColor;

// Receiver message font Color
@property (nonatomic, strong) UIColor *reveivedFontColor;

// Text message font
@property (nonatomic) UIFont *textMessaegFont;

// Input menu background color and input menu gradient color mutually exclusive. display background color first
@property (nonatomic, strong) UIColor *inputMenuBgColor;

// Input menu type
@property (nonatomic) EaseInputMenuStyle inputMenuStyle;

// Input menu extend view model
@property (nonatomic) EaseExtendMenuViewModel *extendMenuViewModel;

// Display sent avatar
@property (nonatomic) BOOL displaySentAvatar;

// Display received avatar
@property (nonatomic) BOOL displayReceivedAvatar;

// Display sent name
@property (nonatomic) BOOL displaySentName;

// Display received name
@property (nonatomic) BOOL displayReceiverName;

// Avatar style
@property (nonatomic) EaseChatAvatarStyle avatarStyle;

// Avatar cornerRadius Default: 0 (Only avatar type RoundedCorner)
@property (nonatomic) CGFloat avatarCornerRadius;

// Chat view message alignment
@property (nonatomic) EaseAlignmentStyle msgAlignmentStyle;
```

其中参数：extendMenuViewModel 输入区扩展功能数据配置模型(聊天会话页相机，相册等区域)内含可配参数：

```objective-c
/*
 *  inputMenu "+" extend view style
 */
typedef NS_ENUM(NSInteger, EaseExtendViewStyle) {
    EaseInputMenuExtFuncView = 1,  //inputMenu view
    EasePopupView,                //viewcontroller popup view
};

// Icon background color
@property (nonatomic, strong) UIColor *iconBgColor;

// View background color
@property (nonatomic, strong) UIColor *viewBgColor;

// Font color
@property (nonatomic, strong) UIColor *fontColor;

// Font size
@property (nonatomic, assign) CGFloat fontSize;

// View size
@property (nonatomic, assign) CGSize collectionViewSize;

// Extend view style
@property (nonatomic) EaseExtendViewStyle extendViewStyle;
```

其中参数：inputMenuStyle（输入区）包含五种样式：

```objective-c
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

其中参数：EaseAlignmentStyle （消息排列方式,仅群聊可生效）包含两种类型

```objective-c
/*
 *  Message alignment
 */
typedef NS_ENUM(NSInteger, EaseAlignmentStyle) {
    EaseAlignmentLeft_Right = 1,     //Left Right alignment
    EaseAlignmentlAll_Left,          //The left alignment
};
```

实例化的聊天控制器可通过重置视图 UI 配置模型刷新页面。

```objective-c
//重置聊天控制器。

- (void)resetChatVCWithViewModel:(EaseChatViewModel *)viewModel;
```

##### 聊天会话自定义样式示例

chat-uikit 显示的是默认的UI样式，以下是对聊天会话样式进行自定义配置示例：

* 默认样式示例：

只需创建 EaseChatViewModel 实例，并作为参数传入聊天页面 EaseChatViewController 的构造方法。

```objective-c
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init]; //默认样式
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"Conversation ID" conversationType:AgoraChatConversationTypeChat chatViewModel:viewModel];
```

默认样式的聊天页面示例图：

// TODO:合并之后确定地址

![]()

* 自定义样式配置示例：

创建 EaseChatViewModel 实例，修改该实例的可配置样式参数，将实例传入聊天页面 EaseChatViewController 的构造方法。

```objective-c
EaseChatViewModel *viewModel = [[EaseChatViewModel alloc]init];
viewModel.chatViewBgColor = [UIColor systemGrayColor];  //聊天页背景色
viewModel.inputMenuBgColor = [UIColor systemPinkColor]; //输入区背景色
viewModel.sentFontColor = [UIColor redColor];           //发送方文本颜色
viewModel.inputMenuStyle = EaseInputMenuStyleNoAudio;   //输入区菜单样式
viewModel.msgTimeItemFontColor = [UIColor blackColor];  //消息时间字体颜色
viewModel.msgTimeItemBgColor = [UIColor greenColor];    //消息时间区域背景色
EaseChatViewController *chatController = [EaseChatViewController initWithConversationId:@"Conversation ID" conversationType:AgoraChatConversationTypeChat chatViewModel:viewModel];
```

部分自定义样式配置示例图：

// TODO:合并之后确定地址

![]()

关于更多 API 介绍请参考 EaseChatViewController 提供的 API，以及 EaseChatViewControllerDelegate 协议中的回调方法 API。

#### 会话列表样式配置

会话列表可配置参数如下：

```objective-c
// display chatroom
@property (nonatomic) BOOL displayChatroom;

// avatar style
@property (nonatomic) EaseChatAvatarStyle avatarType;

// avatar size
@property (nonatomic) CGSize avatarSize;

// avatar cornerRadius
@property (nonatomic) CGFloat avatarCornerRadius;

// avatar location
@property (nonatomic) UIEdgeInsets avatarEdgeInsets;

// conversation top style
@property (nonatomic) EaseChatConversationTopStyle conversationTopStyle;

// conversation top bgColor
@property (nonatomic, strong) UIColor *conversationTopBgColor;

// conversation top icon
@property (nonatomic, strong) UIImage *conversationTopIcon;

// top icon location
@property (nonatomic) UIEdgeInsets conversationTopIconInsets;

// top icon size
@property (nonatomic) CGSize conversationTopIconSize;

// nickname font
@property (nonatomic, strong) UIFont *nameLabelFont;

// nickname color
@property (nonatomic, strong) UIColor *nameLabelColor;

// nickname location
@property (nonatomic) UIEdgeInsets nameLabelEdgeInsets;

// message detail font
@property (nonatomic, strong) UIFont *detailLabelFont;

// message detail text font
@property (nonatomic, strong) UIColor *detailLabelColor;

// message detail location
@property (nonatomic) UIEdgeInsets detailLabelEdgeInsets;

// message time font
@property (nonatomic, strong) UIFont *timeLabelFont;

// message time color
@property (nonatomic, strong) UIColor *timeLabelColor;

// message time location
@property (nonatomic) UIEdgeInsets timeLabelEdgeInsets;

// needs displayed Unread messages number
@property (nonatomic) BOOL needsDisplayBadge;

// message unread position
@property (nonatomic) EaseChatUnReadCountViewPosition badgeLabelPosition;

// message unread style
@property (nonatomic) EaseChatUnReadBadgeViewStyle badgeViewStyle;

// message unread font
@property (nonatomic, strong) UIFont *badgeLabelFont;

// message unread text color
@property (nonatomic, strong) UIColor *badgeLabelTitleColor;

// message unread bgColor
@property (nonatomic, strong) UIColor *badgeLabelBgColor;

// message unread angle height
@property (nonatomic) CGFloat badgeLabelHeight;

// message unread red dot height
@property (nonatomic) CGFloat badgeLabelRedDotHeight;

// message unread center position deviation
@property (nonatomic) CGVector badgeLabelCenterVector;

// message unread display limit, display after the upper limit is exceeded xx+
@property (nonatomic) int badgeMaxNum;

// no disturb image
@property (nonatomic, strong) UIImage *noDisturbImg;

// no disturb image location
@property (nonatomic) UIEdgeInsets noDisturbImgInsets;

// no disturb image size
@property (nonatomic) CGSize noDisturbImgSize;
```

会话列表父类可配置参数如下：

```objective-c
// Whether to refresh by pull-down
@property (nonatomic) BOOL canRefresh;

// TableView bg view
@property (nonatomic, strong) UIView *bgView;

// UITableViewCell bg color
@property (nonatomic, strong) UIColor *cellBgColor;

// UITableViewCell cocation of the dividing line
@property (nonatomic) UIEdgeInsets cellSeparatorInset;

// UITableViewCell color of the dividing line
@property (nonatomic, strong) UIColor *cellSeparatorColor;
```

##### 会话列表自定义样式示例

chat-uikit 显示的是默认的UI样式，以下是对会话列表样式进行自定义配置示例：

* 默认样式示例：

只需创建 EaseChatViewModel 实例，并作为参数传入聊天页面 EaseChatViewController 的构造方法。

```objective-c
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init]; //默认样式
EaseConversationsViewController *chatsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
```

默认样式的聊天页面示例图：

// TODO:合并之后确定地址

![]()

* 自定义样式配置示例：

创建 EaseChatViewModel 实例，修改该实例的可配置样式参数，将实例传入聊天页面 EaseChatViewController 的构造方法。

```objective-c
EaseConversationViewModel *viewModel = [[EaseConversationViewModel alloc] init];
viewModel.canRefresh = YES;                                //是否可刷新
viewModel.badgeLabelCenterVector = CGVectorMake(-16, 0);   //未读数角标中心偏移量
viewModel.avatarType = Rectangular;                        //头像类型
viewModel.nameLabelColor = [UIColor blueColor];            //会话名称颜色
viewModel.detailLabelColor = [UIColor redColor];           //会话详情颜色
viewModel.timeLabelColor = [UIColor systemPinkColor];      //会话时间颜色
viewModel.cellBgColor = [UIColor lightGrayColor];          //会话cell背景色
viewModel.badgeLabelBgColor = [UIColor purpleColor];       //未读数背景色

EaseConversationsViewController *chatsVC = [[EaseConversationsViewController alloc] initWithModel:viewModel];
```

部分自定义样式配置示例图：

// TODO:合并之后确定地址

![]()

关于更多 API 介绍请参考 EaseConversationsViewController 提供的 API，以及 EaseConversationsViewControllerDelegate 协议中的回调方法 API。

### 自定义功能扩展

#### 会话自定义功能扩展

实例化 EaseChatViewController 之后，可选择实现EaseChatViewControllerDelegate 协议（聊天控制器回调代理），接收 EaseChatViewController 的回调并做进一步的自定义实现。

EaseChatViewControllerDelegate

#### 自定义会话 cell 回调

通过实现聊天控制回调获取自定义消息 cell，根据 messageModel，用户自己判断是否显示自定义消息 cell。如果返回 nil 会显示默认；如果返回 cell 会显示用户自定义消息cell。

```objective-c
/**
 * Customize cell.
 *
 * @param tableView        Current Message view tableView
 * @param messageModel     Message data model
 *
 */
- (UITableViewCell *)cellForItem:(UITableView *)tableView messageModel:(EaseMessageModel *)messageModel;
```

##### 选中消息的回调

选中消息的回调（chat-uikit 没有对于自定义 cell 的选中事件回调，需用户自定义实现选中响应）。

```objective-c
/**
 * Message click event (returns whether the default click event needs to be executed) Defaults to YES
 *
 * @param   message         The currently clicked message
 * @param   userData        The user profile carried by the currently clicked message
 *
 */
- (BOOL)didSelectMessageItem:(AgoraChatMessage *)message userProfile:(id<EaseUserProfile>)userData;

```

##### 用户资料回调

用户资料回调（头像、昵称等）。

```objective-c
/**
 * Returns user profile.
 *
 * @discussion  Users according to huanxinID in their own user system to match the corresponding user information, and return the corresponding information, otherwise the default implementation.
 *
 * @param   huanxinID        The huanxin ID.
 *
 */
- (id<EaseUserProfile>)userProfile:(NSString *)huanxinID;
```

用户资料回调 AgoraChatIM Demo 中使用示例：

```objective-c
- (id<EaseUserProfile>)userProfile:(NSString *)huanxinID
{
    AgoraChatUserDataModel *model = nil;
    AgoraChatUserInfo* userInfo = [[UserInfoStore sharedInstance] getUserInfoById:huanxinID];
    if(userInfo) {
        model = [[AgoraChatUserDataModel alloc]initWithUserInfo:userInfo];
    }else{
        [[UserInfoStore sharedInstance] fetchUserInfosFromServer:@[huanxinID]];
    }
    return model;
}
```

##### 选中头像回调

```objective-c
/**
 * Avatar click event
 *
 * @param   userData        The profile of the user pointed to by the currently clicked avatar.
 *
 */
- (void)avatarDidSelected:(id<EaseUserProfile>)userData;
```

##### 头像长按回调

```objective-c
/**
 * Avatar long press event
 *
 * @param   userData        The current long-pressed Avatar points to the user profile.
 *
 */
- (void)avatarDidLongPress:(id<EaseUserProfile>)userData;
```

##### 输入区回调

当前会话输入扩展区数据模型组（UI 配置可在聊天视图配置数据模型中设置）

```objective-c
/**
 * The current Conversation enters the extended area data model group
 *
 * @param   defaultInputBarItems        The default function Data model group (default order: photo album, camera, attachments).
 * @param   conversationType            The current Conversation type: single chat, group chat, chat room.
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)inputBarExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultInputBarItems conversationType:(AgoraChatConversationType)conversationType;
```

##### 键盘输入变化回调

```objective-c
/**
 * Input area Keyboard input change callback example: @ group member
 *
 * @brief Input area Keyboard input change callback example: @ group member
 */
- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
```

##### 对方输入状态回调

对方正在输入状态回调（单聊有效）。

```objective-c
/**
 * In one-to-one chat, the other party is typing.
 */
- (void)peerTyping;
```

对方结束输入回调（单聊有效）。

```objective-c
/**
 * In one-to-one chat, the other party is typing.
 */
- (void)peerEndTyping;
```

##### 消息长按事件回调

###### 默认消息 cell 长按回调

```objective-c
/**
 * The extended area data model group for the current specific message
 *
 * @param   defaultLongPressItems       The default long press extended area function Data model group (default: copy, delete, recall).
 * @param   message                     The current long-press message.
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)messageLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems message:(AgoraChatMessage*)message;
```

###### 自定义 cell 长按回调

用户自定义消息 cell 长按事件回调。

```objective-c
/**
 * The extension data model group of the current custom cell.
 *
 * @param   defaultLongPressItems       The default long - press extended area functional data model group.    (The default values are copy, delete, and recall (the sending time is less than 2 minutes).)
 * @param   customCell                  The current long - pressed custom cell.
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)customCellLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems customCell:(UITableViewCell*)customCell;
```

#### 会话列表自定义功能扩展

实例化 EaseConversationsViewController 之后，可选择实现 EaseConversationsViewControllerDelegate 协议（会话列表回调代理），接收 EaseConversationsViewController 的回调并做进一步的自定义实现。

```objective-c
EaseConversationsViewControllerDelegate
```

#### 自定义cell回调

通过实现会话列表回调获取自定义消息 cell。

如果返回 nil 会显示默认；如果返回 cell 则会显示用户自定义 cell。

```objective-c
/*
 *@method
 *@brief  Customize the conversation cell.
 *@discussion  Returns nil to display the default cell, otherwise display user-defined cell.
 *@param  tableView  The current Message view tableView.
 *@param  indexPath  The currently display the indexpath of the cell
 *@result Returns the customized cell.
 */
- (EaseConversationCell *)easeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
```

##### 会话列表 cell 选中回调

```objective-c
/*
 *@method
 *@brief     The conversation list cell Select callback.
 *@param     tableView        The current Message view tableView.
 *@param     indexPath        The currently display the indexpath of the cell.
 */
- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
```

```objective-c
//会话列表 cell 选中回调示例（AgoraChatIM APP 有效）：
  
- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EaseConversationCell *cell = (EaseConversationCell*)[tableView cellForRowAtIndexPath:indexPath];
    ACDChatViewController *chatViewController = [[ACDChatViewController alloc] initWithConversationId:cell.model.easeId conversationType:cell.model.type];
    chatViewController.navTitle = cell.model.showName;
    chatViewController.hidesBottomBarWhenPushed = YES;
  
    //跳转至聊天页。
    [self.navigationController pushViewController:chatViewController animated:YES];
}
```

##### 会话列表用户资料回调

```objective-c
/*
 @method
 @brief          The Conversation list User Profile callback.
 @discussion       The user profile data set can be returned based on conversationId or Type.
 @param   conversationId    The conversation ID.
 @param   type              The conversation Type.
 */
- (id<EaseUserProfile>)easeUserProfileAtConversationId:(NSString *)conversationId
                                      conversationType:(AgoraChatConversationType)type;
```

```objective-c
//会话列表用户资料回调示例（AgoraChatIM APP 有效）。

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

##### 会话列表 cell 侧滑项回调

```objective-c
/*
 *@method
 *@brief     会话列表 cell 侧滑项回调。
 *@param     tableView     当前消息视图的 tableView。
 *@param     indexPath     当前所要侧滑 cell 的 indexPath。
 *@param     actions       返回侧滑项集合。
 */
- (NSArray<UIContextualAction *> *)easeTableView:(UITableView *)tableView
      trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath
                                    actions:(NSArray<UIContextualAction *> *)actions;
```

##### 会话列表 cell 侧滑状态回调

```objective-c
- (void)easeTableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)easeTableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
```

#### 直播聊天室

