//
//  EaseChatMessageBubbleView.h
//  EaseChat
//
//  Created by XieYajie on 2019/1/25.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMessageModel.h"
#import "EaseChatViewModel.h"

@interface EaseChatMessageBubbleView : UIImageView

@property (nonatomic, readonly) AgoraChatMessageDirection direction;

@property (nonatomic, readonly) AgoraChatMessageType type;

@property (nonatomic, strong) EaseMessageModel *model;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@property (nonatomic, assign) BOOL unDrawCorner;

@property (nonatomic) CGFloat maxBubbleWidth;

@property (nonatomic, assign) BOOL isPlaying;

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel;

- (void)setupBubbleBackgroundImage;

- (void)setupThreadBubbleBackgroundImage;

- (void)setCornerRadius:(CGRect)bounds;

@end
