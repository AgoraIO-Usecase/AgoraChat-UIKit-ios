//
//  EaseChatViewCustomOption.m
//  chat-uikit
//
//  Created by liu001 on 2022/5/18.
//

#import "EaseChatViewCustomOption.h"

@implementation EaseChatViewCustomOption

static EaseChatViewCustomOption *instance = nil;
+ (EaseChatViewCustomOption *)customOption {
   static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[EaseChatViewCustomOption alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isShowAvatar = YES;
    }
    return self;
}


@end
