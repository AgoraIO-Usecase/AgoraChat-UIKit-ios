//
//  ForwardMessagesViewController.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/28.
//

#import <UIKit/UIKit.h>
#import "EaseUserProfile.h"
@class AgoraChatMessage;

NS_ASSUME_NONNULL_BEGIN

@interface ForwardMessagesViewController : UIViewController

- (instancetype)initWithMessage:(AgoraChatMessage *)message userProfiles:(NSMutableArray <id<EaseUserProfile>>*)profiles;

@end

NS_ASSUME_NONNULL_END
