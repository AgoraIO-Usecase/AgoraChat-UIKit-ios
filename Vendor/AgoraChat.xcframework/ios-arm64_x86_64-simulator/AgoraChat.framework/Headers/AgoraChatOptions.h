/**
 *  \
 *  @header AgoraChatOptions.h
 *  @abstract SDK options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatCommonDefs.h"

/**
 *  \
 *  The level of logs for output.
 */
typedef NS_ENUM(NSInteger, AgoraChatLogLevel)
{
    AgoraChatLogLevelDebug = 0, /** \ All logs. */
    AgoraChatLogLevelWarning,   /** \ Warnings and errors. */
    AgoraChatLogLevelError      /** \ Errors only. */
} ;

typedef NS_ENUM(NSInteger, AreaCode)
{
    AreaCodeCN = 1 << 0,
    AreaCodeNA = 1 << 1,
    AreaCodeEU = 1 << 2,
    AreaCodeAS = 1 << 3,
    AreaCodeJP = 1 << 4,
    AreaCodeIN = 1 << 5,
    AreaCodeGLOB = -1
};

/**
 * \
 * SDK platform framework enumeration.
 */
typedef NS_ENUM(NSUInteger, EMSDKPlatform) {
    /** \ Native platform.*/
    EMSDKPlatformNative = 0,
    /** \ Flutter platform.*/
    EMSDKPlatformFlutter = 1,
    /** \ React Native platform.*/
    EMSDKPlatformReactNative = 2,
    /** \ Unity platform.*/
    EMSDKPlatformUnity = 3,
};

/**
 * \
 * Data synchronization type enumeration.
 */
typedef NS_OPTIONS(NSInteger, EMDataSyncType) {
    /* \ No data synchronization. */
    EMDataSyncTypeNone = 0,
    /* \ Synchronize conversation data. */
    EMDataSyncTypeConversations = 1 << 0,
    /* \ Synchronize contact data. */
    EMDataSyncTypeContacts = 1 << 1,
    /* \ Synchronize joined group data. */
    EMDataSyncTypeJoinedGroups = 1 << 2,
};

/**
 *  \
 *  The SDK options.
 */
@interface AgoraChatOptions : NSObject

/**
 *  \
 *  The app key, which is the unique identifier of the project.
 */
@property(nonatomic, copy, readonly) NSString *appkey;

/**
 *  \
 *  The appId, which is the unique identifier of the project.
 */
@property(nonatomic, copy, readonly) NSString *appId;

/**
 *  \
 *  Whether to print logs on the Console.
 *  - `YES`: Yes.
 *  - (Default) `NO`: No.
 */
@property(nonatomic, assign) BOOL enableConsoleLog;

/**
 *  \
 *  The log level.
 *  - `AgoraChatLogLevelDebug`: All logs;
 *  - `AgoraChatLogLevelWarning`: Warnings and errors.
 *  - `AgoraChatLogLevelError`: Errors.
 */
@property(nonatomic, assign) AgoraChatLogLevel logLevel;

/**
 *  \
 *  Whether to only use the HTTPS protocol.
 *  - `YES`: Yes.
 *  - (Default) `NO`: No.
 */
@property(nonatomic, assign) BOOL usingHttpsOnly;

/**
 *  \
 *  Whether to delete all the group messages when leaving the group.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL deleteMessagesOnLeaveGroup;

/**
 *  \
 *  Whether to delete all the chat room messages when leaving the chat room.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL deleteMessagesOnLeaveChatroom;

/**
 *  \
 *  Whether to allow the chat room owner to leave the room.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL canChatroomOwnerLeave;

/**
 *  \
 *  Whether to automatically accept group invitations.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL autoAcceptGroupInvitation;

/**
 *  \
 *  Whether to automatically accept friend requests.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL autoAcceptFriendInvitation;

/**
 *  \
 *  Whether to automatically download thumbnails of images and videos and voice messages.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL autoDownloadThumbnail;

/**
 *  \
 *  Whether to send the message delivery receipt.
 *  - `YES`: Upon the reception of a one-to-one message, the SDK automatically sends a delivery receipt.
 *  - `NO`: No.
 *
 */
@property(nonatomic, assign) BOOL enableDeliveryAck;

/**
 *  \
 *  Whether to sort messages by the server's reception time when loading messages from the database.
 *  - (Default) `YES`: Yes. Messages are sorted by the time when the server receives them.
 *  - `NO`: No.
 *
 */
@property(nonatomic, assign) BOOL sortMessageByServerTime;

/**
 *  \
 *  Whether to automatically upload or download the attachment in the message.
 *  - (Default) `YES`: Yes.
 *  - `NO`: No.
 */
@property(nonatomic, assign) BOOL isAutoTransferMessageAttachments;

/**
 *  \
 *  The certificate name of Apple Push Notification Service (APNs).
 *
 *  This attribute is specific to APNs.
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic, copy) NSString *apnsCertName;

/**
 *  \
 *  The certificate name of Apple PushKit Service.
 *
 *  This attribute is specific to Apple PushKit Service.
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic, copy) NSString *pushKitCertName;

/**
 *  \
 *  The area code.

 *  This attribute is used to restrict the scope of accessible edge nodes. The default value is `AreaCodeGLOB`.
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`. The attribute setting cannot be changed during the app runtime.
 */
@property(nonatomic) AreaCode area;

/**
 *  \
 *  Whether to enable message statistics.
 *  - `YES`: Yes.
 *  - (Default) `NO`: No.
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`. The attribute setting cannot be changed during the app runtime.
 */
@property(nonatomic) BOOL enableStatistics;

/**
 *  \
 *  Whether to include empty conversations when the SDK loads conversations
 *  - `YES`: Empty conversations are included.
 * - (Default) `NO`: Empty conversations are excluded.
 *
 *  This attribute can be set only when you call the `initializeSDKWithOptions` method. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic) BOOL loadEmptyConversations;

/**
 *  \
 *  The custom system type.
 *
 *  This attribute can be set only when you call the `initializeSDKWithOptions` method. The attribute setting cannot be changed during app runtime.
 */
@property(nonatomic) NSInteger customOSType;

/**
 *  \
 *  The custom device name.
 *
 *  This attribute can be set only when you call the `initializeSDKWithOptions` method. The attribute setting cannot be changed during the app runtime.
 */
@property(strong) NSString* customDeviceName;

/**
 *  \
 *
 *  Whether the server returns the sender the text message with the content replaced during text moderation:
 *
 *  - YES：Return the adjusted message to the sender.
 *  - (Default) NO：Return the original message to the sender.
 *
 *  This attribute can be set only with the `initializeSDKWithOptions` method. The attribute setting cannot be changed during the app runtime.
 */
@property(nonatomic) BOOL useReplacedMessageContents;

/**
 *  \
 *
 *  Whether the sent message is included in `ChatManagerDelegate#messagesDidReceive`.
 *  - YES：Yes. Besides the received message, the sent message is also included in `ChatManagerDelegate#messagesDidReceive`.
 *  - (Default) NO：No. Only the received message is included in `ChatManagerDelegate#messagesDidReceive`.
 *
 */
@property(nonatomic) BOOL includeSendMessageInMessageListener;

/**
 *  \
 *
 *  Whether to enable the user info service of Chat. If enabled, the SDK automatically synchronizes user info from the server during login. When sending a message, the SDK includes the relevant user information, such as avatar, nickname, and group card. Users need to actively set their user attributes and group nicknames.
 *  - YES: Enable.
 *  - (Default) NO: Disable.
 *
 */
@property(nonatomic) BOOL enableUserInfo;

/**
 *  \
 *
 *  Whether to set messages from the server side as read:
 *  - YES：Read. After the messages are imported, the number of unread messages specified with `AgoraChatConversation#unreadMessagesCount` remains unchanged.
 *  - (Default) NO：Unread. After the messages are imported, the value of `AgoraChatConversation#unreadMessagesCount` is increased.
 */
@property(nonatomic) BOOL regardImportMessagesAsRead;

/**
 *  \
 *
 *  Whether to automatically load the conversation list:
 *  - YES：Automatically load.
 *  - (Default) YES：Automatically load.
 */
@property(nonatomic) BOOL autoLoadConversations;

/**
 *  \
 *
 *  Whether to include chatroom conversations in the local conversation list.
 *  - YES：Yes. Includes chatroom conversations.
 *  - (Default) NO：No. Excludes chatroom conversations.
 * 
 * This configuration neither controls the creation or storage of chatroom conversations, nor does it affect normal chatroom message delivery.
 * 
 */
@property(nonatomic) BOOL enableChatroomConversation;

/**
 *  \
 *  The extended information carried during login can be a JSON string. The current string length is limited to 1024 characters.
 */
@property (nonatomic) NSString * loginExtensionInfo;

/**
 *  \
 *  Whether the SDK work path is copiable.
 *  - YES：Copiable.
 *  - （Default）NO：Uncopiable.
 */
@property (nonatomic) BOOL workPathCopiable;

/**
 *  \
 *  The UIKit version.
 *  - (Default) Not set.
 */
@property (nonatomic, copy) NSString* uiKitVersion;

/**
 *  \
 *  The SDK platform.
 *  - (Default) `EMSDKPlatformNative`: Native platform;
 */
@property (nonatomic) EMSDKPlatform platform;

/**
 *  \
 *  doh type..
 *  - (default)  china (1),  global (2);
 *  - 0.disable 1.china 2.global
 */
@property (nonatomic) NSInteger dohVendor;

/**
 * \
 * The data types to synchronize automatically after login. The default value is `EMDataSyncTypeConversations`.
 */
@property (nonatomic, assign) EMDataSyncType dataSyncType;

@property (nonatomic) BOOL useAgoraChatDomain;

/**
 * \
 * The time threshold in seconds for notifying users when the connection is disconnected. The default value is `10`, which means that if frequent disconnections occur within 10 seconds or if the disconnection is caused by a reconnection that first disconnects and then reconnects, the user will not be notified of the disconnection.
 */
@property (nonatomic) NSInteger disconnectNotifyThreshold;

/**
 *  \
 *  The custom NTP server address list. Format: "host" or "host:port", default port is 123.
 *  Servers must be NTPv4-compliant (RFC 5905).
 *
 *  This attribute can be set only when you call `initializeSDKWithOptions`.
 *  The attribute setting cannot be changed during app runtime.
 */
@property (nonatomic, copy) NSArray<NSString *> *ntpServers;

/**
 *  \
 *  Gets an SDK options instance.
 *
 *  @param aAppkey  The App Key.
 *
 *  @result  The SDK options instance.
 */
+ (instancetype _Nonnull)optionsWithAppkey:(NSString * _Nonnull)aAppkey;

/**
 *  \
 *  Gets an SDK options instance.
 *
 *  @param appId  The App Id.
 *
 *  @result  The SDK options instance.
 */
+ (instancetype _Nonnull)optionsWithAppId:(NSString* _Nonnull)appId;
@end
