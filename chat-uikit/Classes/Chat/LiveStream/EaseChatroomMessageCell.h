//
//  ELDChatMessageCell.h
//  EaseMobLiveDemo
//
//  Created by liu001 on 2022/4/14.
//  Copyright © 2022 zmw. All rights reserved.
//

#import "EaseLiveCustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatroomMessageCell : EaseLiveCustomCell

@property (nonatomic,strong,readonly) UILabel *messageLabel;

- (void)setMesssage:(AgoraChatMessage*)message chatroom:(AgoraChatroom*)chatroom;

+ (CGFloat)heightForMessage:(AgoraChatMessage *)message;


@end

NS_ASSUME_NONNULL_END
