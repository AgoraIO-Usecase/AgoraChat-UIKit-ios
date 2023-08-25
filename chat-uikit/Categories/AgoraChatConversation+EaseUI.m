//
//  AgoraChatConversation+EaseUI.m
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/14.
//

#import "AgoraChatConversation+EaseUI.h"

#define EaseConversationTop @"EaseConversation_Top"
#define EaseConversationShowName @"EaseConversation_ShowName"
#define EaseConversationRemindMe @"EaseConversation_RemindMe"
#define EaseConversationDraft @"EaseConversation_Draft"
#define EaseConversationLatestUpdateTime @"EaseConversationLatestUpdateTime"

@implementation AgoraChatConversation (EaseUI)


- (BOOL)isNoDistrub
{
    if (self.type == AgoraChatConversationTypeChat) {
        return [[AgoraChatClient sharedClient].pushManager.noPushUIds containsObject:self.conversationId];
    } else if (self.type == AgoraChatConversationTypeGroupChat) {
        return [[AgoraChatClient sharedClient].pushManager.noPushGroups containsObject:self.conversationId];
    }
    return NO;
}

- (void)setNoDistrub:(BOOL)isNoDistrub
{
    
}

- (void)setTop:(BOOL)isTop {
    if (isTop) {
        self.latestUpdateTime = [[NSDate new] timeIntervalSince1970] * 1000;
    }else {
        self.latestUpdateTime = 0;
    }
    NSMutableDictionary *dictionary = [self mutableExt];
    [dictionary setObject:@(isTop) forKey:EaseConversationTop];
    [self setExt:dictionary];
}

- (BOOL)isTop {
    return [self.ext[EaseConversationTop] boolValue];
}

- (void)setShowName:(NSString *)aShowName {
    NSMutableDictionary *dictionary = [self mutableExt];
    [dictionary setObject:aShowName forKey:EaseConversationShowName];
    [self setExt:dictionary];
}

- (NSString *)showName {
    return self.ext[EaseConversationShowName] ? self.ext[EaseConversationShowName] : self.conversationId;
}

- (void)setDraft:(NSString *)aDraft {
    self.latestUpdateTime = [[NSDate new] timeIntervalSince1970];
    NSMutableDictionary *dictionary = [self mutableExt];
    [dictionary setObject:aDraft forKey:EaseConversationDraft];
    [self setExt:dictionary];
}

- (NSString *)draft {
    return self.ext[EaseConversationDraft] ? self.ext[EaseConversationDraft] : @"";
}

- (BOOL)remindMe {
    //判断会话类型和消息是否包含@我
    if (self.type != AgoraChatConversationTypeGroupChat) {
        return NO;
    }
    BOOL ret = NO;
    NSMutableArray *msgIdArray = [self remindMeArray];
    /*
    for (NSString *msgId in msgIds) {
        EaseMessage *msg = [self loadMessageWithId:msgId error:nil];
        if (!msg.isRead && msg.body.type == EaseMessageBodyTypeText) {
            EaseTextMessageBody *textBody = (EaseTextMessageBody*)msg.body;
            if ([textBody.text containsString:[NSString stringWithFormat:@"@%@",EaseClient.sharedClient.currentUsername]]) {
                ret = YES;
                break;
            }
        }
    }*/
    if ([msgIdArray count] > 0) {
        ret = YES;
    }
    
    return ret;
}

- (BOOL)remindALL
{
    //判断会话类型和消息是否包含@我
    if (self.type != AgoraChatConversationTypeGroupChat) {
        return NO;
    }
    BOOL ret = NO;
    id remindStr = [self.ext objectForKey:EaseConversationRemindMe];
    /*
    for (NSString *msgId in msgIds) {
        EaseMessage *msg = [self loadMessageWithId:msgId error:nil];
        if (!msg.isRead && msg.body.type == EaseMessageBodyTypeText) {
            EaseTextMessageBody *textBody = (EaseTextMessageBody*)msg.body;
            if ([textBody.text containsString:[NSString stringWithFormat:@"@%@",EaseClient.sharedClient.currentUsername]]) {
                ret = YES;
                break;
            }
        }
    }*/
    if ([remindStr isKindOfClass:[NSString class]]) {
        NSString* tmp = (NSString*)remindStr;
        if([[tmp lowercaseString] isEqualToString:@"all"])
            ret = YES;
    }
    
    return ret;
}

- (NSMutableArray *)remindMeArray {
    NSMutableArray *dict = [(NSMutableArray *)self.ext[EaseConversationRemindMe] mutableCopy];
    if (!dict || [dict isKindOfClass:[NSString class]]) {
        dict = [[NSMutableArray alloc]init];
    }
    
    return dict;
}

- (void)setRemindMe:(NSString *)messageId
{
    NSMutableDictionary *dict = [self mutableExt];
    NSMutableArray *msgIdArray = [self remindMeArray];
    [msgIdArray addObject:messageId];
    [dict setObject:msgIdArray forKey:EaseConversationRemindMe];
    [self setExt:dict];
}

- (void)resetRemindMe
{
    NSMutableArray *msgIdArray = [self remindMeArray];
    [msgIdArray removeAllObjects];
    NSMutableDictionary *dict = [self mutableExt];
    [dict setObject:msgIdArray forKey:EaseConversationRemindMe];
    [self setExt:dict];
}

- (void)setRemindAll
{
    NSMutableDictionary *dict = [self mutableExt];
    [dict setObject:@"ALL" forKey:EaseConversationRemindMe];
    [self setExt:dict];
}

- (NSMutableDictionary *)mutableExt {
    NSMutableDictionary *mutableExt = [self.ext mutableCopy];
    if (!mutableExt) {
        mutableExt = [NSMutableDictionary dictionary];
    }
    
    return mutableExt;
}

- (void)setLatestUpdateTime:(long long)latestUpdateTime {
    NSMutableDictionary *dict = [self mutableExt];
    [dict setObject:@(latestUpdateTime) forKey:EaseConversationLatestUpdateTime];
    [self setExt:dict];
}

- (long long)latestUpdateTime {
    NSMutableDictionary *dict = [self mutableExt];
    long long latestUpdateTime = [dict[EaseConversationLatestUpdateTime] longLongValue];
    return latestUpdateTime > self.latestMessage.timestamp ? latestUpdateTime : self.latestMessage.timestamp;
}

@end
