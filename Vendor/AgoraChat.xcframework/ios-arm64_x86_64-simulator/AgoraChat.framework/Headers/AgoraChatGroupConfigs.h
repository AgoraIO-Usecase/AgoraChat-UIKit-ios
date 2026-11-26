/**
 *  \
 *  @header AgoraChatGroupConfigs.h
 *  @abstract Group property options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#define KSDK_GROUP_MINUSERSCOUNT 3
#define KSDK_GROUP_USERSCOUNTDEFAULT 200

/**
 *  \
 *  The group option fields to update. Values can be combined with bitwise OR.
 */
typedef NS_OPTIONS(NSUInteger, AgoraChatGroupConfigsType) {
    AgoraChatGroupConfigsTypeAllowInvites = 1 << 0,              /**! \ Whether members can invite others. Only meaningful for private groups. */
    AgoraChatGroupConfigsTypeMaxUsers = 1 << 1,                  /**! \ The maximum number of members in a group. */
    AgoraChatGroupConfigsTypeInviteNeedConfirm = 1 << 2,         /**! \ Whether invitation confirmation is required when inviting users. */
    AgoraChatGroupConfigsTypeJoinApprovalRequired = 1 << 3,      /**! \ Whether a public group requires approval for join requests. Only meaningful for public groups. */
    AgoraChatGroupConfigsTypeIsPublic = 1 << 4,                  /**! \ Whether the group is public. */
    AgoraChatGroupConfigsTypeExt = 1 << 5,                       /**! \ The group extension information. */
};

/**
 *  \
 *  The group configs.
 */
@interface AgoraChatGroupConfigs : NSObject

/**
 *  \
 *  The maximum number of members in a group. The value range is [3,2000]; the default value is 200.
 */
@property (nonatomic) NSInteger maxUsers;

/**
 *  \
 *  Whether to send an invitation notification when inviting a user to join the group. If you set it as NO, the user joins the group automatically.
 */
@property (nonatomic) BOOL IsInviteNeedConfirm;

/**
 *  \
 *  The extra information of the group.
 */
@property (nonatomic, strong) NSString *ext;

/**
 *  \
 *  Whether regular members can invite others in a private group. This flag does not drive behavior for public groups.
 */
@property (nonatomic) BOOL allowInvites;

/**
 *  \
 *  Whether join requests require approval in a public group. This flag does not drive behavior for private groups.
 */
@property (nonatomic) BOOL joinApprovalRequired;

/**
 *  \
 *  Whether the group is public. `YES` for a public group; `NO` for a private group.
 */
@property (nonatomic) BOOL isPublic;

@end
