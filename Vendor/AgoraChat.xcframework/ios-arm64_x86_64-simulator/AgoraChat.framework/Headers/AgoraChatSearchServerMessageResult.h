/**
 *  \
 *  @header AgoraChatSearchServerMessageResult.h
 *  @abstract Server message search result
 *  @author Hyphenate
 */

#import <Foundation/Foundation.h>
#import "AgoraChatMessageBody.h"
#import "AgoraChatMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The server message search result object.
 */
@interface AgoraChatSearchServerMessageResult : NSObject

/**
 *  \
 *  The message ID.
 */
@property (nonatomic, readonly) NSString *messageId;

/**
 *  \
 *  The message body.
 */
@property (nonatomic, readonly, nullable) AgoraChatMessageBody *body;

/**
 *  \
 *  The message extension attributes.
 */
@property (nonatomic, readonly, nullable) NSDictionary *ext;

/**
 *  \
 *  The message sender.
 */
@property (nonatomic, readonly) NSString *from;

/**
 *  \
 *  The message receiver.
 */
@property (nonatomic, readonly) NSString *to;

/**
 *  \
 *  The conversation ID.
 */
@property (nonatomic, readonly) NSString *conversationId;

/**
 *  \
 *  The chat type.
 */
@property (nonatomic, readonly) AgoraChatType chatType;

/**
 *  \
 *  The message timestamp in milliseconds.
 */
@property (nonatomic, readonly) NSInteger timestamp;

/**
 *  \
 *  The highlighted texts from search.
 */
@property (nonatomic, readonly, nullable) NSArray<NSString *> *highlightTexts;

@end

NS_ASSUME_NONNULL_END
