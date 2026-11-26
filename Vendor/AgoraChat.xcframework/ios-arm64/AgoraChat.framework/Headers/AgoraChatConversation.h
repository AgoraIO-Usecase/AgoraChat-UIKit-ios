/**
 *  \
 *  @header AgoraChatConversation.h
 *  @abstract Chat conversation
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"
#import "AgoraChatCursorResult.h"
#import "AgoraChatSilentModeParam.h"

/**
 *  \
 *  The conversation types.
 */
typedef NS_ENUM(NSInteger, AgoraChatConversationType) {
    AgoraChatConversationTypeChat = 0,    /** \ One-to-one chat. */
    AgoraChatConversationTypeGroupChat,    /** \ Group chat.*/
    AgoraChatConversationTypeChatRoom,      /** \ Chat room.*/
};

/**
 *  \
 *  The conversation mark types.
 *
 * The mapping between each type of conversation mark and their actual meanings is maintained by the developer.
 */
typedef NS_ENUM(NSInteger, AgoraChatMarkType) {
    AgoraChatMarkType0 = 0,
    AgoraChatMarkType1 = 1,
    AgoraChatMarkType2 = 2,
    AgoraChatMarkType3 = 3,
    AgoraChatMarkType4 = 4,
    AgoraChatMarkType5 = 5,
    AgoraChatMarkType6 = 6,
    AgoraChatMarkType7 = 7,
    AgoraChatMarkType8 = 8,
    AgoraChatMarkType9 = 9,
    AgoraChatMarkType10 = 10,
    AgoraChatMarkType11 = 11,
    AgoraChatMarkType12 = 12,
    AgoraChatMarkType13 = 13,
    AgoraChatMarkType14 = 14,
    AgoraChatMarkType15 = 15,
    AgoraChatMarkType16 = 16,
    AgoraChatMarkType17 = 17,
    AgoraChatMarkType18 = 18,
    AgoraChatMarkType19 = 19,
};

/**
 *  \
 *  The message search directions.
 *
 * The message research is based on the Unix timestamp included in messages. Each message contains two Unix timestamps:
 * - The Unix timestamp when the message is created;
 * - The Unix timestamp when the message is received by the server.
 *
 * Which Unix timestamp is used for message search depends on the setting of {@link AgoraChatOptions#sortMessageByServerTime}.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessageSearchDirection) {
    AgoraChatMessageSearchDirectionUp  = 0,    /** \ Messages are retrieved in the descending order of the timestamp included in them.*/
    AgoraChatMessageSearchDirectionDown        /** \ The Messages are retrieved in the ascending order of the timestamp included in them.*/
};

/**
 *  \
 *  The message search scopes.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessageSearchScope) {
    AgoraChatMessageSearchScopeContent  = 0,   /** \ Search by message content.*/
    AgoraChatMessageSearchScopeExt,           /** \ Search by message extension.*/
    AgoraChatMessageSearchScopeAll           /** \ Search by message content and extension.*/
};

@class AgoraChatMessage;
@class AgoraChatError;

/**
 *  \
 *  The chat conversation class.
 */
@interface AgoraChatConversation : NSObject
-(instancetype _Nonnull ) init NS_UNAVAILABLE;
/**
 *  \
 *  The conversation ID.
*   - One-to-one chat: The conversation ID is the user ID of the peer user.
*   - Group chat: The conversation ID is the group ID.
*   - Chat room: The conversation ID is the chat room ID.
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/**
 *  \
 *  The conversation type.
 */
@property (nonatomic, assign, readonly) AgoraChatConversationType type;

/**
 *  \
 *  The number of unread messages in the conversation.
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/**
 *  \
 *  The message count in the conversation.
 */
@property (nonatomic, assign, readonly) int messagesCount;

/**
 *  \
 *  The conversation extension attribute.
 *
 *  This attribute is not available for thread conversations.
 */
@property (nonatomic, copy)   NSDictionary *ext;

/*!
 *  \
 *  Whether the conversation is a thread conversation:
 * - `YES`：Yes
 * - `NO`：No
 */
@property (nonatomic, assign) BOOL isChatThread;

/*!
 *  \
 *  Whether the conversation is pinned:
 * - `YES`：Yes
 * - `NO`：No
 */
@property (readonly) BOOL isPinned;

/*!
 *  \
 *  The UNIX timestamp when the conversation is pinned. The unit is millisecond. This value is `0` when the conversation is not pinned.
 */
@property (readonly) int64_t pinnedTime;

/*!
 *  \
 *  The latest message in the conversation.
 */
@property (nonatomic, strong, readonly) AgoraChatMessage *latestMessage;

/**
 *  \
 *  The conversation mark.
 */
@property (nonatomic, readonly) NSArray<NSNumber*>* marks;

/**
 *  \
 *  The conversation no disturb type.``AgoraChatPushRemindType``
 */
@property (nonatomic, readonly) AgoraChatPushRemindType disturbType;

/**
 *  \
 *  Gets the last received message.
 *
 *  @result The message instance.
 */
- (AgoraChatMessage * _Nullable)lastReceivedMessage;

/**
 *  \
 *  The conversation name. In one-to-one chat, the conversation name is the nickname
 *  of the peer user. In group chat, the conversation name is the group name.
 */
- (NSString* _Nullable)conversationName;

/**
 *  \
 *  The conversation avatar. In one-to-one chat, the conversation avatar is the avatar of the peer user. In group chat, the conversation avatar is the avatar of the group.
 */
- (NSString* _Nullable)conversationAvatar;

/**
 *  \
 *  Inserts a message to a conversation in the local database.
 *
 *  To insert the message correctly, ensure that the conversation ID of the message is the same as that of the conversation.
 *
 *  The message is inserted based on timestamp and the SDK will automatically update attributes of the conversation, including `latestMessage`.
 *
 *
 *  @param aMessage The message instance.
 *  @param pError   The error information if the method fails: Error.
 */
- (void)insertMessage:(AgoraChatMessage *_Nonnull)aMessage
                error:(AgoraChatError ** _Nullable)pError;

/**
 *  \
 *  Inserts a message to the end of a conversation in local database.
 *
 * To insert the message correctly, ensure that the conversation ID of the message is the same as that of the conversation.
 *
 * After a message is inserted, the SDK will automatically update attributes of the conversation, including `latestMessage`.
 *
 *  @param aMessage The message instance.
 *  @param pError   The error information if the method fails: Error.
 *
 */
- (void)appendMessage:(AgoraChatMessage *_Nonnull)aMessage
                error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Deletes a message from the local database.
 *
 *  @param aMessageId   The ID of the message to be deleted.
 *  @param pError       The error information if the method fails: Error.
 *
 */
- (void)deleteMessageWithId:(NSString *_Nonnull)aMessageId
                      error:(AgoraChatError ** _Nullable)pError;

/**
 *  \
 *  Deletes all the messages in the conversation from the memory and local database.
 *
 *  @param pError       The error information if the method fails: Error.
 */
- (void)deleteAllMessages:(AgoraChatError ** _Nullable)pError;


/**
 *  \
 *  Removes messages from the conversation by message id list.
 *
 * This method deletes messages from both local storage and server.
 *
 *  @param messageIds   The list of IDs of messages to be removed form the current conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerMessageIds:(NSArray <__kindof NSString*>*_Nonnull)messageIds completion:(void (^ _Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;
/**
 *  \
 *  Removes messages from the conversation timestamp.
 *
 * This method deletes messages from both local storage and server.
 *
 *  @param beforeTimeStamp   The message timestamp in millisecond. Messages with the timestamp smaller than the specified one will be removed from the current conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithTimeStamp:(NSTimeInterval)beforeTimeStamp completion:(void (^ _Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Updates a message in the local database.
 *
 *  After you update a message, the message ID remains unchanged and the SDK automatically updates attributes of the conversation, like `latestMessage`.
 *
 *  @param aMessage The message to be updated.
 *  @param pError   The error information if the method fails: Error.
 *
 */
- (void)updateMessageChange:(AgoraChatMessage *_Nonnull)aMessage
                      error:(AgoraChatError ** _Nullable)pError;
/**
 * \
 *  Get the pinned messages in the conversation
 */
- (NSArray<AgoraChatMessage*>* _Nullable)pinnedMessages;


#pragma mark - Load Messages Methods

/**
 *  \
 *  Gets a message with the specified message ID from the local database.
 *
 *  @param aMessageId       The message ID.
 *  @param pError           The error information if the method fails: Error.
 *
 */
- (AgoraChatMessage * _Nullable)loadMessageWithId:(NSString * _Nonnull)aMessageId
                           error:(AgoraChatError ** _Nullable)pError;

/**
 *  \
 *  Loads the messages from the local database, starting from a specific message ID.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMessageId       The starting message ID for query. After this parameter is set, the SDK retrieves messages, from the specified one, according to the message search direction.
     *                      If this parameter is set as `nil`, the SDK retrieves messages according to the search direction while ignoring this parameter.
 *                          - If `aDirection` is set as `UP`, the SDK retrieves messages, starting from the latest one, in the descending order of the timestamp included in them.
 *                          - If `aDirection` is set as `DOWN`, the SDK retrieves messages, starting from the oldest one, in the ascending order of the timestamp included in them.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *
 *  @result AgoraChatMessage  The message instance.
 *
 */
- (NSArray<AgoraChatMessage *> * _Nullable)loadMessagesStartFromId:(NSString * _Nullable)aMessageId
                          count:(int)aCount
                searchDirection:(AgoraChatMessageSearchDirection)aDirection;

/**
 *  \
 *  Loads messages starting from the specified message ID from local database.
 *
 *  Returning messages are sorted by receiving timestamp based on AgoraChatMessageSearchDirection. If the aMessageId is nil, will return starting from the latest message.
 *
 *  @param aMessageId       The starting message ID for query. After this parameter is set, the SDK retrieves messages, from the specified one, according to the message search direction.
     *                      If this parameter is set as `nil`, the SDK retrieves messages according to the search direction while ignoring this parameter.
 *                          - If `aDirection` is set as `UP`, the SDK retrieves messages, starting from the latest one, in the descending order of the timestamp included in them.
 *                          - If `aDirection` is set as `DOWN`, the SDK retrieves messages, starting from the oldest one, in the ascending order of the timestamp included in them.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesStartFromId:(NSString * _Nullable)aMessageId
                          count:(int)aCount
                searchDirection:(AgoraChatMessageSearchDirection)aDirection
                     completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets messages of certain types that a specified user sends in the conversation.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aType            The message type to load. Types include txt (text message), img (image message), loc (location message), audio (audio message), video (video message), file (file message), and cmd (command message).
 *  @param aTimestamp       The starting Unix timestamp in the message for query. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aUsername        The message sender. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *
 *  @result AgoraChatMessage  The message instance.
 *
 */
- (NSArray<AgoraChatMessage *> * _Nullable)loadMessagesWithType:(AgoraChatMessageBodyType)aType
                                                   timestamp:(long long)aTimestamp
                                                       count:(int)aCount
                                                    fromUser:(NSString* _Nullable)aUsername
                                             searchDirection:(AgoraChatMessageSearchDirection)aDirection;

/**
 *  \
 *  Gets messages of certain types that a specified user sends in the conversation.
 *
 *  @param aType            The message type to load. Types include txt (text message), img (image message), loc (location message), audio (audio message), video (video message), file (file message), and cmd (command message).
 *  @param aTimestamp       The starting Unix timestamp in the message for query. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aUsername        The message sender. Setting it as nil means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesWithType:(AgoraChatMessageBodyType)aType
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString* _Nullable)aUsername
             searchDirection:(AgoraChatMessageSearchDirection)aDirection
                  completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;
/**
 *  \
 *  Gets messages of certain types that a specified user sends in the conversation.
 *
 *  @param aTypes           The message types to search. Types include txt (text message), img (image message), loc (location message), audio (audio message), video (video message), file (file message), and cmd (command message). ``AgoraChatMessageBodyType``
 *  @param aTimestamp       The starting Unix timestamp in the message for query. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aUsername        The message sender. Setting it as nil means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)searchMessagesWithTypes:(NSArray <NSNumber*> *_Nonnull)aTypes
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString* _Nullable)aUsername
             searchDirection:(AgoraChatMessageSearchDirection)aDirection
                  completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;
/**
 *  \
 *  Loads messages with keywords that the specified user sends in the conversation.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aKeywords         The keywords for query. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aTimestamp       The starting Unix timestamp for search. The unit is millisecond.
 *                          If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aSender          The message sender. Setting it as nil means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *
 *  @result AgoraChatMessage  The message list.
 *
 */
- (NSArray<AgoraChatMessage *> * _Nullable)loadMessagesWithKeyword:(NSString* _Nullable)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString* _Nullable)aSender
                searchDirection:(AgoraChatMessageSearchDirection)aDirection;

/**
 *  \
 *  Loads messages with specified keyword from local database. Returning messages are sorted by receiving timestamp based on AgoraChatMessageSearchDirection. If reference timestamp is negative, load from the latest messages; if message count is negative, will be handled as count=1
 *
 *  @param aKeywords         The keywords for query. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aTimestamp       The starting Unix timestamp for search. The unit is millisecond.
 *                          If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aSender          The message sender. Setting it as nil means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesWithKeyword:(NSString* _Nullable)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString* _Nullable)aSender
                searchDirection:(AgoraChatMessageSearchDirection)aDirection
                     completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Loads messages with the specified keyword from a user in the local database.
 *
 *  The SDK returns messages in the chronological order.
 *
 *  @param aKeyword         The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The Unix timestamp threshold for message search. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *                          If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load. If you set this parameter to 0 or less, the SDK gets one message from the local database.
 *  @param aSender          The sender of the message. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aScope             The message search scope. See {@link AgoraChatMessageSearchScope}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesWithKeyword:(NSString* _Nullable)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString* _Nullable)aSender
                searchDirection:(AgoraChatMessageSearchDirection)aDirection
                          scope:(AgoraChatMessageSearchScope)aScope
                     completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock __deprecated_msg("Use -loadMessagesWithKeyword:timestamp:count:fromUsers:searchDirection:scope:completion: instead");



/**
 *  \
 *  Loads messages with the specified keyword from a user in the local database.
 *
 *  The SDK returns messages in the chronological order.
 *
 *  @param aKeywords         The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The Unix timestamp threshold for message search. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *                          If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load. If you set this parameter to 0 or less, the SDK gets one message from the local database.
 *  @param senders         The senders of the messages. senders size must be less than 10.  If you set this parameter as nil, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aScope             The message search scope. See {@link AgoraChatMessageSearchScope}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesWithKeyword:(NSString* _Nullable)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUsers:(NSArray<NSString*>* _Nullable)senders
                searchDirection:(AgoraChatMessageSearchDirection)aDirection
                          scope:(AgoraChatMessageSearchScope)aScope
                     completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Loads custom messages with keywords that the specified user sends in the conversation.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aKeywords         The keywords for query. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aTimestamp       The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
     *                      If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aSender          The message sender. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @result AgoraChatMessage   The message list.
 *
 */
- (NSArray<AgoraChatMessage *> * _Nullable)loadCustomMsgWithKeyword:(NSString*)aKeywords
                       timestamp:(long long)aTimestamp
                           count:(int)aCount
                        fromUser:(NSString* _Nullable)aSender
                 searchDirection:(AgoraChatMessageSearchDirection)aDirection;

/**
 *  \
 *  Loads custom messages with keywords that the specified user sends in the conversation.
 *
 *  @param aKeywords         The keyword for searching the messages. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aTimestamp       The starting Unix timestamp in the message for query. The unit is millisecond. After this parameter is set, the SDK retrieves messages, starting from the specified one, according to the message search direction.
     *                      If this parameter is set as a negative value, the SDK retrieves from the current time.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aSender          The message sender. Setting it as NIL means that the SDK ignores this parameter.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadCustomMsgWithKeyword:(NSString* _Nullable)aKeywords
                       timestamp:(long long)aTimestamp
                           count:(int)aCount
                        fromUser:(NSString* _Nullable)aSender
                 searchDirection:(AgoraChatMessageSearchDirection)aDirection
                      completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Loads a certain quantity of messages sent or received in a certain period from the local database.
 *
 *  Messages are retrieved in the ascending order of the timestamp included in them.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aStartTimestamp  The starting Unix timestamp in the message for query. The unit is millisecond.
 *  @param aEndTimestamp    The ending Unix timestamp in the message for query. The unit is millisecond.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *
 *  @result AgoraChatMessage       The message list.
 *
 */
- (NSArray<AgoraChatMessage *> * _Nullable)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount;

/**
 *  \
 *  Loads a certain quantity of messages sent or received in a certain period from the local database.
 *
 *  @param aStartTimestamp  The starting Unix timestamp in the message for query. The unit is millisecond.
 *  @param aEndTimestamp    The ending Unix timestamp in the message for query. The unit is millisecond.
 *  @param aCount           The number of messages to load each time. If you set this parameter to a value less than 1, the SDK retrieves one message.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount
              completion:(void (^ _Nullable)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Deletes messages sent or received in a certain period from the local database.
 *
 *  @param aStartTimestamp  The starting UNIX timestamp for message deletion. The unit is millisecond.
 *  @param aEndTimestamp    The end UNIX timestamp for message deletion. The unit is millisecond.
 *  @return AgoraChatError         Whether the message deletion succeeds:
 *                          - If the operation succeeds, the SDK returns `nil`.
 *                          - If the operation fails, the SDK returns the failure reason such as the parameter error or database operation failure.
 *
 */
- (AgoraChatError* _Nullable)removeMessagesStart:(NSInteger)aStartTimestamp
                                       to:(NSInteger)aEndTimestamp;

/**
 * \
 * Gets the number of messages in a conversation within a certain period of time.
 * @param aStartTimestamp The starting timestamp for query. The unit is millisecond.
 * @param aEndTimestamp The ending timestamp for query. The unit is millisecond.
 * @return The number of messages in a conversation within a certain period of time.
 *
 */
- (NSInteger)getMessageCountStart:(NSInteger)aStartTimestamp
                               to:(NSInteger)aEndTimestamp;
@end
