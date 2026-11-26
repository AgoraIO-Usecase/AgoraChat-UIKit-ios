//
//  AgoraChatGroupMemberInfo.h
//  AgoraChat
//
//  Created by 朱继超 on 2/28/25.
//  Copyright © 2025 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  \
 *  The group member role type.
 */
typedef NS_ENUM(NSInteger, AgoraChatGroupPermissionType) {
    AgoraChatGroupPermissionTypeNone   = -1,    /** \ The unknown type.*/
    AgoraChatGroupPermissionTypeMember = 0,     /** \ The group member.*/
    AgoraChatGroupPermissionTypeAdmin,          /** \ The group admin.*/
    AgoraChatGroupPermissionTypeOwner,          /** \ The group owner.*/
};

NS_ASSUME_NONNULL_BEGIN

@interface AgoraChatGroupMemberInfo : NSObject
/**
 *  \
 *   The user id of the group member.
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  \
 *   The time when the group member joined the group.
 */
@property (nonatomic, assign) NSUInteger joinedTimestamp;

/**
 * \
 * The role of the group member.
 */
@property (nonatomic, assign) AgoraChatGroupPermissionType role;

/**
 *  \
 *  The group nickname of the group member.
 */
@property (nonatomic, copy) NSString* _Nullable namecard;

/**
 *  \
 *  The nickname of the group member.
 */
@property (nonatomic, copy) NSString* _Nullable nickname;

/**
 *  \
 *  The avatar URL of the group member.
 */
@property (nonatomic, copy) NSString* _Nullable avatarUrl;

@end

NS_ASSUME_NONNULL_END
