/**
 *  \
 *  @header AgoraChatMessage.h
 *  @abstract Chat message
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"
#import "AgoraChatMessageReaction.h"
#import "EMStreamChunk.h"
/**
 *  \
 *  Chat types.
 */
typedef NS_ENUM(NSInteger, AgoraChatType) {
    AgoraChatTypeChat   = 0,   /** \ One-to-one chat. */
    AgoraChatTypeGroupChat,    /** \ Group chat. */
    AgoraChatTypeChatRoom,     /** \ Chat room. */
};

/**
 *  \
 *  The message delivery states.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessageStatus) {
    AgoraChatMessageStatusPending  = 0,    /** \ The message delivery is pending.*/
    AgoraChatMessageStatusDelivering,      /** \ The message is being delivered.*/
    AgoraChatMessageStatusSucceed,         /** \ The message is successfully delivered.*/
    AgoraChatMessageStatusFailed,          /** \ The message fails to be delivered.*/
};

/**
 *  \
 *  The message directions.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessageDirection) {
    AgoraChatMessageDirectionSend = 0,    /** \ This message is sent from the local client.*/
    AgoraChatMessageDirectionReceive,     /** \ The message is received by the local client.*/
};

/**
 *  \
 *  The chat room message priorities.
 */
typedef NS_ENUM(NSInteger, AgoraChatRoomMessagePriority)  {
    /** \ High. */
    AgoraChatRoomMessagePriorityHigh = 0,
    /** \ Normal. */
    AgoraChatRoomMessagePriorityNormal,
    /** \ Low. */
    AgoraChatRoomMessagePriorityLow,
};

/**
 *  \
 * The message pinning information.
 */
@interface AgoraChatMessagePinInfo: NSObject
/** \ The user ID of the operator that pins the message. */
@property (strong,nonatomic) NSString* _Nonnull operatorId;
/** \ When the message is pinned. The unit is millisecond. */
@property (nonatomic) NSInteger pinTime;

@end

/**
 *  \
 * The message pinning and unpinning operations.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessagePinOperation) {
    /** \ Pin the message. */
    AgoraChatMessagePin = 0,
    
    /** \ Unpin the message. */
    AgoraChatMessageUnpin
};

/**
 *  \
 * The user attribute information of the message sender.
 */
@interface AgoraChatMessageSenderInfo: NSObject
/**
 * \ The userId of the message sender.
 * */
@property (strong,nonatomic) NSString* _Nullable userId;
/**
 * \ The nickname of the message sender.
 * */
@property (strong,nonatomic) NSString* _Nullable nickname;
/**
 * \ The avatar URL of the message sender.
 */
@property (strong,nonatomic) NSString* _Nullable avatarUrl;
/**
 * \ The contact remark information of the message sender.
 */
@property (strong,nonatomic) NSString* _Nullable remark;
/**
 * \ The group name card of the message sender. This property is valid for group messages only.
 */
@property (strong,nonatomic) NSString* _Nullable groupNameCard;

@end

@class AgoraChatThread;
/**
 *  \
 *  The chat message class.
 */
@interface AgoraChatMessage : NSObject

-(instancetype _Nonnull ) init __attribute__((unavailable("call initWithConversationID instead")));

/**
 *  \
 *  The message ID, which is the unique identifier of the message.
 */
@property (nonatomic, copy) NSString * _Nonnull messageId;

/**
 *  \
 *  The conversation ID, which is the unique identifier of the conversation.
 */
@property (nonatomic, copy) NSString * _Nonnull conversationId;

/**
 *  \
 *  The message delivery direction.
 */
@property (nonatomic) AgoraChatMessageDirection direction;

/**
 *  \
 *  The user sending the message.
 */
@property (nonatomic, copy) NSString * _Nonnull from;

/**
 *  \
 *  The user receiving the message.
 */
@property (nonatomic, copy) NSString * _Nonnull to;

/**
 *  \
 *  The Unix timestamp for the chat server receiving the message.
 *
 *  The unit is second.
 */
@property (nonatomic) long long timestamp;

/**
 *  \
 *  The Unix timestamp for the local client sending or receiving the message.
 *
 * The unit is millisecond.
 */
@property (nonatomic) long long localTime;

/**
 *  \
 *  The chat type.
 */
@property (nonatomic) AgoraChatType chatType;

/**
 *  \
 *  The message delivery status. See {@link AgoraChatMessageStatus}.
 */
@property (nonatomic) AgoraChatMessageStatus status;

/*!
 *  \
 *
 *  Whether the message is an online message:
 *  - `YES`: online message.
 *  - `NO`: offline message.
 *
 * This message status is not stored in the local database.
 *
 * Messages read from the database or pulled from the server are regarded as online.
 *
 *
 */
@property (nonatomic, readonly) BOOL onlineState;

/**
 *  \
 *  Whether the message read receipt is sent (from the message recipient) or received (by the message sender).
 *
 *  - `YES`: Yes;
 *  - `NO`: No.
 */
@property (nonatomic,readonly) BOOL isPeerRead;

/**
 *  \
 *  Whether this message is sent within a thread:
 *
 *  - `YES`: Yes;
 *  - `NO`: No.
 */
@property (nonatomic) BOOL isChatThreadMessage;

/**
 *  \
 *  Whether the message requires a read receipt. Set before sending.
 *
 *  Messages with this set to NO cannot have read receipts sent for them.
 *  Applies to both one-to-one and group messages.
 *
 *  - `YES`: Yes;
 *  - (Default) `NO`: No.
 */
@property (nonatomic) BOOL isNeedReadReceipt;

/**
 *  \
 *  The number of read receipts received for group messages.
 */
@property (nonatomic, readonly) int groupReadReceiptCount;

/**
 *  \
 *  Whether the delivery receipt is sent or received:
 *
 *  - `YES`: Yes;
 *  - `NO`: No.

 *  For the message sender, this attribute indicates whether the delivery receipt is received.
 *
 *  For the message recipient, this attribute indicates whether the delivery receipt is sent.
 *
 *  If you set `enableDeliveryAck` in `AgoraChatOptions` as `YES`, the SDK automatically sends the delivery receipt after receiving a message.
 */
@property (nonatomic) BOOL isDeliverAcked;

/**
 *  \
 *  Whether the message is read.
 *
 *  - `YES`: Yes;
 *  - `NO`: No.
 */
@property (nonatomic,readonly) BOOL isRead;

/**
 *  \
 *  Whether the voice message is played.
 *
 *  - `YES`: Yes;
 *  - `NO`: No.
 */
@property (nonatomic) BOOL isListened;

/**
 *  \
 *  The first message body, i.e. the first element of bodies; both expose the same underlying data.
 *  For a single-body message it is the only body; for a composite message it returns the first body, and bodies provides the complete ordered list.
 */
@property (nonatomic, strong) AgoraChatMessageBody * _Nonnull body;

/**
 *  \
 *  The complete ordered body list; its first element is the body property. More than one body identifies a composite message.
 *  Do not add, remove, reorder, or replace bodies while sending. Each body retains its own type.
 */
@property (nonatomic, strong) NSArray<AgoraChatMessageBody *> * _Nonnull bodies;

/**
 *  \
 *  The message content type, computed from the body count on each access: AgoraChatMessageBodyTypeMultiBody for multiple bodies; the single body's type for one body; AgoraChatMessageBodyTypeText as a fallback when there is no body.
 */
@property (nonatomic, readonly) AgoraChatMessageBodyType contentType;

/**
 *  \
 *  Appends one body to the end of the ordered list. The resulting full list is validated as a whole with the same rules as setBodies:. On failure, no change is made and a log is printed. Call before sending.
 */
- (void)appendBody:(AgoraChatMessageBody * _Nonnull)body;

/**
 *  \
 *  The Reaction list.
 */
@property (nonatomic, readonly) NSArray <AgoraChatMessageReaction *>* _Nullable reactionList;

/**
 *  \
 *  The custom message extension.
 *
 *  This data is in the key-value format, where the key is the extension field name of the NSString type, and the value must be of the NSString or NSNumber (Bool, Int, unsigned int, long long, double) type.
 */
@property (nonatomic, copy) NSDictionary * _Nullable ext;
/**
 *  \
 *  Gets an overview of the thread in the message.
 *
 *  Currently, this attribute is valid only for group messages.
 */

@property (readonly) AgoraChatThread * _Nullable chatThread;
/**
 *  \
 *  Sets the priority of a chat room message.
 *
 *  Currently, this attribute is valid only for chat room messages.
 *
 *  The default value is `normal`, indicating the normal priority.
 */
@property (nonatomic) AgoraChatRoomMessagePriority  priority;

/**
 *  \
 *
 *  Whether it is a broadcast message.
 */
@property (nonatomic,readonly) BOOL broadcast;

/**
 * \
 *
 * Whether the message is delivered only when the recipient(s) is/are online:
 * - `YES`：The message is delivered only when the recipient(s) is/are online. If the recipient is offline, the message is not delivered.
 * - (Default) `NO`：The message is delivered to the recipients regardless of whether they are online or offline.
 */
@property (nonatomic) BOOL deliverOnlineOnly;

/**
  * \
  *
  * The environment identifier for callback routing.
  *
  * - If this property is `nil` or omitted, the server uses the default callback route.
  * - If an empty string `@""` is passed,  the server treats it as a blank identifier with no matching route.
  * - If a valid string is passed, the server matches the specific callback route by the identifier.
  */
@property (nonatomic, copy) NSString * _Nullable webhookEnv;

/**
  * \
  *
  * The recipient list of a targeted message.
  *
  * This property is used only for messages in groups and chat rooms. If you pass in `nil`, the messages are sent to all members in the group or chat room.
  */
@property (nonatomic,strong) NSArray<NSString*>* _Nullable receiverList;

/**
  * \
  *
  * Whether the message content has been replaced by server.This property is used only when AgoraChatOptions#useReplacedMessageContent is true.
  *
  */
@property (nonatomic,readonly) BOOL isContentReplaced;
/**
 *  \
 *  The progress of uploading or downloading the file of the attachment message.
 *  The unit is percentage (0~100).
 */
@property (nonatomic,readonly) CGFloat progress;

/**
 *  \
 *
 *  The message pinning information.
 *
 *  For a message that is not pinned, nil is returned.
 */
@property (nonatomic,readonly)  AgoraChatMessagePinInfo* _Nullable  pinnedInfo;

/**
 * \ Stream chunk information of the message.
 */
@property (nonatomic,readonly) EMStreamChunk * _Nullable streamChunk;

/**
 * \ The user attribute information of the message sender.
 */
@property (nonatomic, readonly) AgoraChatMessageSenderInfo* _Nullable senderInfo;
/**
 *  \
 *  Initializes a message instance.
 *
 *  @param aConversationId   The conversation ID.
 *  @param aFrom           The user that sends the message.
 *  @param aTo         The user that receives the message.
 *  @param aBody             The message body.
 *  @param aExt              The message extention.
 *
 *  @result    The message instance.
 */


- (instancetype _Nonnull)initWithConversationID:(NSString *_Nonnull)aConversationId
                                  from:(NSString *_Nonnull)aFrom
                                    to:(NSString *_Nonnull)aTo
                                  body:(AgoraChatMessageBody *_Nonnull)aBody
                                   ext:(NSDictionary *_Nullable)aExt;

/**
 *  \
 *  Initializes a message instance.
 *
 *  @param aConversationId   The conversation ID.
 *  @param aBody             The message body.
 *  @param aExt              The message extention.
 *
 *  @result    The message instance.
 */


- (instancetype _Nonnull)initWithConversationID:(NSString *_Nonnull)aConversationId
                                  body:(AgoraChatMessageBody *_Nonnull)aBody
                                   ext:(NSDictionary *_Nullable)aExt;

/**
 *  \
 *  Initializes an ordered message using the current user as the sender.
 *  @param aConversationId The conversation ID, also used as the recipient.
 *  @param aBodies The complete ordered body list.
 *  @param aExt The message extensions.
 *  @result The message, or nil for invalid arguments.
 */
- (instancetype _Nullable)initWithConversationID:(NSString *_Nonnull)aConversationId
                                         bodies:(NSArray<AgoraChatMessageBody *> *_Nonnull)aBodies
                                            ext:(NSDictionary *_Nullable)aExt;

@end
