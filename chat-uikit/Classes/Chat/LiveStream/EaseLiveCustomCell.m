//
//  EaseLiveCustomCell.m
//  chat-uikit
//
//  Created by liu001 on 2022/5/12.
//

#import "EaseLiveCustomCell.h"
#import "EaseUserInfoManagerHelper.h"
#import "UIImageView+EaseWebCache.h"


@interface EaseLiveCustomCell ()
@property (nonatomic, strong) UIView* bottomLine;
@property (nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) AgoraChatUserInfo *userInfo;

@end

@implementation EaseLiveCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepare];
        [self placeSubViews];
    }
    return self;
}

- (void)tapAction {
    if (self.tapCellBlock) {
        self.tapCellBlock();
    }
}

- (void)prepare {

}

- (void)placeSubViews {
    
}

- (void)updateWithObj:(id)obj {
    
}


- (void)fetchUserInfoWithUserId:(NSString *)userId {
    [EaseUserInfoManagerHelper fetchUserInfoWithUserIds:@[userId] completion:^(NSDictionary * _Nonnull userInfoDic) {
        self.userInfo = [userInfoDic objectForKey:userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.avatarImageView Ease_setImageWithURL:[NSURL URLWithString:self.userInfo.avatarUrl] placeholderImage:EaseKitImageWithName(@"")];
            self.nameLabel.text = self.userInfo.nickName ?:self.userInfo.userId;
        });
    }];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}


+ (CGFloat)height {
    return 54.0f;
}


#pragma mark getter and setter
- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.layer.cornerRadius = EaseAvatarHeight * 0.5;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
//        PingFangSC-Semibold
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0f];
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    }
    return _nameLabel;
}


- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = EaseKitCOLOR_HEX(0x333333);
    }
    return _bottomLine;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        _tapGestureRecognizer.numberOfTapsRequired = 1;
    }
    return _tapGestureRecognizer;
}


- (void)setCellBgColor:(UIColor *)cellBgColor {
    self.contentView.backgroundColor = cellBgColor;
}


- (void)setNameLabelFontSize:(CGFloat)nameLabelFontSize {
    self.nameLabel.font = EaseKitNFont(nameLabelFontSize);
}

- (void)setNameLabelColor:(UIColor *)nameLabelColor {
    self.nameLabel.textColor = nameLabelColor;
}


@end

#undef EaseAvatarHeight
