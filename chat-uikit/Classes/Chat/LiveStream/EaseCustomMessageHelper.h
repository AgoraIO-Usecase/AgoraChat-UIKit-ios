//
//  EaseCustomMessageHelper.h
//  EaseMobLiveDemo
//
//  Created by easemob on 2020/3/12.
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


/// create a EaseCustomMessageHelper Instance
/// @param customMsgImp a delegate which implment EaseCustomMessageHelperDelegate
/// @param chatId a chatroom Id
- (instancetype)initWithCustomMsgImp:(id<EaseCustomMessageHelperDelegate>)customMsgImp chatId:(NSString*)chatId;

/*
 send custom message (gift,like,Barrage)
 @param text                 Message content
 @param num                  Number of message content
 @param messageType          chat type
 @param customMsgType        custom message type
 @param aCompletionBlock     send completion callback
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;

/*
 send custom message (gift,like,Barrage) (with extended parameters)
 @param text                 Message content
 @param num                  Number of message content
 @param messageType          chat type
 @param customMsgType        custom message type
 @param ext              message extension
 @param aCompletionBlock     send completion callback
*/
- (void)sendCustomMessage:(NSString*)text
                      num:(NSInteger)num
                       to:(NSString*)toUser
              messageType:(AgoraChatType)messageType
            customMsgType:(customMessageType)customMsgType
                      ext:(NSDictionary*)ext
               completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;

/*
 send user custom message (Other custom message body events)
 
@param event                custom message body event
@param customMsgBodyExt     custom message body event parameters
@param to                   message receiver
@param messageType          chat type
@param aCompletionBlock     send completion callback
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;

/*
 send user custom message (Other custom message body events) (extension parameters)
 
@param event                custom message body event
@param customMsgBodyExt     custom message body event parameters
@param to                   message receiver
@param messageType          chat type
@param ext                  message extension
@param aCompletionBlock     send completion callback
*/
- (void)sendUserCustomMessage:(NSString*)event
             customMsgBodyExt:(NSDictionary*)customMsgBodyExt
                           to:(NSString*)toUser
                  messageType:(AgoraChatType)messageType
                          ext:(NSDictionary*)ext
                   completion:(void (^)(AgoraChatMessage *message, AgoraChatError *error))aCompletionBlock;


@end

NS_ASSUME_NONNULL_END

