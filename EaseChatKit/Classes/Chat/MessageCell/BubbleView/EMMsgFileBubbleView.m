//
//  EMMsgFileBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgFileBubbleView.h"

@interface EMMsgFileBubbleView ()
{
    EaseChatViewModel *_viewModel;
}

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
    [self.textLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont fontWithName:@"PingFang SC" size:14.0];
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.detailLabel];
    [self.detailLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textLabel.ease_bottom);
        make.bottom.equalTo(self).offset(-10);
        make.left.right.equalTo(self.textLabel);
    }];
    
    self.downloadStatusLabel = [[UILabel alloc] init];
    self.downloadStatusLabel.font = [UIFont systemFontOfSize:10];
    self.downloadStatusLabel.numberOfLines = 0;
    self.downloadStatusLabel.textAlignment = NSTextAlignmentRight;
    self.downloadStatusLabel.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0];
    [self addSubview:self.downloadStatusLabel];
    [self.downloadStatusLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textLabel.ease_bottom).offset(16);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.ease_centerX);
        make.right.equalTo(self.textLabel);
    }];
    if (self.direction == AgoraChatMessageDirectionSend) {
        self.iconView.image = [UIImage easeUIImageNamed:@"doc"];
        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.textLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(self.iconView.ease_right).offset(8);
            make.right.equalTo(self).offset(-10);
        }];
        self.detailLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    } else {
        self.iconView.image = [UIImage easeUIImageNamed:@"doc"];
        [self.iconView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-12);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.textLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self.iconView.ease_left).offset(-12);
        }];
        
        self.detailLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    AgoraChatMessageType type = model.type;
    if (type == AgoraChatMessageTypeFile) {
        [self setImage:nil];
        CGRect rect = CGRectMake(0, 0, self.maxBubbleWidth, 70);
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self setCornerRadius:rect];
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
            self.downloadStatusLabel.text = @"已下载";
        } else {
            self.downloadStatusLabel.text = @"";
        }
    }
}

@end
