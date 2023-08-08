//
//  EMMsgTouchIncident.h
//  EaseIM
//
//  Created by zhangchong on 2020/7/7.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseChatViewController.h"
#import "EaseMessageCell.h"
#import "EaseThreadCreateViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgoraChatMessageEventStrategy : NSObject

@property (nonatomic, strong) EaseChatViewController *chatController;

- (void)messageCellEventOperation:(EaseMessageCell *)aCell;

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh;


@end


/**
    Message event factory
 */
@interface AgoraChatMessageEventStrategyFactory : NSObject

+ (AgoraChatMessageEventStrategy * _Nonnull)getStratrgyImplWithMsgCell:(AgoraChatMessageType *)type;

@end

@interface TextMsgEvent : AgoraChatMessageEventStrategy
@end

@interface ImageMsgEvent : AgoraChatMessageEventStrategy
@end

@interface LocationMsgEvent : AgoraChatMessageEventStrategy
@end

@interface VoiceMsgEvent : AgoraChatMessageEventStrategy
@end

@interface VideoMsgEvent : AgoraChatMessageEventStrategy
@end

@interface FileMsgEvent : AgoraChatMessageEventStrategy
@end

@interface ConferenceMsgEvent : AgoraChatMessageEventStrategy
@end

NS_ASSUME_NONNULL_END
