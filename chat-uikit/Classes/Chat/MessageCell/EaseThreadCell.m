//
//  AgoraChatThreadCell.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/13.
//

#import "EaseThreadCell.h"
#import "UIColor+EaseUI.h"
#import "EMTimeConvertUtils.h"
#import "UIImage+EaseUI.h"
#import "UIImageView+EaseWebCache.h"
#import "EaseHeaders.h"
#import "EaseEmojiHelper.h"
@interface EaseThreadCell ()

@property (nonatomic, strong) UILabel *threadName;

@property (nonatomic, strong) UIImageView *muteState;

@property (nonatomic, strong) UIImageView *ownerAvatar;

@property (nonatomic, strong) UILabel *ownerName;

@property (nonatomic, strong) UILabel *duration;

@end

@implementation EaseThreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.threadName];
        [self.contentView addSubview:self.muteState];
        [self.contentView addSubview:self.ownerAvatar];
        [self.contentView addSubview:self.ownerName];
        [self.contentView addSubview:self.duration];
    }
    return self;
}

- (UILabel *)threadName {
    if (!_threadName) {
        _threadName = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, EMScreenWidth-50, 20)];
        _threadName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _threadName.textColor = [UIColor colorWithHexString:@"#0D0D0D"];
    }
    return _threadName;
}

- (UIImageView *)muteState {
    if (!_muteState) {
        _muteState = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.threadName.frame), CGRectGetMinY(self.threadName.frame), 14, 14)];
        _muteState.center = CGPointMake(_muteState.center.x, _threadName.center.y);
        _muteState.image = [UIImage imageNamed:@"noDisturb"];
        _muteState.hidden = YES;
    }
    return _muteState;
}

- (UIImageView *)ownerAvatar {
    if (!_ownerAvatar) {
        _ownerAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(self.threadName.frame)+6, 16, 16)];
        _ownerAvatar.image = [UIImage imageNamed:@""];
    }
    return _ownerAvatar;
}

- (UILabel *)ownerName {
    if (!_ownerName) {
        _ownerName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ownerAvatar.frame)+8, CGRectGetMaxY(self.threadName.frame)+4, EMScreenWidth-125, 15)];
//        _ownerName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//        _ownerName.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _ownerName;
}

- (UILabel *)duration {
    if (!_duration) {
        _duration = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ownerName.frame)+8, CGRectGetMaxY(self.threadName.frame)+5, 60, 20)];
        _duration.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _duration.textColor = [UIColor colorWithHexString:@"#999999"];
        _duration.textAlignment = NSTextAlignmentRight;
    }
    return _duration;
}

- (void)setModel:(EaseThreadConversation *)model {
    _threadName.text = model.threadInfo.threadName;
    _muteState.image = [UIImage easeUIImageNamed:@"noDisturb"];
    if (model.lastMessage.timestamp > 0) {
        _duration.text = [EMTimeConvertUtils durationString:model.lastMessage.timestamp];
    }
    
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(showName)] && model.userDataProfile.showName) {
        NSString *showName = @"";
        if (model.userDataProfile.showName && model.userDataProfile.showName.length) {
            showName = model.userDataProfile.showName;
        }
        if (model.lastMessage.body.type == 1) {
            AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)model.lastMessage.body;
            self.ownerName.attributedText = [self attributeText:[NSString stringWithFormat:@"%@,%@",showName,[EaseEmojiHelper convertEmoji:body.text]] colorText:showName];
        } else {
            self.ownerName.attributedText = [self attributeText:[NSString stringWithFormat:@"%@,%@",showName,[self convertType:model.lastMessage.body.type]] colorText:showName];
        }
    } else {
        NSString *from = @"";
        if (model.lastMessage.body.type == 1) {
            AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)model.lastMessage.body;
            if (from || from.length > 0) {
                from = model.lastMessage.from;
            }
            self.ownerName.attributedText = [self attributeText:[NSString stringWithFormat:@"%@,%@",from,[EaseEmojiHelper convertEmoji:body.text]] colorText:from];
        } else {
            self.ownerName.attributedText = [self attributeText:[NSString stringWithFormat:@"%@,%@",from,[self convertType:model.lastMessage.body.type]] colorText:from];
        }
    }
    
    BOOL isCustomAvatar = NO;
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(defaultAvatar)]) {
        if (model.userDataProfile.defaultAvatar) {
            _ownerAvatar.image = model.userDataProfile.defaultAvatar;
            isCustomAvatar = YES;
        }
    }
    if (_model.userDataProfile && [_model.userDataProfile respondsToSelector:@selector(avatarURL)]) {
        if ([_model.userDataProfile.avatarURL length] > 0) {
            [_ownerAvatar Ease_setImageWithURL:[NSURL URLWithString:_model.userDataProfile.avatarURL]
                               placeholderImage:[UIImage easeUIImageNamed:@"default_avatar"]];
            isCustomAvatar = YES;
        }
    }
    if (!isCustomAvatar) {
        _ownerAvatar.image = [UIImage easeUIImageNamed:@"default_avatar"];
    }
}

- (NSAttributedString *)attributeText:(NSString *)text colorText:(NSString *)colorText {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, text.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, colorText.length)];
    return string;
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


@end
