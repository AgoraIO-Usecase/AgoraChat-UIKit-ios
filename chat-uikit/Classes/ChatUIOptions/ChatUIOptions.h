//
//  ChatUIOptions.h
//  AgoraChatCallKit
//
//  Created by 冯钊 on 2022/4/19.
//

#import <Foundation/Foundation.h>

#import "ChatUIReactionOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatUIOptions : NSObject

@property (readonly, class) ChatUIOptions *shareOptions;
@property (readonly, strong) ChatUIReactionOptions *reactionOptions;

@end

NS_ASSUME_NONNULL_END
