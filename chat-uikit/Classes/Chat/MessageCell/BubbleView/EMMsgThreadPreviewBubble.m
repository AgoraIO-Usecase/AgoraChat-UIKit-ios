//
//  EMMsgThreadPreviewBubble.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/14.
//

#import "EMMsgThreadPreviewBubble.h"
#import "EaseEmojiHelper.h"
#import "UIImage+EaseUI.h"
#import "UIColor+EaseUI.h"
#import "UIImageView+EaseWebCache.h"
#import "Easeonry.h"
#import "EMTimeConvertUtils.h"
@interface EMMsgThreadPreviewBubble ()
{
    EaseChatViewModel *_viewModel;
}

@end

@implementation EMMsgThreadPreviewBubble

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushThread)];
//        self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage easeUIImageNamed:@"groupThread"];
    }
    return _icon;
}

- (void)iconLayout {
    [_icon Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self).offset(14);
        make.width.height.Ease_equalTo(20);
    }];
}

- (UILabel *)threadName {
    if (!_threadName) {
        _threadName = [UILabel new];
        _threadName.font = [UIFont boldSystemFontOfSize:14];
    }
    return _threadName;
}

- (void)threadNameLayout {
    [_threadName Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.icon.ease_right).offset(4);
        make.top.equalTo(self.icon);
        make.right.equalTo(self).offset(-57);
        make.height.Ease_equalTo(20);
    }];
}

- (UIButton *)messageBadge {
    if (!_messageBadge) {
        _messageBadge = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBadge setImage:[UIImage easeUIImageNamed:@"go_blue"] forState:UIControlStateNormal];
        _messageBadge.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_messageBadge setTitleColor:[UIColor colorWithHexString:@"#154DFE"] forState:UIControlStateNormal];
        _messageBadge.enabled = NO;
        _messageBadge.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        _messageBadge.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _messageBadge.userInteractionEnabled = NO;
    }
    return _messageBadge;
}

- (void)messageBadgeLayout {
    [_messageBadge Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.threadName);
        make.height.Ease_equalTo(20);
        make.width.Ease_equalTo(45);
    }];
}

//- (void)pushThread {
//    if (self.threadBubbleBlock) {
//        self.threadBubbleBlock();
//    }
//}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc]initWithImage:[UIImage easeUIImageNamed:@"default_avatar"]];
    }
    return _avatar;
}

- (void)avatarLayout {
    [self.avatar Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.icon.ease_bottom).offset(8);
        make.width.height.Ease_equalTo(14);
    }];
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    return _userName;
}

- (void)userNameLayout {
    [self.userName Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-77);
        make.top.equalTo(self.avatar);
        make.height.Ease_equalTo(15);
    }];
}

- (UILabel *)messageContent {
    if (!_messageContent) {
        _messageContent = [UILabel new];
        _messageContent.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _messageContent.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    }
    return _messageContent;
}

- (void)messageContentLayout {
    [self.messageContent Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.top.equalTo(self.userName.ease_bottom).offset(8);
        make.right.equalTo(self).offset(-58);
        make.height.Ease_equalTo(20);
    }];
}

- (UILabel *)updateTime {
    if (!_updateTime) {
        _updateTime = [UILabel new];
        _updateTime.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _updateTime.textColor = [UIColor colorWithHexString:@"#999999"];
        _updateTime.textAlignment = NSTextAlignmentRight;
    }
    return _updateTime;
}

- (void)updateTimeLayout {
    [self.updateTime Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.avatar);
        make.right.equalTo(self).offset(-8);
        make.height.Ease_equalTo(16);
        make.width.Ease_equalTo(60);
    }];
}

#pragma mark - Subviews

- (void)_setupSubviews {
    [self setupThreadBubbleBackgroundImage];
    [self addSubview:self.icon];
    [self addSubview:self.threadName];
    [self addSubview:self.messageBadge];
    [self addSubview:self.avatar];
    [self addSubview:self.userName];
    [self addSubview:self.messageContent];
    [self addSubview:self.updateTime];
    [self iconLayout];
    [self threadNameLayout];
    [self messageBadgeLayout];
    [self avatarLayout];
    [self userNameLayout];
    [self messageContentLayout];
    [self updateTimeLayout];
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model {
//    if (model == nil) {
//        return;
//    }
    [super setModel:model];
    self.threadName.text = model.message.chatThread.threadName;
    self.updateTime.text = [EMTimeConvertUtils durationString:model.message.chatThread.lastMessage.timestamp];
    BOOL isCustomAvatar = NO;
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(defaultAvatar)]) {
        if (model.userDataProfile.defaultAvatar) {
            _avatar.image = model.userDataProfile.defaultAvatar;
            isCustomAvatar = YES;
        }
    }
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(avatarURL)]) {
        if ([model.userDataProfile.avatarURL length] > 0) {
            [_avatar Ease_setImageWithURL:[NSURL URLWithString:model.userDataProfile.avatarURL]
                               placeholderImage:[UIImage easeUIImageNamed:@"default_avatar"]];
            isCustomAvatar = YES;
        }
    }
    [self.messageBadge setTitle:[self convertMessageCount:model.message.chatThread.messageCount] forState:UIControlStateNormal];
    if (!isCustomAvatar) {
        _avatar.image = [UIImage easeUIImageNamed:@"default_avatar"];
    }
    if (model.message.chatThread.lastMessage.body.type == AgoraChatMessageBodyTypeText) {
        NSString *text = [((AgoraChatTextMessageBody *)model.message.chatThread.lastMessage.body) text];
        if (!text) {
            text = @"";
        }
        self.messageContent.text = text;
    } else {
        self.messageContent.text = [self convertType:model.message.chatThread.lastMessage.body.type];
    }
    if (model.threadUserProfile && [model.threadUserProfile respondsToSelector:@selector(showName)] && model.threadUserProfile.showName) {
        self.userName.text = model.threadUserProfile.showName;
    } else {
        self.userName.text = model.message.chatThread.lastMessage.from;
    }
    
    if (model.message.chatThread.lastMessage.messageId == nil || [model.message.chatThread.lastMessage.messageId isEqualToString:@""]) {
        self.messageContent.text = @"No Message";
        self.avatar.hidden = YES;
        _messageContent.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _messageContent.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.messageContent Ease_updateConstraints:^(EaseConstraintMaker *make) { make.left.equalTo(self).offset(10);
            make.top.equalTo(self.userName).offset(10);
        }];
    } else {
        self.avatar.hidden = NO;
        [self.messageContent Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(self.avatar);
            make.top.equalTo(self.userName.ease_bottom).offset(8);
            make.right.equalTo(self).offset(-58);
            make.height.Ease_equalTo(20);
        }];
        _messageContent.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _messageContent.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    }
}

- (NSString *)convertMessageCount:(int)messageCount {
    NSString *text = [NSString stringWithFormat:@"%d",messageCount];
    if (messageCount > 99) {
        text = @"99+";
    }
    return text;
}

- (NSString *)convertType:(int)contentType {
    NSString *type = @"[unknown type]";
    switch (contentType) {
        case 2:
        {
            type = @"[Image]";
        }
            break;
        case 3:
        {
            type = @"[Video]";
        }
            break;
        case 5:
        {
            type = @"[Voice]";
        }
            break;
        case 6:
        {
            type = @"[File]";
        }
            break;
        default:
            break;
    }
    return type;
}

- (void)setupThreadBubbleBackgroundImage {
    UIEdgeInsets edge = UIEdgeInsetsMake(8, 8, 8, 8);
    UIImage *image = [_viewModel.threadBubbleBgImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [self setImage:image];
}


@end
