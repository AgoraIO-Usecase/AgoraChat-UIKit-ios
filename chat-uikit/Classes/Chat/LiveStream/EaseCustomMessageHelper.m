//
//  EaseCustomMessageHelper.m
//  EaseMobLiveDemo
//
//  Created by easemob on 2020/3/12.
//  Copyright © 2020 zmw. All rights reserved.
//

#import "EaseCustomMessageHelper.h"
#import "EaseHeaders.h"


@interface EaseCustomMessageHelper ()<AgoraChatManagerDelegate>
{
    NSString* _chatId;
    
    long long _curtime;//过滤历史记录
}

@property (nonatomic, weak) id<EaseCustomMessageHelperDelegate> delegate;

@end

@implementation EaseCustomMessageHelper

- (instancetype)initWithCustomMsgImp:(id<EaseCustomMessageHelperDelegate>)customMsgImp chatId:(NSString*)chatId
{
    self = [super init];
    if (self) {
        _delegate = customMsgImp;
        _chatId = chatId;
        _curtime = (long long)([[NSDate date] timeIntervalSince1970]*1000);
        [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark - AgoraChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    for (AgoraChatMessage *message in aMessages) {
        if ([message.conversationId isEqualToString:_chatId]) {
            if (message.body.type == AgoraChatMessageBodyTypeCustom) {
                if (message.timestamp < _curtime) {
                    continue;
                }
                AgoraChatCustomMessageBody* body = (AgoraChatCustomMessageBody*)message.body;
                if ([body.event isEqualToString:kCustomMsgChatroomBarrage]) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBarrageSwitch:)]) {
                        [self.delegate didSelectedBarrageSwitch:message];
                    }
                } else if ([body.event isEqualToString:kCustomMsgChatroomPraise]) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceivePraiseMessage:)]) {
                        [self.delegate didReceivePraiseMessage:message];
                    }
                } else if ([body.event isEqualToString:kCustomMsgChatroomGift]) {
                    
                    NSString *giftId = [body.customExt objectForKey:kGiftIdKey];
                    NSInteger giftNum = [[body.customExt objectForKey:kGiftNumKey] integerValue];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(steamerReceiveGiftId:giftNum:fromUser:)]) {
                        [self.delegate steamerReceiveGiftId:giftId giftNum:giftNum fromUser:message.from];
                    }

                }
            }
        }
    }
}


/*
发送自定义消息（礼物，点赞，弹幕）
@param text                 消息内容
@param num                  消息内容数量
@param to                   消息发送对象
@param messageType          聊天类型
@param customMsgType        自定义消息类型
@param aCompletionBlock     发送完成回调block
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock {
    
    [self sendCustomMessage:text num:num to:toUser messageType:messageType customMsgType:customMsgType ext:@{} completion:aCompletionBlock];    
}

/*
发送自定义消息（礼物，点赞，弹幕）（有消息扩展参数）
@param text             消息内容
@param num              消息内容数量
@param to               消息发送对象
@param messageType      聊天类型
@param customMsgType    自定义消息类型
@param ext              消息扩展
@param aCompletionBlock 发送完成回调block
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
                      ext:(NSDictionary*)ext
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;
{
    
    
    AgoraChatMessageBody *body;
    NSMutableDictionary *extDic = [[NSMutableDictionary alloc]init];
    if (customMsgType == customMessageType_praise) {
        [extDic setObject:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"num"];
        body = [[AgoraChatCustomMessageBody alloc] initWithEvent:kCustomMsgChatroomPraise customExt:extDic];
    } else if (customMsgType == customMessageType_gift){
        [extDic setObject:text forKey:kGiftIdKey];
        [extDic setObject:[@(num) stringValue] forKey:kGiftNumKey];
        body = [[AgoraChatCustomMessageBody alloc] initWithEvent:kCustomMsgChatroomGift customExt:extDic];
    } else if (customMsgType == customMessageType_barrage) {
        [extDic setObject:text forKey:@"txt"];
        body = [[AgoraChatCustomMessageBody alloc]initWithEvent:kCustomMsgChatroomBarrage customExt:extDic];
    }
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:ext];
    message.chatType = messageType;
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:NULL completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        aCompletionBlock(message,error);
    }];
    
}

/*
发送用户自定义消息体事件（其他自定义消息体事件）
@param event                自定义消息体事件
@param customMsgBodyExt     自定义消息体事件参数
@param to                   消息发送对象
@param messageType          聊天类型
@param aCompletionBlock     发送完成回调block
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock {
    [self sendUserCustomMessage:event customMsgBodyExt:customMsgBodyExt to:toUser messageType:messageType ext:@{} completion:aCompletionBlock];
}


/*
发送用户自定义消息体事件（其他自定义消息体事件）（有消息扩展参数）
@param event                自定义消息体事件
@param customMsgBodyExt     自定义消息体事件参数
@param to                   消息发送对象
@param messageType          聊天类型
@param ext                  消息扩展
@param aCompletionBlock     发送完成回调block
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                          ext:(NSDictionary*)ext
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock {
    AgoraChatMessageBody *customMsgBody = [[AgoraChatCustomMessageBody alloc] initWithEvent:event customExt:customMsgBodyExt];
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:toUser from:from to:toUser body:customMsgBody ext:ext];
    message.chatType = messageType;
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:NULL completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        aCompletionBlock(message,error);
    }];
}




@end
