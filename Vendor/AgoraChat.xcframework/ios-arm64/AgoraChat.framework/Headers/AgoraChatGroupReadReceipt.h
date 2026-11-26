//
//  AgoraChatGroupReadReceipt.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2019/6/3.
//  Copyright © 2019 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatGroupMemberInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The group message receipt.
 */
@interface AgoraChatGroupReadReceipt : NSObject

/**
 *  \
 *  The group message ID.
 */
@property (nonatomic, copy) NSString *messageId;

/**
 *  \
 *  The group message read receipt ID.
 */
@property (nonatomic, copy) NSString *readReceiptId;

/**
 *  \
 *  The group member information of the user that sends the message receipt.
 *  The object is never `nil` and contains at least `userId`.
 */
@property (nonatomic, strong) AgoraChatGroupMemberInfo *from;

/**
 *  \
 *  The number of group members that have read the group message.
 */
@property (nonatomic) int readCount;

/**
 *  \
 *  The Unix timestamp for group message ack.
 */
@property (nonatomic) long long timestamp;

@end

NS_ASSUME_NONNULL_END
