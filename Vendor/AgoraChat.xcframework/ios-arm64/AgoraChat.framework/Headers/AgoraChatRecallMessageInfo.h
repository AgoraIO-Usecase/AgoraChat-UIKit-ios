//
//  AgoraChatRecallMessageInfo.h
//  AgoraChat
//
//  Created by zhangchong on 2022/1/20.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatMessage.h"

/**
 *  \
 *  The message recall information object.  
 */
@interface AgoraChatRecallMessageInfo : NSObject

/*!
 *  \
 *  The user that recalls the message.
 */
@property (nonatomic, copy) NSString * _Nonnull recallBy;

/*!
 *  \
 *  The ID of the recalled message.
 */
@property (nonatomic, copy) NSString * _Nonnull recallMessageId;

/*!
 *  \
 *  The recalled message.
 * 
 * The value of this property is nil if the recipient is offline during message recall.
 */
@property (nonatomic, strong) AgoraChatMessage * _Nullable recallMessage;

/*!
 *  \
 *  The information to be transparently transmitted during message recall.
 */
@property (nonatomic, strong) NSString* _Nullable ext;

/*!
 *  \
 *  The  conversationId of the recalled message.
 */
@property (nonatomic, strong) NSString* _Nonnull conversationId;

@end

