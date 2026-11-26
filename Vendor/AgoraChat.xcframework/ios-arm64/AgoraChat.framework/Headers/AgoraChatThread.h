//
//  AgoraChatThread.h
//  AgoraChat
//
//  Created by 朱继超 on 2022/3/1.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AgoraChatMessage;

/*!
 *  \
 *  The message thread model class, which defines attributes of a message thread.
 */
@interface AgoraChatThread : NSObject

/*!
 *  \
 *  The message thread ID.
 */
@property (readonly) NSString *threadId;

/*!
*  \
*  The message thread name.
*/
@property (nonatomic, strong) NSString *threadName;

/*!
 *  \
 *  The message thread creator.
 */
@property (readonly) NSString *owner;
/*!
 *  \
 *  The ID of the parent message of the message thread.
 * 
 *  If this attribute is empty, the parent message of the message thread is withdrawn.
 */
@property (readonly) NSString *messageId;
/*!
 *  \
 *  The group ID where the message thread belongs.
 */
@property (readonly) NSString *parentId;


/*!
 *  \
 *  The count of members in the message thread.
 * 
 *  This attribute exists only after you call {@link IAgoraChatThread#getChatThreadDetail:} to get details of a message thread.
 */
@property (readonly) int membersCount;
/*!
 *  \
 *  The number of messages in a message thread.
 */
@property (readonly) int messageCount;
/*!
 *  \
 *  The Unix timestamp when the message thread is created. The unit is millisecond.
 */
@property (readonly) NSInteger createAt;

/*!
 *  \
 *  The last reply in the message thread.
 * 
 *  If this attribute is empty, the last reply is withdrawn. 
 */
@property (readonly) AgoraChatMessage *lastMessage;

@end


