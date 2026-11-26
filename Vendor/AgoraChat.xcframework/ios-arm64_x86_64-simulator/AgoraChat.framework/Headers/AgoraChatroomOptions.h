//
//  AgoraChatroomOptions.h
//  HyphenateSDK
//
//  Created by XieYajie on 09/01/2017.
//  Copyright © 2017 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  \
 *  The options of a chatroom.
 */
@interface AgoraChatroomOptions : NSObject

/**
 *  \
 *  The maximum number of members in a chatroom. The value range is [3,5000], and the default value is 200.
 */
@property (nonatomic) NSInteger maxUsersCount;

@end
