//
//  EaseCustomMessageHelper.h
//  EaseMobLiveDemo
//
//  Created by 娜塔莎 on 2020/3/12.
//  Copyright © 2020 zmw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraChat/AgoraChat.h>

typedef enum : NSInteger{
    customMessageType_praise,//点赞
    customMessageType_gift,//礼物
    customMessageType_barrage,//弹幕
}customMessageType;


NS_ASSUME_NONNULL_BEGIN

@class AgoraChatMessage;
@protocol EaseCustomMessageHelperDelegate <NSObject>

@optional

//观众点赞消息
- (void)didReceivePraiseMessage:(AgoraChatMessage *)message;

//弹幕消息
- (void)didSelectedBarrageSwitch:(AgoraChatMessage*)msg;

//观众刷礼物
- (void)steamerReceiveGiftId:(NSString *)giftId giftNum:(NSInteger )giftNum fromUser:(NSString *)userId ;

@end

@interface EaseCustomMessageHelper : NSObject

- (instancetype)initWithCustomMsgImp:(id<EaseCustomMessageHelperDelegate>)customMsgImp chatId:(NSString*)chatId;

//解析消息内容
+ (NSString*)getMsgContent:(AgoraChatMessageBody*)messageBody;

/*
 发送自定义消息 （礼物，点赞，弹幕）
 @param text                 消息内容
 @param num                  消息内容数量
 @param messageType          聊天类型
 @param customMsgType        自定义消息类型
 @param aCompletionBlock     发送完成回调block
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;

/*
 发送自定义消息（礼物，点赞，弹幕）（有扩展参数）
 @param text             消息内容
 @param num              消息内容数量
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
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;

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
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;


@end

NS_ASSUME_NONNULL_END

