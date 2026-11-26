//
//  AgoraChatConversationFilter.h
//  AgoraChat
//
//  Created by li xiaoming on 2023/12/6.
//  Copyright © 2023 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatConversation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The conversation filter class.
 */
@interface AgoraChatConversationFilter : NSObject

/**
 * \
 * The number of conversations to retrieve on each page. The value range is [1,10].
 *
 */
@property (nonatomic) NSInteger pageSize;

/**
 * \
 * The conversation mark.
 *
 */
@property (nonatomic) AgoraChatMarkType mark;

/**
 *  \
 *  Initializes the conversation filter class.
 *
 *  @param mark   The conversation mark.
 *  @param pageSize The number of conversations to retrieve on each page. The value range is [1,10].
 *
 *  @result The conversation filter instance.
 */
- (instancetype _Nonnull)initWithMark:(AgoraChatMarkType)mark pageSize:(NSInteger)pageSize;
@end

NS_ASSUME_NONNULL_END
