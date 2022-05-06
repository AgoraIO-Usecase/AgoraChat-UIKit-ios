//
//  EaseChatKitManager.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/10/29.
//

#import <Foundation/Foundation.h>
#import "EasePublicHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EaseChatKitManagerGeneralDelegate <NSObject>

@optional

/// 默认的用户头像
@property (nonatomic, strong, readonly) UIImage *defaultAvatar;

/// 获取用户详情
/// @param userId 用户信息
/// @param result 获取到用户详情，需要用这个回调把详情传递给sdk
- (void)getUserInfo:(NSString *)userId result:(void(^)(AgoraChatUserInfo *))result;

@end

@protocol EaseChatKitManagerDelegate <NSObject>
@optional

/**
 * The total number of unread sessions changes
 *
 * @param   unreadCount     Total unread of the current session list
 */
- (void)conversationsUnreadCountUpdate:(NSInteger)unreadCount;

@end


@interface EaseChatKitManager : NSObject

@property (nonatomic, strong, readonly) NSString *version; //UIKit version
@property (nonatomic, weak) id<EaseChatKitManagerGeneralDelegate>generalDelegate; //通用回调代理

+ (BOOL)initWithAgoraChatOptions:(AgoraChatOptions *)options;
+ (EaseChatKitManager *)shared;
+ (NSString *)EaseChatKitVersion;
- (void)addDelegate:(id<EaseChatKitManagerDelegate>)aDelegate;
- (void)removeDelegate:(id<EaseChatKitManagerDelegate>)aDelegate;

- (void)markAllMessagesAsReadWithConversation:(AgoraChatConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
