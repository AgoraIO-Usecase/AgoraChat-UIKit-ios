//
//  ELDChatMessageCell.m
//  EaseMobLiveDemo
//
//  Created by liu001 on 2022/4/14.
//  Copyright © 2022 zmw. All rights reserved.
//

#import "EaseChatroomMessageCell.h"
#import "EaseCustomMessageHelper.h"
#import "EaseHeaders.h"


#define kIconImageViewHeight 30.0f

#define kCellVPadding  5.0

#define kContentLabelMaxWidth EaseKitScreenWidth -kIconImageViewHeight -EaseKitPadding *3

#define kNameLabelHeight 14.0

static AgoraChatroom *_chatroom;

@interface EaseChatroomMessageCell ()

@property (nonatomic, strong) UIImageView *roleImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSString *msgFrom;
@property (nonatomic, strong) AgoraChatUserInfo *userInfo;
@property (nonatomic, strong) AgoraChatroom *chatroom;


@end

@implementation EaseChatroomMessageCell
- (void)prepare {
    
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.roleImageView];
    [self.contentView addSubview:self.messageLabel];
    
    self.nameLabel.font = EaseKitNFont(12.0f);
    self.nameLabel.textColor = EaseKitTextLabelGrayColor;
    self.avatarImageView.layer.cornerRadius = kIconImageViewHeight * 0.5;

}

- (void)placeSubViews {
    [self.avatarImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kCellVPadding);
        make.left.equalTo(self.contentView).offset(10.0);
        make.size.equalTo(@(kIconImageViewHeight));
    }];
        
    
    [self.nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView);
        make.height.equalTo(@(kNameLabelHeight));
        make.left.equalTo(self.avatarImageView.ease_right).offset(10.0);
    }];
    
    
    [self.roleImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.ease_right).offset(5.0f);
    }];
    
    [self.messageLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.ease_bottom).offset(kCellVPadding);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(-10.0);
    }];
    
}


#pragma mark
- (void)setMesssage:(AgoraChatMessage*)message chatroom:(AgoraChatroom*)chatroom
{
    
    self.chatroom = chatroom;
    NSString *chatroomOwner = self.chatroom.owner;
    
    if ([message.from isEqualToString:chatroomOwner]) {
        [self.roleImageView setImage:EaseKitImageWithName(@"live_streamer")];
    }else if ([self.chatroom.adminList containsObject:message.from]){
        [self.roleImageView setImage:EaseKitImageWithName(@"live_moderator")];
    }else {
        [self.roleImageView setImage:EaseKitImageWithName(@"")];
    }
    
    self.msgFrom = message.from;
    [self fetchUserInfoWithUserId:self.msgFrom];

    
    self.messageLabel.attributedText = [EaseChatroomMessageCell _attributedStringWithMessage:message];
    _chatroom = chatroom;
}




+ (CGFloat)heightForMessage:(AgoraChatMessage *)message
{
    CGFloat height = 0;
    CGSize textBlockMinSize = {kContentLabelMaxWidth, CGFLOAT_MAX};
    CGSize retSize;
    NSString *text = [EaseChatroomMessageCell contentWithMessage:message];
    retSize = [text boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{
                                           NSFontAttributeName:[EaseChatroomMessageCell contentFont],
                                           NSParagraphStyleAttributeName:[EaseChatroomMessageCell contentLabelParaStyle]
                                           }
                                 context:nil].size;
    height = retSize.height;
    height += kCellVPadding * 3 + kNameLabelHeight;

    
    return height;
}


+ (NSMutableAttributedString*)_attributedStringWithMessage:(AgoraChatMessage*)message
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[EaseChatroomMessageCell contentWithMessage:message]];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: [EaseChatroomMessageCell contentLabelParaStyle],NSFontAttributeName :[EaseChatroomMessageCell contentFont]};
    [text addAttributes:attributes range:NSMakeRange(0, text.length)];
    return text;
}


+ (NSString *)contentWithMessage:(AgoraChatMessage *)message {
    NSString *latestMessageTitle = @"";
    if (message) {
        AgoraChatMessageBody *messageBody = message.body;
        switch (messageBody.type) {
            case AgoraChatMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case AgoraChatMessageBodyTypeText:{
//                NSString *didReceiveText = [EaseEmojiHelper
//                                            convertEmoji:((AgoraChatTextMessageBody *)messageBody).text];
//                latestMessageTitle = didReceiveText;
                latestMessageTitle = ((AgoraChatTextMessageBody *)messageBody).text;
            } break;
            case AgoraChatMessageBodyTypeVoice:{
                latestMessageTitle = @"[语音]";
            } break;
            case AgoraChatMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case AgoraChatMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case AgoraChatMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}


+ (NSMutableParagraphStyle *)contentLabelParaStyle {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = [EaseChatroomMessageCell lineSpacing];
    return paraStyle;
}

+ (CGFloat)lineSpacing{
    return 4.0f;
}

+ (UIFont *)contentFont {
    return EaseKitBFont(14.0);
}


#pragma mark getter and setter
- (UIImageView *)roleImageView {
    if (_roleImageView == nil) {
        _roleImageView = [[UIImageView alloc] init];
        _roleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _roleImageView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [EaseChatroomMessageCell contentFont];
        _messageLabel.textColor = UIColor.whiteColor;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.preferredMaxLayoutWidth = EaseKitScreenWidth -kIconImageViewHeight -EaseKitPadding *3;
    }
    return _messageLabel;
}


- (void)setMessageLabelSize:(CGFloat)messageLabelSize {
    self.messageLabel.font = EaseKitNFont(messageLabelSize);
}

- (void)setMessageLabelColor:(UIColor *)messageLabelColor {
    self.messageLabel.textColor = messageLabelColor;
}


@end

#undef kIconImageViewHeight

#undef kCellVPadding

#undef kContentLabelMaxWidth

#undef kNameLabelHeight
