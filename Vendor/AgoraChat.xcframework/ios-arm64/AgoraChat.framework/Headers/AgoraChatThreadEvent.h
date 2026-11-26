//
//  AgoraChatThreadEvent.h
//  AgoraChat
//
//  Created by 朱继超 on 2022/3/3.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AgoraChatMessage;
@class AgoraChatThread;

typedef NS_ENUM(NSUInteger, AgoraChatThreadOperation) {
    AgoraChatThreadOperationUnknown,
    AgoraChatThreadOperationCreate,
    AgoraChatThreadOperationUpdate,
    AgoraChatThreadOperationDelete,
    AgoraChatThreadOperationUpdate_msg,
    AgoraChatThreadOperationUserRemoved
};

/*!
 *  \
 *  The message thread event class.
 */
@interface AgoraChatThreadEvent : NSObject
/*!
 *  \
 *  The message thread event type.
 */
@property (readonly) AgoraChatThreadOperation type;
/*!
 *  \
 *  The user ID of the message thread operator.
 */
@property (readonly) NSString *from;
/*!
 *  \
 *  The message thread object.
 */
@property (readonly) AgoraChatThread *chatThread;

@end

