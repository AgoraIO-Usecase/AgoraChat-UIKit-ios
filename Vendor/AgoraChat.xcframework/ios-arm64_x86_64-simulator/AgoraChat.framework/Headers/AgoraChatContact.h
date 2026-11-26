//
//  AgoraChatContact.h
//  AgoraChat
//
//  Created by li xiaoming on 2023/8/30.
//  Copyright © 2023 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AgoraChatUserInfo;
/**
 *  \
 *  The contact information interface.
 */
@interface AgoraChatContact : NSObject <NSCoding>

/**
 *  \
 *  The user ID of the contact.
 */
@property (nonatomic,strong,readonly) NSString* _Nonnull userId;

/**
 *  \
 *  The contact remark.
 */
@property (nonatomic,strong) NSString* _Nullable remark;

/**
 * \
 *  The contact information object.
 * 
 *  This object contains user attributes of the contact, such as the nickname and avatar.
 */
@property (nonatomic, strong, readonly) AgoraChatUserInfo *_Nullable userInfo;

/**
 * \
 * The time (in milliseconds) when the contact was added.
 */
@property (nonatomic, assign, readonly) NSUInteger addTimestamp;
/**
 *  \
 *  Initializes the contact object.
 *
 *  @param userId  The user ID of the contact.
 *  @param remark  The contact remark.
 *  @param createAt Contact addition time (in milliseconds).
 *  @return Contact object.
 */

- (instancetype)initWithUserId:(NSString* _Nonnull)userId remark:(NSString* _Nullable)remark createAt:(NSUInteger)createAt;
@end
