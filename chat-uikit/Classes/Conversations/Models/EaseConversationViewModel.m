//
//  EaseConversationViewModel.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/12.
//

#import "EaseConversationViewModel.h"
#import "EaseHeaders.h"
#import "UIImage+EaseUI.h"
#import "Easeonry.h"

@implementation EaseConversationViewModel
@synthesize bgView = _bgView;
@synthesize cellBgColor = _cellBgColor;
@synthesize conversationTopBgColor = _conversationTopBgColor;
@synthesize cellSeparatorInset = _cellSeparatorInset;
@synthesize cellSeparatorColor = _cellSeparatorColor;
@synthesize canRefresh = _canRefresh;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupPropertyDefault];
    }
    
    return self;
}


- (void)_setupPropertyDefault {

    _displayChatroom = NO;
    _canRefresh = NO;
    _avatarSize = CGSizeMake(58, 58);
    _groupAvatarStyle = [[EaseConversationAvatarParam alloc]initWithParams:RoundedCorner radius:1];
    _chatroomAvatarStyle = [[EaseConversationAvatarParam alloc]init];
    _chatAvatarStyle = [[EaseConversationAvatarParam alloc]init];
    _avatarEdgeInsets = UIEdgeInsetsMake(7, 16, -7, 0);
    [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    _nameLabelFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
    _nameLabelColor = [UIColor colorWithHexString:@"#0D0D0D"];
    _nameLabelEdgeInsets = UIEdgeInsetsMake(14, 11, 0, 0);
    
    _detailLabelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _detailLabelColor = [UIColor colorWithHexString:@"#666666"];;
    _detailLabelEdgeInsets = UIEdgeInsetsMake(0, 11, -16, -48);
    
    _timeLabelFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _timeLabelColor = [UIColor colorWithHexString:@"#666666"];;
    _timeLabelEdgeInsets = UIEdgeInsetsMake(16, 0, 8, -16);
    
    _needsDisplayBadge = YES;
    _badgeViewStyle = EaseUnreadBadgeViewNumber;
    _badgeLabelFont = [UIFont fontWithName:@"PingFang SC" size:12.0];
    _badgeLabelHeight = 16;
    _badgeLabelRedDotHeight = 14;
    _badgeLabelBgColor = [UIColor colorWithHexString:@"#FF14CC"];
    _badgeLabelTitleColor = UIColor.whiteColor;
    _badgeLabelPosition = EaseCellRight;
    _badgeLabelCenterVector = CGVectorMake(-8.5, 8.5);
    _badgeMaxNum = 99;
    
    _conversationTopStyle = EaseConversationTopIconStyle;
    _conversationTopIcon = [UIImage easeUIImageNamed:@"sticky"];
    _conversationTopIconInsets = UIEdgeInsetsMake(4, 0, 0, -4);
    _conversationTopIconSize = CGSizeMake(14, 14);
    _conversationTopBgColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _cellBgColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    _cellSeparatorInset = UIEdgeInsetsMake(1, 77, 0, 0);
    _cellSeparatorColor = [UIColor colorWithHexString:@"#F3F3F3"];
    
    _bgView = [self defaultBgView];
    
    _noDisturbImg = [UIImage easeUIImageNamed:@"noDisturb"];
    _noDisturbImgInsets = UIEdgeInsetsMake(19, 4, 3, 0);
    _noDisturbImgSize = CGSizeMake(14, 14);
    
}

- (UIView *)defaultBgView {
    UIView *defaultBgView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage easeUIImageNamed:@"noChats"]];
    [defaultBgView addSubview:imageView];
    [imageView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.center.equalTo(defaultBgView);
        make.width.Ease_equalTo(150);
        make.height.Ease_equalTo(150);
    }];
    
    return defaultBgView;
}

@end
