/**
 *  \
 *  @header IAgoraChatManager.h
 *  @abstract This protocol defines the operations of chat.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatCommonDefs.h"
#import "AgoraChatManagerDelegate.h"
#import "AgoraChatConversationDelegate.h"
#import "AgoraChatConversation.h"

#import "AgoraChatMessage.h"
#import "AgoraChatTextMessageBody.h"
#import "AgoraChatLocationMessageBody.h"
#import "AgoraChatCmdMessageBody.h"
#import "AgoraChatFileMessageBody.h"
#import "AgoraChatImageMessageBody.h"
#import "AgoraChatVoiceMessageBody.h"
#import "AgoraChatVideoMessageBody.h"
#import "AgoraChatCustomMessageBody.h"
#import "AgoraChatCombineMessageBody.h"
#import "AgoraChatCursorResult.h"
#import "AgoraChatPageResult.h"

#import "AgoraChatGroupReadReceipt.h"
#import "AgoraChatTranslateLanguage.h"
#import "AgoraChatVoiceParam.h"
#import "AgoraChatFetchServerMessagesOption.h"
#import "AgoraChatMessageSearchOption.h"
#import "AgoraChatSearchServerMessageResult.h"
#import "AgoraChatConversationFilter.h"

/**
 *  \
 *  The directions in which historical messages are retrieved from the server.
 */
typedef NS_ENUM(NSUInteger, AgoraChatMessageFetchHistoryDirection) {
    AgoraChatMessageFetchHistoryDirectionUp  = 0,    /** \ The SDK retrieves messages in the descending order of the timestamp included in them.*/
    AgoraChatMessageFetchHistoryDirectionDown        /** \ The SDK retrieves messages in the ascending order of the timestamp included in them.
 **/
};


@class AgoraChatError;
@class AgoraChatMessageReadReceipt;

/**
 *  \
 *  This protocol that defines the operations of chat.
 *
 *  Messages are loaded from the local database, not from the server.
 */
@protocol IAgoraChatManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \
 *  Adds a delegate.
 *
 *  @param aDelegate  The object that implements the protocol.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<AgoraChatManagerDelegate> _Nullable)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id<AgoraChatManagerDelegate> _Nonnull)aDelegate;

/**
 *  \
 *  Adds a conversation delegate.
 *
 *  @param aDelegate  The object that implements the conversation delegate protocol.
 *  @param aQueue     The queue that invokes delegate callbacks. To invoke delegate callbacks on the main thread, pass nil.
 */
- (void)addConversationDelegate:(id<AgoraChatConversationDelegate> _Nullable)aDelegate
                  delegateQueue:(dispatch_queue_t _Nullable)aQueue  NS_SWIFT_NAME(addConversation(delegate:queue:));

/**
 *  \
 *  Removes a conversation delegate.
 *
 *  @param aDelegate  The conversation delegate to be removed.
 */
- (void)removeConversationDelegate:(id<AgoraChatConversationDelegate> _Nonnull)aDelegate NS_SWIFT_NAME(removeConversation(delegate:));

#pragma mark - Conversation

/**
 *  \
 *  Gets all local conversations.
 *
 * The SDK loads the conversations from the memory first. If no conversation is found in the memory, the SDK loads from the local database.
 *
 *  @result The conversation list of the NSArray<AgoraChatConversation *> * type.
 */
- (NSArray<AgoraChatConversation *> * _Nullable)getAllConversations;

/**
 *  \
 *  Gets local conversations by filter.
 *
 *  The SDK loads conversations from the local database by the specified filter conditions.
 *
 *  Ensure that you call this method upon login success.
 *
 *  @param cleanMemoryCache Whether to clear cached conversations in memory.
 *  @param filter The filter. The return value `YES` indicates that the conversation is returned and `false` indicates that the conversation is not returned.
 *
 *  @result The conversation list of the NSArray<AgoraChatConversation *> * type.
 */
- (NSArray<AgoraChatConversation *> * _Nullable)filterConversationsFromDB:(BOOL)cleanMemoryCache filter:(BOOL(^_Nullable)(AgoraChatConversation * _Nonnull conversation))filter NS_SWIFT_NAME(filterConversationsFromDB(cleanMemoryCache:filter:));


/**
 *  \
 *   Clear all conversations in memory to release memory.
 */
- (void)cleanConversationsMemoryCache;

/**
 *  \
 *  Gets all local conversations.
 *
 *  The SDK loads the conversations from the memory first. If there is no conversation is in the memory, the SDK loads from the local database.
 *
 *  @param isSort Whether to sort the conversations.
 *          - YES: Yes. The SDK returns conversations in the descending order of the timestamp of the latest message in them, with the pinned ones at the top of the list and followed by the unpinned ones.
 *          - NO: No.
 *  @result The conversation list of the NSArray<AgoraChatConversation *> * type.
 */
- (NSArray<AgoraChatConversation *> * _Nullable)getAllConversations:(BOOL)isSort;

/**
 *  \
 *  Gets the total number of unread messages across all local conversations.
 *
 *  Chat room conversations are excluded.
 *  Conversations with Do Not Disturb enabled (`disturbType` is not `AgoraChatPushRemindTypeAll`) are also excluded.
 *
 *  @result The total unread message count.
 */
- (NSInteger)getUnreadMessageCount;

/**
 *  \
 *  Gets conversations from the local database with pagination.
 *
 *  Before calling this method, set AgoraChatOptions#autoLoadConversations to `NO`.
 *
 *  The SDK returns conversations ordered by: pinned state (descending) > server timestamp of the latest message (descending) > conversation ID (descending, case-insensitive).
 *
 *  @param cursor The position from which to start getting data. Pass in `nil` or `@""` for the first page, or the cursor returned in the previous page's result. An empty cursor in the result means the last page.
 *  @param pageSize The number of conversations that you expect to get on each page. The value range is [1,100].
 *  @param completionBlock The completion block. If the passed-in cursor is invalid, the error in the callback is AgoraChatErrorInvalidParam.
 */
- (void)getConversationsFromDBWithCursor:(nullable NSString *)cursor pageSize:(NSInteger)pageSize completion:(nonnull void (^)(AgoraChatCursorResult<AgoraChatConversation *> * _Nullable result, AgoraChatError * _Nullable error))completionBlock;

/**
 *  \
 *  Sets whether to pin a conversation.
 *
 *  @param conversationId  The conversation ID.
 *  @param isPinned Whether to pin a conversation:
     *                - `true`：Yes.
     *                  - `false`: No. The conversation is unpinned.
 *  @param completionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)pinConversation:(nonnull NSString *)conversationId isPinned:(BOOL)isPinned completionBlock:(nullable void(^)(AgoraChatError * _Nullable error))completionBlock;

/**
 *  \
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *
 *  @result The conversation object.
 */
- (AgoraChatConversation *_Nullable)getConversationWithConvId:(NSString * _Nullable)aConversationId;

/**
 *  \
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aType            The conversation type.
 *  @param aIfCreate        Whether to create the conversation if it does not exist:
 *                          - `YES`: Yes;
 *                          - `NO`: No.
 *
 *  @result The conversation object.
 */
- (AgoraChatConversation *_Nullable)getConversation:(NSString *_Nonnull)aConversationId
                               type:(AgoraChatConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/**
 *  \
 *  Gets a conversation from the local database.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aType            The conversation type.
 *  @param aIfCreate        Whether to create the conversation if it does not exist.
 *                          - `YES`: Yes;
 *                          - `NO`: No.
 *  @param isThread         Whether it is thread conversation. That is, whether the conversation is of the `threadChat` type.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @result The conversation object.
 */
- (AgoraChatConversation *_Nullable)getConversation:(NSString *_Nonnull)aConversationId
                               type:(AgoraChatConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate isThread:(BOOL)isThread;

/**
 *  \
 *  Deletes a conversation from the local database.
 *
 *  @param aConversationId      The conversation ID.
 *  @param aIsDeleteMessages    Whether to delete the messages in the conversation.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)deleteConversation:(NSString * _Nonnull)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^_Nullable)(NSString * _Nullable aConversationId, AgoraChatError *_Nullable aError))aCompletionBlock;

/*!
  *  \
  *  Deletes a conversation from the server.
  *
  *  @param aConversationId      The conversation ID.
  *  @param aConversationType    The conversation type.
  *  @param aIsDeleteMessages    Whether to delete the related messages with the conversation.
  *                          - `YES`: Yes;
  *                          - `NO`: No.
  *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
  *
  */
 - (void)deleteServerConversation:(NSString * _Nonnull)aConversationId
                 conversationType:(AgoraChatConversationType)aConversationType
           isDeleteServerMessages:(BOOL)aIsDeleteServerMessages
                       completion:(void (^_Nullable)(NSString * _Nullable aConversationId, AgoraChatError * _Nullable aError))aCompletionBlock;

/*!
 *  \
 *  Deletes multiple conversations.
 *
 *  @param aConversations       The conversation list.
 *  @param aIsDeleteMessages    Whether to delete the messages with the conversations.
 *  - `YES`: Yes;
 *  - `NO`: No.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)deleteConversations:(NSArray<AgoraChatConversation *> * _Nullable)aConversations
           isDeleteMessages:(BOOL)aIsDeleteMessages
                 completion:(void (^_Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

#pragma mark - Message

/**
 *  \
 *  Gets the specified message.
 *
 *  @param aMessageId    The message ID.
 *  @result AgoraChatMessage     The message content.
 */
- (AgoraChatMessage * _Nullable)getMessageWithMessageId:(NSString * _Nonnull)aMessageId;

/**
 *  \
 *  Gets the local path of message attachments in a conversation.
 *
 *  When a conversation is deleted, the message attachments in the conversation will also be deleted.
 *
 *  @param aConversationId  The conversation ID.
 *
 *  @result The attachment path.
 */
- (NSString * _Nullable)getMessageAttachmentPath:(NSString * _Nonnull)aConversationId;

/**
 *  \
 *  Imports multiple messages to the local database.
 *
 *  @param aMessages            The message list.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)importMessages:(NSArray<AgoraChatMessage *> * _Nonnull)aMessages
            completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Updates a message in the local database.
 *
 *  This method updates the message in both the memory and the local database at the same time.
 *
 *  The message ID cannot be updated.
 *
 *  @param aMessage             The message instance.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateMessage:(AgoraChatMessage *_Nonnull)aMessage
           completion:(void (^_Nullable)(AgoraChatMessage * _Nullable aMessage, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *   Modifies a message both in the local storage and server.
 *
 *  - Text and custom message: Both the message body `body` and extension information `ext` can be modified.
 *  - Image/voice/video/file/combined message: Only the message extension field `ext` can be modified.
 *  - Command message: This type of message cannot be modified.
 *
 *  Note that the message ID cannot be changed.
 *
 *  @param messageId       The ID of the message for modification.
 *  @param body            The modified message body. You can only modify the body of a text message and a custom message. The value `nil` indicates that the message body remains unchanged.
 *  @param ext             The modified message extension information. The new extension information will overwrite the previous. The value `nil` indicates that the message extension information remains unchanged.
 *  @param completionBlock The completion block, which contains the error message if the method fails.
 *
 */

- (void)modifyMessage:(NSString *_Nonnull)messageId
                 body:(AgoraChatMessageBody *_Nullable)body
                  ext:(NSDictionary* _Nullable)ext
           completion:(void (^_Nonnull)(AgoraChatError * _Nullable error,AgoraChatMessage *_Nullable message))completionBlock;

/**
 *  \
 *  Sends read receipts for messages in batch.
 *
 *  This method is used for both one-to-one and group chats. All messages must belong to the same conversation.
 *  The `isNeedReadReceipt` property of the messages must be YES.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessages        The message list. Maximum 50 messages.
 *  @param aCompletionBlock The completion block. `aResult` is a dictionary mapping message IDs to their individual errors (nil value means success for that message). `aError` is the overall error.
 */
- (void)sendMessageReadReceipts:(NSArray<AgoraChatMessage *> * _Nonnull)aMessages
                     completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Clears the unread message count of a conversation.
 *
 *  The local unread count is cleared to zero and synced to the current user's other devices.
 *  This method does not send a read receipt to the peer.
 *
 *  This is an asynchronous method.
 *
 *  @param aConversationId  The conversation ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)clearConversationUnreadMessageCount:(NSString * _Nonnull)aConversationId
                                 completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Clears the unread message count of all conversations.
 *
 *  The local unread count of all conversations is cleared to zero and synced to the current user's other devices.
 *
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)clearAllConversationUnreadMessageCount:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the read receipt details for a batch of messages from the server.
 *
 *  @param aMessages        The message list. Maximum 20 messages. Must belong to the same conversation.
 *  @param aCompletionBlock The completion block, which contains the receipts array or error.
 */
- (void)getGroupMessageReadReceipts:(NSArray<AgoraChatMessage *> * _Nonnull)aMessages
                    completion:(void (^_Nullable)(NSArray<AgoraChatMessageReadReceipt *> *_Nullable aReceipts, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Recalls a message.
 *
 *  For a one-to-one chat conversation, only the message sender can recall the message that is sent successfully. If the message expires, the recall fails.
 *
 * For a group/chat room conversation, except the message sender, the group/chat room owner and administrators can recall messages sent in the group/chat room. If the message expires, only the group/chat room owner and administrators can recall it.
 *
 *
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The message ID
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)recallMessageWithMessageId:(NSString *_Nonnull)aMessageId
                        completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Recalls a message.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessageId           The ID of the message to recall.
 *  @param ext        The information to be transparently transmitted during message recall. The information can be a string or a JSONString.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)recallMessageWithMessageId:(NSString *_Nonnull)aMessageId ext:(NSString * _Nullable)ext completion:(void (^_Nonnull)(AgoraChatError * _Nullable))aCompletionBlock;
/**
 *  \
 *  Sends a message.
 *
 *  This is an asynchronous method.
 *
 *  For a message containing multiple attachment bodies, the upload progress is reported at the message level instead of per attachment: the SDK aggregates the progress of all attachments, weighted by their original file sizes, into a single 0-100 progress reported through aProgressBlock, rather than one progress per attachment.
 *
 *  @param aMessage             The message instance.
 *  @param aProgressBlock       The callback block of attachment upload progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)sendMessage:(AgoraChatMessage *_Nonnull)aMessage
           progress:(void (^_Nullable)(int progress))aProgressBlock
         completion:(void (^_Nullable)(AgoraChatMessage *_Nullable message, AgoraChatError *_Nullable error))aCompletionBlock;

/**
 *  \
 *  Downloads the message thumbnail (the thumbnail of an image or the first frame of a video).
 *
 *  The SDK automatically downloads the thumbnail. If the auto-download fails, you can call this method to manually download the thumbnail.
 *
 *  Download behavior by message body type:
 *  - Image: downloads the image thumbnail;
 *  - Video: downloads the video thumbnail;
 *  - Voice: voice has no thumbnail, so the original voice file is downloaded instead (normalized);
 *  - Bodies of other types, such as file: silently skipped, not marked as failed, excluded from progress, and do not affect the result.
 *
 *  Note: if the message contains no applicable body (for example, a file-only message), the success callback is invoked but nothing is downloaded.
 *
 *  The size of the thumbnail (including the normalized original voice file) cannot be known in advance, so no progress is reported during download; only the success or failure result is returned through aCompletionBlock. The result is reported once per download request: if any applicable body fails, the remaining downloads are aborted.
 *
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageThumbnail:(AgoraChatMessage *_Nonnull)aMessage
                        progress:(void (^_Nullable)(int progress))aProgressBlock
                      completion:(void (^_Nullable)(AgoraChatMessage *_Nullable message, AgoraChatError *_Nullable error))aCompletionBlock;

/**
 *  \
 *  Downloads message attachments (original files).
 *
 *  The SDK automatically downloads voice messages. If the automatic download fails, you can call this method to download voice messages manually.
 *
 *  Download behavior by message body type:
 *  - Image: downloads the original image;
 *  - Video: downloads the original video file;
 *  - Voice: downloads the original voice file;
 *  - File: downloads the file;
 *  - Combine: downloads the combined file;
 *  - Bodies without attachments, such as text: skipped automatically, not treated as failures.
 *
 *  The result is reported once per download request: success when every attachment is downloaded; if any attachment fails, the remaining downloads are aborted and the failure is reported.
 *
 *  The download progress is reported at the message level: the SDK aggregates the progress of all attachments, weighted by their file sizes, into a single 0-100 progress reported through aProgressBlock, rather than one progress per attachment.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessage             The message object.
 *  @param aProgressBlock       The callback block of attachment download progress. The progress value range is [0,100].
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)downloadMessageAttachment:(AgoraChatMessage *_Nonnull)aMessage
                         progress:(void (^_Nullable)(int progress))aProgressBlock
                       completion:(void (^_Nullable)(AgoraChatMessage *_Nullable message, AgoraChatError *_Nullable error))aCompletionBlock;
/**
 * \
 * Downloads the large image of an image message.
 * 
 * If the `isOriginalImage` property is set to `false` in `AgoraChatImageMessageBody` when sending an image message, the recipient can call this method to download the large image. 
 * 
 * Download behavior by message body type:
 * - Image: downloads the large image;
 * - Voice: voice has no large image, so the original voice file is downloaded instead (normalized);
 * - Bodies of other types, such as video and file: silently skipped, not marked as failed, excluded from progress, and do not affect the result.
 *
 * Note: if the message contains no applicable body (for example, a file-only message), the success callback is invoked but nothing is downloaded.
 *
 * Download progress is reported for the large image: each body is weighted by its original file size, each tick is derived from the actual response length, and the aggregated message-level progress (range [0,100], including the normalized original voice file) is reported through `aProgressBlock`. The result is reported once per download request: if any applicable body fails, the remaining downloads are aborted.
 * 
 * This is an asynchronous method.
 *
 * @param aMessage          The message object.
 * @param aProgressBlock    The callback block of attachment download progress. The progress value range is [0,100].
 * @param aCompletionBlock   The completion block, which contains the error message if the method fails.
 */
- (void)downloadBigImageAttachment:(AgoraChatMessage *_Nonnull)aMessage
                         progress:(void (^_Nullable)(int progress))aProgressBlock
                       completion:(void (^_Nullable)(AgoraChatMessage *_Nullable message, AgoraChatError *_Nullable error))aCompletionBlock;

/**
 *  \
 *  Download and parse the attachment in a combined message.
 *
 *  This is an asynchronous method.
 *
 *  @param aMessage            The combined message object.
 *  @param aCompletionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)downloadAndParseCombineMessage:(AgoraChatMessage* _Nonnull)aMessage
                            completion:(void (^_Nullable)(NSArray<AgoraChatMessage *>*_Nullable messages, AgoraChatError *_Nullable error))aCompletionBlock;
/**
 *  \
 *  Gets the read receipts of a specified group message from the server.
 *
 *  By getting the read receipts of a group message, you can see how many group members have read this message. The `role` and `joinTimestamp`fields of the group member information are not available.
 *
 *  This is an asynchronous method.
 *
 *  @param  aMessageId           The message ID.
 *  @param  aGroupId             The group ID.
 *  @param  aReadReceiptId          The ID of the read receipt to get from the server.
 *  @param  aPageSize            The number of read receipts that you expect to get on each page.
 *  @param  aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)asyncFetchGroupMessageReadUsersFromServer:(NSString *_Nonnull)aMessageId
                                          groupId:(NSString *_Nonnull)aGroupId
                                    readReceiptId:(NSString *_Nonnull)aReadReceiptId
                                         pageSize:(int)aPageSize
                                       completion:(void (^_Nullable)(AgoraChatCursorResult<AgoraChatGroupReadReceipt *> *_Nullable aResult, AgoraChatError *_Nullable error, int totalCount))aCompletionBlock;

/*!
 *  \
 *  Deletes local historical messages with a Unix timestamp before a specified one.After setting the `autoLoadConversations` attribute in ``AgoraChatOptions`` to `false`, the filtered session pull messages will not be read accurately.
 *
 *  @param aTimestamp            The specified Unix timestamp in miliseconds. Messages with a Unix timestamp before the specified one will be deleted.
 *  @param aCompletion           The completion block, which contains the error message if the method fails.
 *
 */
- (void)deleteMessagesBefore:(NSUInteger)aTimestamp
                  completion:(void(^_Nullable)(AgoraChatError*_Nullable error))aCompletion;



/**
 *  \
 *  Removes messages in a conversation (from both local storage and the server).
 *
 *  @param conversation The AgoraChatConversation object.
 *  @param messageIds   A string array of message IDs to delete.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithConversation:(AgoraChatConversation *_Nonnull)conversation messageIds:(NSArray <__kindof NSString*>*_Nonnull)messageIds completion:(void (^ _Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;
/**
 *  \
 *  Removes messages in a conversation (from both local storage and the server).
 *
 *  @param conversation The AgoraChatConversation object.
 *  @param beforeTimeStamp   The specified Unix timestamp in miliseconds. Messages with a timestamp before the specified one will be removed from the conversation.
 *  @param completion   The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMessagesFromServerWithConversation:(AgoraChatConversation *_Nonnull)conversation timeStamp:(NSTimeInterval)beforeTimeStamp completion:(void (^ _Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;


/*!
 *  \
 *  Translates a message.
 *
 *  @param aMessage             The message object.
 *  @param aLanguages           The list of target language codes.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)translateMessage:(AgoraChatMessage * _Nonnull)aMessage
         targetLanguages:(NSArray<NSString*>* _Nonnull)aLanguages
              completion:(void (^_Nullable)(AgoraChatMessage * _Nullable message, AgoraChatError * _Nullable error))aCompletionBlock;

/*!
 *  \
 *  Transcribes a voice message to text.
 * 
 * This method only supports successfully sent voice messages. 
 * 
 * Once transcribed, the text is returned via callback and can also be retrieved through {@link AgoraChatVoiceMessageBody#text}.
 * 
 * This method supports AMR and MP3 voice messages, but does not support direct transcription of PCM format.
 *
 *  @param aMessage             The voice message object.
 *  @param aCompletionBlock     The completion block, providing the error details in case of failure.
 */
- (void)voiceMessageToText:(AgoraChatMessage * _Nonnull)aMessage
                completion:(void (^_Nullable)(NSString * _Nullable text, AgoraChatError * _Nullable error))aCompletionBlock;

/*!
 *  \
 *  Transcribes a local voice file to text.
 *
 *  @param aFilePath            The local path of the voice file.
 *  @param aVoiceParam          The voice parameters. 
 * 
 * - For {@link AgoraChatVoiceParam.AgoraChatVoiceFormatPCM}, since it lacks header information, you must provide parameters such as the sample rate and the number of channels via aVoiceParam.
 * - For {@link AgoraChatVoiceParam.AgoraChatVoiceFormatMP3} and {@link AgoraChatVoiceParam.AgoraChatVoiceFormatAMR}, since the system automatically parses the file header, this parameter can be `nil`.
 * 
 *  @param aCompletionBlock     The completion block, providing the error details in case of failure.
 */
- (void)voiceFileToText:(NSString * _Nonnull)aFilePath
             voiceParam:(AgoraChatVoiceParam * _Nullable)aVoiceParam
             completion:(void (^_Nullable)(NSString * _Nullable text, AgoraChatError * _Nullable error))aCompletionBlock;

/*!
 *  \
 *
 *  Gets all languages supported by the translation service.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)fetchSupportedLanguages:(void(^_Nullable)(NSArray<AgoraChatTranslateLanguage*>* _Nullable languages,AgoraChatError* _Nullable error))aCompletionBlock;

/**
 *  \
 *  Loads messages with the specified keyword from the local database.
 *
 *  This method returns messages in chronological order.
 *
 *  @param aTypes             The message types to load. Types include txt (text message), img (image message), loc (location message), audio (audio message), video (video message), file (file message), and cmd (command message). ``AgoraChatMessageBodyType``
 *  @param aTimestamp       The message timestamp threshold for loading. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load. If you set this parameter to a value less than 1, the SDK gets one message from the local database.
 *  @param aUsername        The message sender. It is optional. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)searchMessagesWithTypes:(NSArray <NSNumber*>* _Nonnull)aTypes
                   timestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString* _Nullable)aUsername
             searchDirection:(AgoraChatMessageSearchDirection)aDirection
                   completion:(void (^_Nonnull)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Loads messages with the specified keyword from the local database.
 *
 *  The SDK returns messages in the chronological order.
 *
 *  @param aKeyword         The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The Unix timestamp threshold for message search. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aCount           The number of messages to load. If you set this parameter to 0 or less, the SDK gets one message from the local database.
 *  @param aSender          The sender of the message. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *                          - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                          - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aScope       The message search scope. See {@link AgoraChatMessageSearchScope}.
 *  @param aCompletionBlock  The completion block which contains the error code and error information if the method fails.
 */
- (void)loadMessagesWithKeyword:(NSString* _Nonnull)aKeywords
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString *_Nullable)aSender
                searchDirection:(AgoraChatMessageSearchDirection)aDirection
                          scope:(AgoraChatMessageSearchScope)aScope
                     completion:(void (^_Nullable)(NSArray<AgoraChatMessage *> *_Nullable aMessages, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Loads messages with the specified keyword from the local database, returning a dictionary containing conversation IDs and message ID arrays.
 *  The SDK returns messages in chronological order.
 *  @param aKeywords        The keyword for message search. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aTimestamp       The Unix timestamp threshold for message search. The unit is millisecond. If you set this parameter as a negative value, the SDK loads messages from the latest one.
 *  @param aSender          The sender of the message. If you set this parameter as `nil`, the SDK ignores this parameter when retrieving messages.
 *  @param aDirection       The message search direction. See {@link AgoraChatMessageSearchDirection}.
 *                        - `UP`: The SDK retrieves messages in the descending order of the timestamp included in them.
 *                        - `DOWN`：The SDK retrieves messages in the ascending order of the timestamp included in them.
 *  @param aScope           The message search scope. See {@link AgoraChatMessageSearchScope}.
 *  @param aCompletionBlock  The completion block which contains the error code and error information if the method fails.
 */
- (void)loadConversationMessagesWithKeyword:(NSString*_Nullable )aKeywords
                                  timestamp:(long long)aTimestamp
                                   fromUser:(NSString*_Nullable )aSender
                            searchDirection:(AgoraChatMessageSearchDirection)aDirection
                                      scope:(AgoraChatMessageSearchScope)aScope
                                 completion:(void (^ _Nonnull)(NSDictionary<NSString*,NSArray<NSString*> *> * _Nullable aConversationMessages, AgoraChatError * _Nullable aError))aCompletionBlock;

NS_ASSUME_NONNULL_BEGIN
/*!
 *  \
 *  Adds a Reaction.
 *
 *  @param reaction  The Reaction content.
 *  @param messageId  The message ID.
 *  @param completion  The completion block which contains the error code and error information if the method fails.
 */
- (void)addReaction:(NSString *)reaction toMessage:(NSString *)messageId completion:(nullable void(^)(AgoraChatError * _Nullable))completion;

/*!
 *  \
 *  Removes a Reaction.
 *
 *  @param reaction  The Reaction content.
 *  @param messageId  The message ID.
 *  @param completion  The completion block which contains the error code and error information if the method fails.
 */
- (void)removeReaction:(NSString *)reaction fromMessage:(NSString *)messageId completion:(nullable void(^)(AgoraChatError * _Nullable))completion;

/*!
 *  \
 *  Gets the Reaction list.
 *
 *  @param messageId  The message ID.
 *  @param groupId  The group ID. This parameter is invalid only for group chat.
 *  @param chatType  The chat type. Only one-to-one chat ({@link AgoraChatTypeChat} and group chat ({@link AgoraChatTypeGroupChat}) are allowed.
 *  @param completion The completion block which contains the error code and error information if the method fails.
 */
- (void)getReactionList:(NSArray <NSString *>*)messageIds
                groupId:(nullable NSString *)groupId
               chatType:(AgoraChatType)chatType
             completion:(void (^)(NSDictionary <NSString *, NSArray<AgoraChatMessageReaction *> *> *, AgoraChatError * _Nullable))completion;

/*!
 *  \
 *  Uses the pagination to get the Reaction detail list of a chat group message.
 *
 *  @param messageId  The message ID.
 *  @param reaction  The Reaction content.
 *  @param cursor  The position from which to start getting data. If it is set to `nil` or `@""` at the first call, the SDK retrieves Reactions in the chronological order of their creation time.
 *  @param pageSize   The number of Reactions that you expect to get on each page. The value range is [1,100].
 *  @param completion  The completion block, which contains the Reaction list and the cursor for the next query. When the cursor is `nil`, all data is already fetched.
 */
- (void)getReactionDetail:(NSString *)messageId
                 reaction:(NSString *)reaction
                    cursor:(nullable NSString *)cursor
                 pageSize:(uint64_t)pageSize
               completion:(void (^)(AgoraChatMessageReaction *, NSString * _Nullable cursor, AgoraChatError * _Nullable))completion;

/**
 *  \
 *  Get the historical messages of the specified session from the server page according to the message pull parameter configuration interface (`AgoraChatFetchServerMessagesOption`).
 *  When the number of returned messages is less than the expected number of messages, it means that the server has no more historical messages.
 *
 *  @param conversationId The conversation ID.
 *                        - One-to-one chat: The ID of the peer user;
 *                        - Group chat: The group ID;
 *                        - Chat room: The chat room ID.
 *  @param type The conversation type.
 *  @param cursor The cursor position from which to start querying data.
 *  @param pageSize The number of messages that you expect to get on each page. The value range is [1,50].
 *  @param option  The parameter configuration class for pulling historical messages from the server. See {@link AgoraChatFetchServerMessagesOption}.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)fetchMessagesFromServerBy:(NSString* )conversationId
                 conversationType:(AgoraChatConversationType)type
                           cursor:(NSString* _Nullable)cursor
                         pageSize:(NSUInteger)pageSize
                           option:(AgoraChatFetchServerMessagesOption* _Nullable)option
                       completion:(void (^_Nullable)(AgoraChatCursorResult<AgoraChatMessage*>* _Nullable result, AgoraChatError* _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Searches messages from the server.
 *  This feature requires the "Message Search" service to be enabled in the Console.
 *
 *  @param option The search option. See {@link AgoraChatMessageSearchOption}.
 *  @param pageSize Results per page.
 *  @param pageNum The page number for pagination, starting from 1.
 *  @param completion The completion block, which contains the search result or error.The search result is sorted by relevance.
 *
 */
- (void)searchMessagesFromServerWithOption:(AgoraChatMessageSearchOption *)option
                                  pageSize:(NSInteger)pageSize
                                   pageNum:(NSInteger)pageNum
                                completion:(void (^_Nullable)(AgoraChatPageResult<AgoraChatSearchServerMessageResult*>* _Nullable result, AgoraChatError* _Nullable aError))completion;

/**
 *  \
 *  Marks conversations.
 *
 *  This method marks conversations both locally and on the server.
 *
 *  @param conversationIds The list of conversation IDs.
 *  @param mark  The mark to add for the conversations.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addConversationMark:(NSArray<NSString*>* _Nonnull)conversationIds mark:(AgoraChatMarkType)mark completion:(void (^_Nullable)(AgoraChatError* _Nullable aError))completion;

/**
 *  \
 *
 *  Unmarks conversations.
 *
 *  This method unmarks conversations both locally and on the server.
 *
 *  @param conversationIds The list of conversation IDs.
 *  @param mark The conversation mark to remove.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeConversationMark:(NSArray<NSString*>* _Nonnull)conversationIds mark:(AgoraChatMarkType)mark completion:(void (^_Nullable)(AgoraChatError* _Nullable aError))completion;


/**
 * \
 * Clears all conversations and all messages in them.
 *
 * This is an asynchronous method.
 *
 * @param clearSeverData Whether to clear all conversations and all messages in them on the server.
 *  - YES：Yes. All conversations and all messages in them will be cleared on the server side.
           The current user cannot retrieve messages and conversations from the server, while this has no impact on other users.
 *  - (Default) NO：No. All local conversations and all messages in them will be cleared, while those on the server remain.
 * @param aCompletionBlock The completion callback, which contains the description of the cause to the failure.
 */
- (void)deleteAllMessagesAndConversations:(BOOL)clearServerData completion:(void (^_Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 * \
 * Pins a message.
 *
 * @param messageId The ID of the message to be pinned.
 * @param aCompletionBlock The completion block, which contains the pinned message object if the call succeeds, or contains the error message if the method fails.
 */
- (void)pinMessage:(NSString* _Nonnull)messageId completion:(void (^_Nullable)(AgoraChatMessage* _Nullable message,AgoraChatError * _Nullable aError))aCompletionBlock;
/**
 * \
 * Unpins a message.
 *
 * @param messageId The ID of the message to be unpinned.
 * @param aCompletionBlock The completion block, which contains the unpinned message object if the call succeeds, or contains the error message if the method fails.

 */
- (void)unpinMessage:(NSString* _Nonnull)messageId completion:(void (^_Nullable)(AgoraChatMessage* _Nullable message,AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 * \
 * Gets the list of pinned messages in a conversation.
 *
 * @param conversationId The conversation ID.
 * @param aCompletionBlock The completion block, which contains the list of pinned messages if the call succeeds, or contains the error message if the method fails.
 */
- (void)getPinnedMessagesFromServer:(NSString* _Nonnull)conversationId completion:(void (^_Nullable)(NSArray<AgoraChatMessage*>* _Nullable messages,AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Get the message count from db.
 *
 *  @param completion  The completion block, which contains the number of message count in db.
 */
- (void)getMessageCountWithCompletion:(void (^)(NSInteger count, AgoraChatError * _Nullable aError))completion;

/**
 *  \
 *  Gets messages with the specified IDs from the local database. A maximum of 20 messages can be retrieved at a time, and the returned messages are sorted in reverse chronological order.
 *  @param aMessageIds      The message IDs.
 *  @param aConversationId    The conversationId which messages in.
 *  @param aCompletionBlock The completion block, which contains the list of messages and the error message if the method fails.
 */
- (void)getMessages:(NSArray<NSString *> * _Nonnull)aMessageIds
  withConversationId:(NSString * _Nonnull)aConversationId
          completion:(void (^ _Nonnull)(NSArray<AgoraChatMessage *> * _Nullable aMessages, AgoraChatError * _Nullable aError))aCompletionBlock;
    
NS_ASSUME_NONNULL_END

@end
