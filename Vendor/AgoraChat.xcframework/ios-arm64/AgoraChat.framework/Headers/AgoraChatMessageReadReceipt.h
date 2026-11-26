//
//  AgoraChatMessageReadReceipt.h
//  HyphenateSDK
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The message read receipt details.
 */
@interface AgoraChatMessageReadReceipt : NSObject

/**
 *  \
 *  The message ID.
 */
@property (nonatomic, copy, readonly) NSString *messageId;

/**
 *  \
 *  The conversation ID.
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/**
 *  \
 *  Whether the peer has sent a read receipt for a one-to-one chat message.
 */
@property (nonatomic, assign, readonly) BOOL isPeerReceipt;

/**
 *  \
 *  The number of group members that have read the message.
 */
@property (nonatomic, assign, readonly) NSInteger readCount;

@end

NS_ASSUME_NONNULL_END
