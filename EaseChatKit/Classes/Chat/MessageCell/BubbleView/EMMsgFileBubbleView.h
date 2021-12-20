//
//  EMMsgFileBubbleView.h
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseChatMessageBubbleView.h"
#import "EaseHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMMsgFileBubbleView : EaseChatMessageBubbleView

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *downloadStatusLabel;

@end

NS_ASSUME_NONNULL_END
