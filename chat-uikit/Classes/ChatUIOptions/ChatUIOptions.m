//
//  ChatUIOptions.m
//  AgoraChatCallKit
//
//  Created by 冯钊 on 2022/4/19.
//

#import "ChatUIOptions.h"

@implementation ChatUIOptions

static ChatUIOptions *shareOptions = nil;

+ (instancetype)shareOptions {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareOptions = [ChatUIOptions new];
    });
    return shareOptions;
}

- (instancetype)init
{
    if (self = [super init]) {
        _reactionOptions = [[ChatUIReactionOptions alloc] init];
    }
    return self;
}

@end
