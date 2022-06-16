//
//  EaseConversationAvatarParam.m
//  chat-uikit
//
//  Created by zhangchong on 2022/6/16.
//

#import "EaseConversationAvatarParam.h"

@implementation EaseConversationAvatarParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setupPropertyDefault];
    }
    
    return self;
}

- (instancetype)initWithParams:(EaseChatAvatarStyle)aAvatarStyle
                        radius:(CGFloat)cornerRadius
{
    self = [super init];
    if (self) {
        _avatarType = aAvatarStyle;
        _avatarCornerRadius = cornerRadius >= 0 ? cornerRadius : 0;
    }
    
    return self;
}

- (void)_setupPropertyDefault
{
    _avatarType = Circular;
    _avatarCornerRadius = 5;
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius
{
    if (avatarCornerRadius >= 0) {
        _avatarCornerRadius = avatarCornerRadius;
    }
}

@end
