//
//  EaseConversationModel.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/10.
//

#import "EaseUserProfile.h"
#import <UIKit/UIKit.h>
#import "EasePublicHeaders.h"
NS_ASSUME_NONNULL_BEGIN

@interface EaseConversationModel : NSObject

- (instancetype)initWithConversation:(AgoraChatConversation *)conversation;

@property (nonatomic) id<EaseUserProfile> userProfile;

@property (nonatomic, strong, readonly) NSString *easeId;
@property (nonatomic, strong, readonly) NSString *showName;
@property (nonatomic, strong, readonly) NSString *avatarURL;
@property (nonatomic, strong, readonly) UIImage *defaultAvatar;

@property (nonatomic, readonly) AgoraChatConversationType type; //chat type
@property (nonatomic, readonly) int unreadMessagesCount; //message unread
@property (nonatomic, readonly) long long lastestUpdateTime;
@property (nonatomic, readonly) BOOL remindMe;

@property (nonatomic) BOOL isNoDistrub;
@property (nonatomic) BOOL isTop;
@property (nonatomic, copy, readonly) NSAttributedString *showInfo; // conversaion latest message info
//@property (nonatomic, copy) NSString *draft;

@end

NS_ASSUME_NONNULL_END
