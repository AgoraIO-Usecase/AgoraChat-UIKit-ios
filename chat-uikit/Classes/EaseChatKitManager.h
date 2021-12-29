//
//  EaseChatKitManager.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/10/29.
//

#import <Foundation/Foundation.h>
#import "EasePublicHeaders.h"

NS_ASSUME_NONNULL_BEGIN

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

+ (BOOL)initWithAgoraChatOptions:(AgoraChatOptions *)options;
+ (EaseChatKitManager *)shared;
+ (NSString *)EaseChatKitVersion;
- (void)addDelegate:(id<EaseChatKitManagerDelegate>)aDelegate;
- (void)removeDelegate:(id<EaseChatKitManagerDelegate>)aDelegate;

- (void)markAllMessagesAsReadWithConversation:(AgoraChatConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
