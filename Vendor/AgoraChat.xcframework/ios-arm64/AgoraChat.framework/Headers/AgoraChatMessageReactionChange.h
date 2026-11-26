//
//  AgoraChatMessageReactionChange.h
//  AgoraChat
//
//  Created by 冯钊 on 2022/3/11.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AgoraChatMessageReaction;
#import "AgoraChatMessageReactionOperation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The message reaction change callback object.
 */
@interface AgoraChatMessageReactionChange : NSObject

/**
 *  \
 *  The conversation ID.
 */
@property (nullable, readonly) NSString *conversationId;
/**
 *  \
 *  The message ID.
 */
@property (nullable, readonly) NSString *messageId;
/**
 *  \
 *  The Reaction which is changed.
 */
@property (nullable, readonly) NSArray <AgoraChatMessageReaction *>*reactions;

/**
 *  \
 *  Details of changed operation.
 */
@property (nullable, readonly) NSArray <AgoraChatMessageReactionOperation *>*operations;

@end

NS_ASSUME_NONNULL_END
