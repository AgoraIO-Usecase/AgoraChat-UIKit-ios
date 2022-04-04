//
//  EMMsgThreadPreviewBubble.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/14.
//

#import <UIKit/UIKit.h>
#import "EaseChatMessageBubbleView.h"

@interface EMMsgThreadPreviewBubble : EaseChatMessageBubbleView

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *threadName;

@property (nonatomic, strong) UIButton *messageBadge;

@property (nonatomic, strong) UIImageView *avatar;

@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UILabel *messageContent;

@property (nonatomic, strong) UILabel *updateTime;


@end

