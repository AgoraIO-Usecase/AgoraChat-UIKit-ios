//
//  AgoraChatSilentModeResult.h
//  AgoraChat
//
//  Created by hxq on 2022/3/30.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatSilentModeTime.h"
#import "AgoraChatSilentModeParam.h"
#import "AgoraChatConversation.h"

/**
 *  \
 *  The silent message result object
 */
@interface AgoraChatSilentModeResult: NSObject <NSCopying,NSCoding>
/*!
 *  \
 *  The expiration time for  silent messages.
 *
 */
@property (nonatomic, assign, readonly) NSTimeInterval expireTimestamp;
/*!
 *  \
 *  The remind type for push messages.
 */
@property (nonatomic, assign, readonly) AgoraChatPushRemindType remindType;
/*!
 *  \
 *  The start time of the application push silent mode.
 *
 */
@property (nonatomic, strong, readonly) AgoraChatSilentModeTime * _Nullable silentModeStartTime;
/*!
 *  \
 *  The end time of the application push silent mode.
 *
 */
@property (nonatomic, strong, readonly) AgoraChatSilentModeTime *_Nullable silentModeEndTime;
/*!
 *  \
 *  The conversation ID.
 *
 */
@property (nonatomic, copy, readonly) NSString  * _Nonnull conversationID;
/*!
 *  \
 *  The conversation type.
 *
 */
@property (nonatomic, assign, readonly) AgoraChatConversationType conversationType;
/*!
 *  \
 *  Whether the remind type is set for the conversation.
 *
 */
@property (nonatomic, assign, readonly) BOOL isConversationRemindTypeEnabled;

@end

