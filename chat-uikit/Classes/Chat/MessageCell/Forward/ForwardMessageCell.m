//
//  ForwardMessageCell.m
//  AgoraChatCallKit
//
//  Created by 朱继超 on 2023/7/27.
//

#import "ForwardMessageCell.h"
#import "UIImageView+EaseWebCache.h"
#import "EMAudioPlayerUtil.h"
#import "UIImage+EaseUI.h"

@implementation ForwardMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.containerView];
        [self.contentView addSubview:self.contentLabel];
        self.containerView.hidden = YES;
    }
    return self;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 16, 28, 28)];
        _avatarView.layer.cornerRadius = 14;
        _avatarView.clipsToBounds = YES;
        _avatarView.image = [UIImage easeUIImageNamed:@"default_avatar"];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, 16, CGRectGetWidth(self.contentView.frame)-CGRectGetMaxX(self.avatarView.frame)-124, 14)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    }
    return _nameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)-112, 16, 96, 14)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        _dateLabel.textAlignment = 2;
    }
    return _dateLabel;
}

- (ForwardContainer *)containerView {
    if (!_containerView) {
        _containerView = [[ForwardContainer alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.nameLabel.frame)+5, CGRectGetWidth(self.contentView.frame)-72, 40)];
    }
    return _containerView;
}


- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.containerView.frame)+5, CGRectGetWidth(self.contentView.frame)-72, 16)];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    }
    return _contentLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)-112, 16, 96, 14);
}

- (void)setModel:(ForwardModel *)model {
    _model = model;
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(showName)] && model.userDataProfile.showName) {
        self.nameLabel.text = model.userDataProfile.showName;
    } else {
        self.nameLabel.text = model.message.from;
    }
    
    
    NSString *defaultName = @"_another_style";
    if (model.message.chatType == AgoraChatTypeGroupChat) {
        defaultName = [NSString stringWithFormat:@"group%@",defaultName];
    } else {
        defaultName = [NSString stringWithFormat:@"avatar%@",defaultName];
    }
    _avatarView.image = [UIImage easeUIImageNamed:defaultName];
    if (_model.userDataProfile && [_model.userDataProfile respondsToSelector:@selector(avatarURL)]) {
        if ([_model.userDataProfile.avatarURL length] > 0) {
            [_avatarView Ease_setImageWithURL:[NSURL URLWithString:_model.userDataProfile.avatarURL]
                               placeholderImage:[UIImage easeUIImageNamed:defaultName]];
        }
    }
    self.dateLabel.text = model.date;
    [self updateLayout];
}

- (void)updateLayout {
    if (self.model.message.body.type == AgoraChatMessageBodyTypeFile || self.model.message.body.type == AgoraChatMessageBodyTypeVoice || self.model.message.body.type == AgoraChatMessageBodyTypeCombine) {
        self.containerView.hidden = NO;
        
        UIImage *image;
        NSString *text;
        if (self.model.message.body.type == AgoraChatMessageBodyTypeFile) {
            image = [UIImage easeUIImageNamed:@"forward_file"];
            text = ((AgoraChatFileMessageBody *)self.model.message.body).displayName;
        }
        if (self.model.message.body.type == AgoraChatMessageBodyTypeVoice) {
            image = [UIImage easeUIImageNamed:@"msg_recv_audio"];
            text = [NSString stringWithFormat:@"%d”",((AgoraChatVoiceMessageBody *)self.model.message.body).duration];
        }
        if (self.model.message.body.type != AgoraChatMessageBodyTypeCombine) {
            self.containerView.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.nameLabel.frame)+5, EMScreenWidth-72, 40);
            self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.containerView.frame)+5, EMScreenWidth-72, self.model.contentHeight-CGRectGetMaxY(self.containerView.frame)-5);
            [self.containerView updateContent:text image:image];
            self.contentLabel.attributedText = self.model.contentAttributeText;
        } else {
            [self.containerView stopAnimation];
            self.containerView.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.nameLabel.frame)+5, EMScreenWidth-72, self.model.contentHeight-15-CGRectGetMinY(self.nameLabel.frame));
            self.contentLabel.frame = CGRectZero;
            [self.containerView updateAttribute:self.model.contentAttributeText];
            self.contentLabel.attributedText = nil;
        }
    } else {
        [self.containerView stopAnimation];
        self.containerView.hidden = YES;
        self.containerView.frame = CGRectZero;
        self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame)+12, CGRectGetMaxY(self.nameLabel.frame)+5, EMScreenWidth-72, self.model.contentHeight-CGRectGetMaxY(self.nameLabel.frame)-5);
        self.contentLabel.attributedText = self.model.contentAttributeText;
    }
}

- (void)startVoiceAnimation {
    if (_model.message.body.type == AgoraChatMessageBodyTypeVoice) {
        if (_model.isPlaying) {
            [self.containerView starAnimation:@[[UIImage easeUIImageNamed:@"msg_recv_audio02"], [UIImage easeUIImageNamed:@"msg_recv_audio01"], [UIImage easeUIImageNamed:@"msg_recv_audio"]]];
        } else {
            [self.containerView stopAnimation];
        }
    } else {
        [self.containerView stopAnimation];
    }
}

- (void)stopVoiceAnimation {
    [self.containerView stopAnimation];
}

    
@end
