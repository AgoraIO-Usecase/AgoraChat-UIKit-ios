//
//  EaseMessageModel.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/18.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseMessageModel.h"
#import "EaseHeaders.h"
#import "EaseMessageCell.h"
#import "EaseMessageCell+Category.h"
#import <AgoraChat/NSObject+Coding.h>

@implementation EaseMessageModel

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)aMsg
{
    self = [super init];
    if (self) {
        _message = aMsg;
        _direction = aMsg.direction;
        _type = (AgoraChatMessageType)aMsg.body.type;
        if (aMsg.body.type == AgoraChatMessageBodyTypeText) {
            if ([aMsg.ext objectForKey:MSG_EXT_GIF]) {
                _type = AgoraChatMessageTypeExtGif;
                return self;
            }
            if ([aMsg.ext objectForKey:MSG_EXT_RECALL]) {
                _type = AgoraChatMessageTypeExtRecall;
                return self;
            }
            if ([[aMsg.ext objectForKey:MSG_EXT_NEWNOTI] isEqualToString:NOTI_EXT_ADDFRIEND]) {
                _type = AgoraChatMessageTypeExtNewFriend;
                return self;
            }
            if ([[aMsg.ext objectForKey:MSG_EXT_NEWNOTI] isEqualToString:NOTI_EXT_ADDGROUP]) {
                _type = AgoraChatMessageTypeExtAddGroup;
                return self;
            }
            
            NSString *conferenceId = [aMsg.ext objectForKey:@"conferenceId"];
            if ([conferenceId length] == 0)
                conferenceId = [aMsg.ext objectForKey:MSG_EXT_CALLID];
            if ([conferenceId length] > 0) {
                _type = AgoraChatMessageTypeExtCall;
                return self;
            }
            
            NSString *text = ((AgoraChatTextMessageBody *)aMsg.body).text;
            NSDataDetector *detector= [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
            NSArray *checkArr = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
            if (checkArr.count == 1) {
                NSTextCheckingResult *result = checkArr.firstObject;
                NSString *urlStr = result.URL.absoluteString;
                NSRange range = [text rangeOfString:urlStr options:NSCaseInsensitiveSearch];
                if (range.length > 0) {
                    _type = AgoraChatMessageTypeExtURLPreview;
                    return self;
                }
            }
            _type = AgoraChatMessageTypeText;
        }
    }

    return self;
}

- (void)setMessage:(AgoraChatMessage *)message {
    _message = message;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self ease_copyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self ease_mutableCopyWithZone:zone];
}

@end
