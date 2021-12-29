//
//  EMMsgExtGifBubbleView.h
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseAnimatedImg.h"
#import "EaseAnimatedImgView.h"
#import "EaseChatMessageBubbleView.h"
#import "EaseHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMMsgExtGifBubbleView : EaseChatMessageBubbleView

@property (nonatomic, strong) EaseAnimatedImgView *gifView;

@end

NS_ASSUME_NONNULL_END
