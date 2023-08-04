//
//  EMMsgAudioBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgAudioBubbleView.h"
#import "EMMsgThreadPreviewBubble.h"
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))
#define kEMMsgAudioMinWidth 45
#define kEMMsgAudioMaxWidth 120

@interface EMMsgAudioBubbleView()
{
    EaseChatViewModel *_viewModel;
}
@property (nonatomic) float maxWidth;

@property (nonatomic, strong) EMMsgThreadPreviewBubble *threadBubble;
@end
 
@implementation EMMsgAudioBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                            viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
        self.threadBubble = [[EMMsgThreadPreviewBubble alloc] initWithDirection:aDirection type:aType viewModel:viewModel];
        self.threadBubble.tag = 777;
        [self addSubview:self.threadBubble];
        self.threadBubble.layer.cornerRadius = 8;
        self.threadBubble.clipsToBounds = YES;
        self.threadBubble.hidden = YES;
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self setupBubbleBackgroundImage];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.clipsToBounds = YES;
    self.imgView.animationDuration = 1.0;
    [self addSubview:self.imgView];
    [self.imgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.equalTo(self).offset(8);
        make.width.height.equalTo(@30);
    }];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
    [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
    }];
    
    if (self.direction == AgoraChatMessageDirectionSend) {
        [self sendLayout];
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        [self receiveLayout];
        self.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)sendLayout {
    [self.imgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
    }];
    [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.right.equalTo(self.imgView.ease_left).offset(-3);
        make.left.equalTo(self).offset(5);
    }];
    
    self.textLabel.textAlignment = NSTextAlignmentRight;
    
    self.imgView.image = [UIImage easeUIImageNamed:@"msg_send_audio"];
    self.imgView.animationImages = @[[UIImage easeUIImageNamed:@"msg_send_audio02"], [UIImage easeUIImageNamed:@"msg_send_audio01"], [UIImage easeUIImageNamed:@"msg_send_audio"]];
}

- (void)receiveLayout {
    [self.imgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
    }];
    [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.imgView.ease_right).offset(3);
        make.right.equalTo(self).offset(-5);
    }];
    
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    
    self.imgView.image = [UIImage easeUIImageNamed:@"msg_recv_audio"];
    self.imgView.animationImages = @[[UIImage easeUIImageNamed:@"msg_recv_audio02"], [UIImage easeUIImageNamed:@"msg_recv_audio01"], [UIImage easeUIImageNamed:@"msg_recv_audio"]];
}



- (void)threadLayout {
    [self Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.width.Ease_equalTo(KEMThreadBubbleWidth+24);
        make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4+49);
    }];
    [self.imgView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.width.height.equalTo(@30);
        make.left.equalTo(self).offset(5);
    }];
    [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.imgView.ease_right).offset(3);
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self.imgView);
        make.height.Ease_equalTo(15);
    }];
    
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    NSString *imageName = @"msg_recv_audio";
    if (self.direction == AgoraChatMessageDirectionSend) {
        imageName = @"msg_send_audio";
    }
    self.imgView.image = [UIImage easeUIImageNamed:imageName];
    self.imgView.animationImages = @[[UIImage easeUIImageNamed:@"msg_recv_audio02"], [UIImage easeUIImageNamed:@"msg_recv_audio01"], [UIImage easeUIImageNamed:@"msg_recv_audio"]];
    [_threadBubble Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-12);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4);
    }];
}

#pragma mark - Setter

- (void)setIsPlaying:(BOOL)isPlaying {
    if (isPlaying == YES) {
        [self.imgView startAnimating];
//        [self.imgView setNeedsLayout];
//        [self.imgView layoutIfNeeded];
    } else {
        [self.imgView stopAnimating];
    }
}

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    if (model.isHeader == NO) {
        if (model.message.chatThread) {
            self.threadBubble.model = model;
            self.threadBubble.hidden = !model.message.chatThread;
        } else {
            self.threadBubble.hidden = YES;
            [self.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            }];
        }
    } else {
        self.threadBubble.hidden = YES;
        [self.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        }];
    }
    _maxWidth= [UIScreen mainScreen].bounds.size.width / 2 - 100;
    if (model.message.chatThread && model.isHeader == NO) {
        _maxWidth = KEMThreadBubbleWidth + 24;
    }
    AgoraChatMessageType type = model.type;
    if (type == AgoraChatMessageTypeVoice) {
        AgoraChatVoiceMessageBody *body = (AgoraChatVoiceMessageBody *)model.message.body;
        self.textLabel.text = [NSString stringWithFormat:@"%d\"",(int)body.duration];
        
        
        float width = kEMMsgAudioMinWidth * body.duration / 10;
        if (width > _maxWidth) {
            width = _maxWidth;
        } else if (width < kEMMsgAudioMinWidth) {
            width = kEMMsgAudioMinWidth;
        }
        if (model.message.chatThread && model.isHeader == NO) {
            width = KEMThreadBubbleWidth+24;
            [self threadLayout];
        } else {
            [self Ease_updateConstraints:^(EaseConstraintMaker *make) {
                make.width.Ease_equalTo(width+24);
                make.height.Ease_equalTo(46);
            }];
            [self.imgView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self).offset(8);
                make.width.height.equalTo(@30);
                make.left.equalTo(self).offset(5);
            }];
        }
        [self.textLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.width.Ease_equalTo(width);
        }];
    }
}

@end
