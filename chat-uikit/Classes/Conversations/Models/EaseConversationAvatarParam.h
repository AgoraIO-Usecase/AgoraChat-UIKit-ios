//
//  EaseConversationAvatarParam.h
//  chat-uikit
//
//  Created by zhangchong on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EaseChatEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseConversationAvatarParam : NSObject

// avatar style
@property (nonatomic) EaseChatAvatarStyle avatarType;

// avatar cornerRadius
@property (nonatomic) CGFloat avatarCornerRadius;

- (instancetype)initWithParams:(EaseChatAvatarStyle)aAvatarStyle
                        radius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
