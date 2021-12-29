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
            _type = AgoraChatMessageTypeText;
        }
    }
    if (aMsg.body.type == AgoraChatMessageTypeVoice) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioStateChange:) name:AUDIOMSGSTATECHANGE object:nil];
    }
    return self;
}

- (void)audioStateChange:(NSNotification *)aNotif
{
    id object = aNotif.object;
    if ([object isKindOfClass:[EaseMessageModel class]]) {
        EaseMessageModel *model = (EaseMessageModel *)object;
        if (model == self && self.isPlaying == NO) {
            self.isPlaying = YES;
        } else {
            self.isPlaying = NO;
        }
        
        [self.weakMessageCell.bubbleView setModel:self];
        if (model == self && model.direction == AgoraChatMessageDirectionReceive) {
            [self.weakMessageCell setStatusHidden:model.message.isListened];
        }
    }
}

@end
