//
//  EMMsgFileBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgFileBubbleView.h"
#import "EMMsgThreadPreviewBubble.h"
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))
@interface EMMsgFileBubbleView ()
{
    EaseChatViewModel *_viewModel;
}
@property (nonatomic, strong) EMMsgThreadPreviewBubble *threadBubble;
@end
@implementation EMMsgFileBubbleView

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
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    [self addSubview:self.iconView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont fontWithName:@"PingFang SC" size:16.0];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.numberOfLines = 1;
    [self addSubview:self.textLabel];
//    [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(self).offset(10);
//    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont fontWithName:@"PingFang SC" size:14.0];
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.detailLabel];
//    [self.detailLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(self.textLabel.ease_bottom);
//        make.bottom.equalTo(self).offset(-10);
//        make.left.right.equalTo(self.textLabel);
//    }];
    
    self.downloadStatusLabel = [[UILabel alloc] init];
    self.downloadStatusLabel.font = [UIFont systemFontOfSize:10];
    self.downloadStatusLabel.numberOfLines = 0;
    self.downloadStatusLabel.textAlignment = NSTextAlignmentRight;
    self.downloadStatusLabel.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0];
    [self addSubview:self.downloadStatusLabel];
    self.iconView.image = [UIImage easeUIImageNamed:@"doc"];
//    if (self.direction == AgoraChatMessageDirectionSend) {
//        [self.textLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
//            make.left.equalTo(self).offset(8);
//            make.right.equalTo(self).offset(-65);
//        }];
//        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//            make.top.left.equalTo(self).offset(10);
//            make.bottom.equalTo(self).offset(-10);
//            make.centerY.equalTo(self);
//            make.width.height.equalTo(@50);
//        }];
//        self.detailLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//    } else {
//        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//            make.top.equalTo(self).offset(10);
//            make.left.equalTo(self).offset(12);
//            make.centerY.equalTo(self);
//            make.width.height.equalTo(@50);
//        }];
//        [self.textLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
//            make.left.equalTo(self.iconView.ease_right).offset(12);
//            make.right.equalTo(self).offset(-12);
//        }];
//        self.detailLabel.textColor = [UIColor grayColor];
//    }
//    [self.downloadStatusLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(self.textLabel.ease_bottom).offset(16);
//        make.bottom.equalTo(self).offset(-10);
//        make.left.equalTo(self.ease_centerX);
//        make.right.equalTo(self.textLabel);
//    }];
}

- (void)updateThreadLayout:(CGRect)rect model:(EaseMessageModel *)model{
    [self Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.width.Ease_equalTo(rect.size.width);
        make.height.Ease_equalTo(rect.size.height);
    }];
    if (model.isHeader == NO && model.message.chatThread) {
        [_threadBubble Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-12);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4);
            make.width.Ease_equalTo(KEMThreadBubbleWidth);
        }];
    } else {
        [_threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
           
        }];
    }
    if (self.direction == AgoraChatMessageDirectionSend) {
        [self.iconView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            if (self.threadBubble.hidden == NO) {
                make.bottom.equalTo(self.threadBubble.ease_top).offset(-5);
            } else {
                make.centerY.equalTo(self);
            }
            make.right.equalTo(self).offset(-12);
            make.width.height.equalTo(@50);
        }];
        [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-68);
            make.left.equalTo(self).offset(12);
        }];
        self.detailLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    } else {
        [self.iconView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            if (self.threadBubble.hidden == NO) {
                make.bottom.equalTo(self.threadBubble.ease_top).offset(-5);
            } else {
                make.centerY.equalTo(self);
            }
            make.left.equalTo(self).offset(12);
            make.width.height.equalTo(@50);
        }];
        [self.textLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.iconView.ease_right).offset(10);
            make.right.equalTo(self.ease_right).offset(-12);
        }];

        self.detailLabel.textColor = [UIColor grayColor];
    }

    [self.detailLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-10);
        make.left.right.equalTo(self.textLabel);
        make.height.Ease_equalTo(15);
        if (self.threadBubble.hidden == YES) {
            make.top.equalTo(self.textLabel.ease_bottom).offset(5);
        } else {
            make.bottom.equalTo(self.threadBubble.ease_top).offset(-5);
        }
    }];
    [self.downloadStatusLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        if (self.threadBubble.hidden == YES) {
            make.top.equalTo(self.textLabel.ease_bottom).offset(16);
        } else {
            make.bottom.equalTo(self.threadBubble.ease_top).offset(-5);
        }
//        make.bottom.equalTo(self.threadBubble.ease_top).offset(-10);
        make.left.right.equalTo(self.textLabel);
    }];
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    if (model.isHeader == NO) {
        if (model.message.chatThread) {
            self.threadBubble.model = model;
            self.threadBubble.hidden = !model.message.chatThread;
        }else {
            self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            self.threadBubble.hidden = YES;
        }
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        self.threadBubble.hidden = YES;
    }
    AgoraChatMessageType type = model.type;
    
    if (type == AgoraChatMessageTypeFile) {
        CGFloat height = 70;
        if (!model.isHeader) {
            if (model.message.chatThread) {
                self.maxBubbleWidth = KEMThreadBubbleWidth+24;
            }
            if (model.message.chatThread) {
                height = 65+4+12+KEMThreadBubbleWidth*0.4;
            }
        }
        CGRect rect = CGRectMake(0, 0, self.maxBubbleWidth, height);
        [self setCornerRadius:rect];
        [self setupBubbleBackgroundImage];
        [self updateThreadLayout:rect model:model];
        AgoraChatFileMessageBody *body = (AgoraChatFileMessageBody *)model.message.body;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:body.displayName];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //paragraphStyle.lineSpacing = 5.0; // 设置行间距
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSKernAttributeName value:@0.34 range:NSMakeRange(0, attributedStr.length)];

        self.textLabel.attributedText = attributedStr;
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.detailLabel.text = [NSString stringWithFormat:@"%.2lf MB",(float)body.fileLength / (1024 * 1024)];
        
        if (self.direction == AgoraChatMessageDirectionReceive && body.downloadStatus == AgoraChatDownloadStatusSucceed) {
            self.downloadStatusLabel.text = @"Downloaded";
        } else {
            self.downloadStatusLabel.text = @"";
        }
        if (model.message.chatThread && model.isHeader == NO) {
            self.threadBubble.model = model;
        }
        
    }
}

@end
