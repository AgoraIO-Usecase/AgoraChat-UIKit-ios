//
//  AgoraChatMessageReactionOperation.h
//  AgoraChat
//
//  Created by 冯钊 on 2023/2/28.
//  Copyright © 2023 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  \
 *  Operation type of reaction.
 */
typedef NS_ENUM(NSUInteger, AgoraChatMessageReactionOperate) {
    AgoraChatMessageReactionOperateRemove = 0,
    AgoraChatMessageReactionOperateAdd,
};

NS_ASSUME_NONNULL_BEGIN

@interface AgoraChatMessageReactionOperation : NSObject

/**
 *  \
 *  Operator.
 */
@property (copy, readonly) NSString *userId;

/**
 *  \
 *  Changed reaction.
 */
@property (copy, readonly) NSString *reaction;

/**
 *  \
 *  Operate.
 */
@property (assign, readonly) AgoraChatMessageReactionOperate operate;

@end

NS_ASSUME_NONNULL_END
