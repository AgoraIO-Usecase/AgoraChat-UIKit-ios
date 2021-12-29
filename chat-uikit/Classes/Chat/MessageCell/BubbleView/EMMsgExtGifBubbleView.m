//
//  EMMsgExtGifBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgExtGifBubbleView.h"

#import "EaseEmoticon.h"

@implementation EMMsgExtGifBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        self.gifView = [[EaseAnimatedImgView alloc] init];
        [self addSubview:self.gifView];
        [self.gifView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.height.lessThanOrEqualTo(@100);
        }];
    }
    
    return self;
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    AgoraChatMessageType type = model.type;
    if (type == AgoraChatMessageTypeExtGif) {
        NSString *name = [(AgoraChatTextMessageBody *)model.message.body text];
        EaseEmoticon *group = [EaseEmoticon getGifGroup];
        for (EaseEmoticonModel *model in group.dataArray) {
            if ([model.name isEqualToString:name]) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"chat-uikit" ofType:@"bundle"];
                NSString *gifPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif",model.original]];
                NSData *imageData = [NSData dataWithContentsOfFile:gifPath];
                self.gifView.animatedImage = [EaseAnimatedImg animatedImageWithGIFData:imageData];
                break;
            }
        }
    }
}

@end
