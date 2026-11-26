/**
 *  \
 *  @header AgoraChatManagerDelegate.h
 *  @abstract This protocol defines chat related callbacks.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatRecallMessageInfo.h"

@class AgoraChatMessage;
@class AgoraChatError;
@class AgoraChatMessageReactionChange;
@class AgoraChatGroupReadReceipt;
@class AgoraChatMessageReadReceipt;

/**
 *  \
 *  The chat related callbacks.
 */
@protocol AgoraChatManagerDelegate <NSObject>

@optional

#pragma mark - Message

/**
 *  \
 *  Occurs when the SDK receives new messages.
 *
 *  @param aMessages  The received stream messages. An NSArray of the <AgoraChatMessage> objects.
 */
- (void)onStreamMessagesReceived:(NSArray<AgoraChatMessage *> * _Nonnull)messages;

/**
 *  \
 *  Occurs when the SDK receives new messages.
 *
 *  @param aMessages  The received messages. An NSArray of the <AgoraChatMessage> objects.
 */
- (void)messagesDidReceive:(NSArray<AgoraChatMessage *> * _Nonnull)aMessages;

/**
 *  \
 *  Occurs when receiving command messages.
 *
 *  @param aCmdMessages  The command message NSArray.
 */
- (void)cmdMessagesDidReceive:(NSArray<AgoraChatMessage *> * _Nonnull)aCmdMessages;

/**
 *  \
 *  Occurs when receiving delivered acknowledgement in message list.
 *
 *  @param aMessages  The acknowledged message NSArray.
 */
- (void)messagesDidDeliver:(NSArray<AgoraChatMessage *> * _Nonnull)aMessages;

/**
 *  \
 *  Occurs when a message is recalled. If the recalled message is offline, the ``AgoraChatRecallMessageInfo`` object will be an empty object.
 *
 *  @param aRecallMessagesInfo  The list of recalled messages.
 */
- (void)messagesInfoDidRecall:(NSArray<AgoraChatRecallMessageInfo *> * _Nonnull)aRecallMessagesInfo;

/**
 *  \
 *  Occurs when message status has changed. You need to set the parameter as nil.
 *
 *  @param aMessage  The message whose status has changed.
 *  @param aError    The error information.
 */
- (void)messageStatusDidChange:(AgoraChatMessage * _Nonnull)aMessage
                         error:(AgoraChatError * _Nullable)aError;

/**
 *  \
 *  Occurs when the message attachment status changed.
 *
 *  @param aMessage  The message whose attachment status has changed.
 *  @param aError    The error information.
 */
- (void)messageAttachmentStatusDidChange:(AgoraChatMessage * _Nonnull)aMessage
                                   error:(AgoraChatError * _Nullable)aError;
/**
 *  \
 *  Occurs when the message content is modified.
 *
 *  @param message  The modified message object, where the message body contains the information such as the number of message modifications, the operator of the last modification, and the last modification time.Also, you can get the operator of the last message modification and the last modification time via the `onMessageContentChanged` method.
 *  @param operatorId    The user ID of the operator that modified the message last time.
 *  @param operationTime   The last message modification time. It is a UNIX timestamp in milliseconds.
 */
- (void)onMessageContentChanged:(AgoraChatMessage *_Nonnull)message operatorId:(NSString *_Nonnull)operatorId operationTime:(NSUInteger)operationTime;

/**
 * \
 * Occurs when the message pinning status changed.
 *
 * @param messageId The ID of the message with the changed pinning status.
 * @param conversationId The ID of the conversation that contains the message.
 * @param pinOperation The message pinning or unpinning operation.
 * @param pinInfo The information about message pinning or unpinning, including the operation time and the user ID of the operater.
 */
- (void)onMessagePinChanged:(NSString* _Nonnull)messageId conversationId:(NSString* _Nonnull)conversationId operation:(AgoraChatMessagePinOperation)pinOperation pinInfo:(AgoraChatMessagePinInfo* _Nonnull)pinInfo;

/*!
 *  \
 *  Occurs when the Reaction data changes.
 *
 *  @param changes The Reaction which is changed.
 */
- (void)messageReactionDidChange:(NSArray<AgoraChatMessageReactionChange *>* _Nonnull)changes;

#pragma mark - Read Receipt

/**
 *  \
 *  Occurs when message read receipts are received.
 *
 *  Used for both one-to-one and group chats.
 *
 *  @param aReceipts  The read receipt list.
 */
- (void)onMessageReadReceipts:(NSArray<AgoraChatMessageReadReceipt *> * _Nonnull)aReceipts;

@end
