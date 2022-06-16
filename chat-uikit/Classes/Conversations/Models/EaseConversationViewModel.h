//
//  EaseConversationViewModel.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import "EaseBaseTableViewModel.h"
#import "EaseChatEnums.h"
#import "EaseConversationAvatarParam.h"


NS_ASSUME_NONNULL_BEGIN

@interface EaseConversationViewModel : EaseBaseTableViewModel

// display chatroom
@property (nonatomic) BOOL displayChatroom;

// avatar size
@property (nonatomic) CGSize avatarSize;

// group conversation avatar style
@property (nonatomic, strong) EaseConversationAvatarParam *groupAvatarStyle;

// chatroom conversation avatar style
@property (nonatomic, strong) EaseConversationAvatarParam *chatroomAvatarStyle;

// single chat conversation avatar style
@property (nonatomic, strong) EaseConversationAvatarParam *chatAvatarStyle;

// avatar location
@property (nonatomic) UIEdgeInsets avatarEdgeInsets;

// conversation top style
@property (nonatomic) EaseChatConversationTopStyle conversationTopStyle;

// conversation top bgColor
@property (nonatomic, strong) UIColor *conversationTopBgColor;

// conversation top icon
@property (nonatomic, strong) UIImage *conversationTopIcon;

// top icon location
@property (nonatomic) UIEdgeInsets conversationTopIconInsets;

// top icon size
@property (nonatomic) CGSize conversationTopIconSize;

// nickname font
@property (nonatomic, strong) UIFont *nameLabelFont;

// nickname color
@property (nonatomic, strong) UIColor *nameLabelColor;

// nickname location
@property (nonatomic) UIEdgeInsets nameLabelEdgeInsets;

// message detail font
@property (nonatomic, strong) UIFont *detailLabelFont;

// message detail text font
@property (nonatomic, strong) UIColor *detailLabelColor;

// message detail location
@property (nonatomic) UIEdgeInsets detailLabelEdgeInsets;

// message time font
@property (nonatomic, strong) UIFont *timeLabelFont;

// message time color
@property (nonatomic, strong) UIColor *timeLabelColor;

// message time location
@property (nonatomic) UIEdgeInsets timeLabelEdgeInsets;

// needs displayed Unread messages number
@property (nonatomic) BOOL needsDisplayBadge;

// message unread position
@property (nonatomic) EaseChatUnReadCountViewPosition badgeLabelPosition;

// message unread style
@property (nonatomic) EaseChatUnReadBadgeViewStyle badgeViewStyle;

// message unread font
@property (nonatomic, strong) UIFont *badgeLabelFont;

// message unread text color
@property (nonatomic, strong) UIColor *badgeLabelTitleColor;

// message unread bgColor
@property (nonatomic, strong) UIColor *badgeLabelBgColor;

// message unread angle height
@property (nonatomic) CGFloat badgeLabelHeight;

// message unread red dot height
@property (nonatomic) CGFloat badgeLabelRedDotHeight;

// message unread center position deviation
@property (nonatomic) CGVector badgeLabelCenterVector;

// message unread display limit, display after the upper limit is exceeded xx+
@property (nonatomic) int badgeMaxNum;

// no disturb image
@property (nonatomic, strong) UIImage *noDisturbImg;

// no disturb image location
@property (nonatomic) UIEdgeInsets noDisturbImgInsets;

// no disturb image size
@property (nonatomic) CGSize noDisturbImgSize;

@end

NS_ASSUME_NONNULL_END
