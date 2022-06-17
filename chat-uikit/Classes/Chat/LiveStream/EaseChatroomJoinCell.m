//
//  ELDChatJoinCell.m
//  EaseMobLiveDemo
//
//  Created by liu001 on 2022/4/20.
//  Copyright © 2022 zmw. All rights reserved.
//

#import "EaseChatroomJoinCell.h"
#import "UIImageView+EaseWebCache.h"

#define kBgViewVPadding  7.0
#define kBgViewHPadding  8.0

@interface EaseChatroomJoinCell ()
@property (nonatomic, strong) UIImageView *joinImageView;
@property (nonatomic, strong) UILabel *joinLabel;
@property (nonatomic, strong) AgoraChatUserInfo *userInfo;

@end


@implementation EaseChatroomJoinCell

- (void)prepare {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addGestureRecognizer:self.tapGestureRecognizer];

    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.joinLabel];
    [self.contentView addSubview:self.joinImageView];
}


- (void)placeSubViews {
    [self.avatarImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.0f);
        make.size.Ease_equalTo(EaseAvatarHeight);
    }];
    
    [self.bgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.ease_top).offset(-kBgViewVPadding);
        make.left.equalTo(self.avatarImageView.ease_right).offset(kBgViewHPadding);
        make.right.equalTo(self.joinImageView.ease_right).offset(kBgViewHPadding);
        make.bottom.equalTo(self.nameLabel.ease_bottom).offset(kBgViewVPadding);
    }];
    
    [self.nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.ease_right).offset(16.0);
        make.width.lessThanOrEqualTo(@100);
    }];
    
    
    [self.joinLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.nameLabel.ease_right).offset(5.0);
    }];
    
    [self.joinImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImageView);
        make.left.equalTo(self.joinLabel.ease_right).offset(2.0);
    }];
    
    if (self.customOption.cellBgColor) {
        self.bgView.backgroundColor = self.customOption.cellBgColor;
    }

    if (self.customOption.nameLabelColor) {
        self.nameLabel.textColor = self.customOption.nameLabelColor;
    }
    
    if (self.customOption.nameLabelFontSize) {
        self.nameLabel.font = EaseKitNFont(self.customOption.nameLabelFontSize);
    }
    
}

- (void)updateWithObj:(id)obj {
    AgoraChatMessage *message = (AgoraChatMessage *)obj;
    EaseKit_WS
    [self fetchUserInfoWithUserId:message.from completion:^(NSDictionary * _Nonnull userInfoDic) {
        
        EaseKit_SS(weakSelf)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            strongSelf.userInfo = [userInfoDic objectForKey:message.from];
            [strongSelf.avatarImageView Ease_setImageWithURL:[NSURL URLWithString:self.userInfo.avatarUrl] placeholderImage:[UIImage easeUIImageNamed:@"default_avatar"]];
            strongSelf.nameLabel.text = self.userInfo.nickName ?:self.userInfo.userId;
        });

    }];
}



#pragma mark getter and setter
- (UIImageView *)joinImageView {
    if (_joinImageView == nil) {
        _joinImageView = [[UIImageView alloc] init];
        _joinImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_joinImageView setImage:[UIImage easeUIImageNamed:@"live_join"]];
    }
    return _joinImageView;
}

- (UILabel *)joinLabel {
    if (_joinLabel == nil) {
        _joinLabel = [[UILabel alloc] init];
        _joinLabel.font = EaseKitNFont(12.0);
        _joinLabel.textColor = UIColor.whiteColor;
        _joinLabel.textAlignment = NSTextAlignmentLeft;
        _joinLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _joinLabel.text = @"Joined";
    }
    return _joinLabel;
}


@end

#undef kBgViewVPadding
#undef kBgViewHPadding
