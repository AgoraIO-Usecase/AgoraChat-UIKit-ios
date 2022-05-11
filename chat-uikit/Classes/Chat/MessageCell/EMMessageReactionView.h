//
//  EMMessageReactionView.h
//  EaseIMKit
//
//  Created by 冯钊 on 2022/2/11.
//

#import <UIKit/UIKit.h>
#import "EMHollowedOutPathDelegate.h"

@import AgoraChat;
@class EMMessageReaction;

NS_ASSUME_NONNULL_BEGIN

@interface EMMessageReactionView : UIView <EMHollowedOutPathDelegate>

@property (nonatomic, assign) AgoraChatMessageDirection direction;
@property (nonatomic, strong) NSArray<AgoraChatMessageReaction *> *reactionList;
@property (nonatomic, strong) void(^onClick)(void);

@end

NS_ASSUME_NONNULL_END
