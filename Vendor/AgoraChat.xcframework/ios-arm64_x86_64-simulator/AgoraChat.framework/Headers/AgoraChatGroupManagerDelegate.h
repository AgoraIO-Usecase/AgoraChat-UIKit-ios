/**
 *  \
 *  @header AgoraChatGroupManagerDelegate.h
 *  @abstract This protocol defined the callbacks of group.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/**
 *  \
 *  The reasons for a group member leaving the group.
 */
typedef NS_ENUM(NSInteger, AgoraChatGroupLeaveReason) {
    AgoraChatGroupLeaveReasonBeRemoved = 0,    /** \ The member is removed by the group owner. */
    AgoraChatGroupLeaveReasonUserLeave,        /** \ The member leaves the group.*/
    AgoraChatGroupLeaveReasonDestroyed,        /** \ The group is destroyed.*/
};

@class AgoraChatGroup;
@class AgoraChatGroupSharedFile;

/**
 *  \
 *  The group manager delegates.
 */
@protocol AgoraChatGroupManagerDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when the group owner receives a join request.
 *
 *  If you set the group type as AgoraChatGroupStylePublicJoinNeedApproval, when a user requests to join the group, the group owner receives this callback.
 *
 *  @param aGroup     The group instance.
 *  @param aUsername  The user that sends the join request.
 *  @param aReason    The extra information for joining the group.
 */
- (void)joinGroupRequestDidReceive:(AgoraChatGroup *_Nonnull)aGroup
                              user:(NSString *_Nonnull)aUsername
                            reason:(NSString *_Nullable)aReason;


/**
 *  \
 *  Occurs when the user receives a group invitation.
 *
 *  This callback is triggered by a peer user sending a group invitation. For example, after user A sends user B a group invitation, user B receives this callback.
 *
 *  @param aGroupId          The group ID.
 *  @param aGroupName      The group name.
 *  @param aInviter          The user sending the group invitation.
 *  @param aMessage          The invitation message.
 */

- (void)groupInvitationDidReceive:(NSString *_Nonnull)aGroupId
                        groupName:(NSString *_Nonnull)aGroupName
                          inviter:(NSString *_Nonnull)aInviter
                          message:(NSString *_Nullable)aMessage;


/**
 *  \
 *  This callback is triggered when the peer user accepts the group invitation sent by the local user. For example, user B accepts the invitation of user A, user A receives this callback.
 *
 *  @param aGroup    The group instance.
 *  @param aInvitee  The user that accepts the invitation.
 */
- (void)groupInvitationDidAccept:(AgoraChatGroup *_Nonnull)aGroup
                         invitee:(NSString *_Nonnull)aInvitee;

/**
 *  \
 *  Occurs when the group invitation is declined.
 *
 *  This callback is triggered when a peer user declines the group invitation sent by the local user. For example, user B declines the group invitation sent by user A, user A receives this callback.
 *
 *  @param aGroup    The group instance.
 *  @param aInvitee  The invitee.
 *  @param aReason   The reason for declining the group invitation.
 */
- (void)groupInvitationDidDecline:(AgoraChatGroup *_Nonnull)aGroup
                          invitee:(NSString *_Nonnull)aInvitee
                           reason:(NSString *_Nullable)aReason;

/**
 *  \
 *  Occurs when the SDK automatically joins the group.
 * 
 *  If isAutoAcceptGroupInvitation in AgoraChatOptions is set as YES, when you receive a group invitation, the SDK automatically accepts the invitation and joins the group. 
 *   
 *  Needs to set the AgoraChatOptions's isAutoAcceptGroupInvitation property as YES.
 *
 *  @param aGroup    The group instance.
 *  @param aInviter  The inviter.
 *  @param aMessage  The invite message.
 */
- (void)didJoinGroup:(AgoraChatGroup *_Nonnull)aGroup
             inviter:(NSString *_Nonnull)aInviter
             message:(NSString *_Nullable)aMessage;

/**
 *  \
 *  Occurs when the user leaves a group.
 *
 *  @param aGroup    The group instance.
 *  @param aReason   The reason for leaving the group.
 */
- (void)didLeaveGroup:(AgoraChatGroup *_Nonnull)aGroup
               reason:(AgoraChatGroupLeaveReason)aReason;

/**
 *  \
 *  If the group is public and requires approval for join requests, the user that sends the request receives this callback when the owner declines it.
 *
 *  @param aGroupId    The group ID.
 *  @param aReason     The reason for declining the join request.
 *  @param aDecliner The userId of decliner(owner/admin)
 *  @param applicant The userId of applicant
 */
- (void)joinGroupRequestDidDecline:(NSString *_Nonnull)aGroupId
                            reason:(NSString *_Nullable)aReason
                          decliner:(NSString *_Nullable)aDecliner
                         applicant:(NSString* _Nonnull )aApplicant;

/**
 *  \
 *  If the group is public and requires approval for join requests, the user that sends the request receives this callback when the owner approves it.
 *
 *  @param aGroup   The group instance.
 */
- (void)joinGroupRequestDidApprove:(AgoraChatGroup *_Nonnull)aGroup;

/**
 *  \
 *  Occurs when the group list updates.
 *
 *  @param aGroupList  The group NSArray. See <AgoraChatGroup>.
 */
- (void)groupListDidUpdate:(NSArray<AgoraChatGroup *> *_Nonnull)aGroupList;


/**
 *  \
 *  Occurs when the group members are added to the group mute list.
 *
 *  @param aGroup           The group instance.
 *  @param aMutedMembers    The group members that are added to the mute list.
 *  @param aMuteExpire      The time when the mute state expires. This parameter is not available at the moment.
 */
- (void)groupMuteListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
             addedMutedMembers:(NSArray<NSString *> *_Nonnull)aMutedMembers
                    muteExpire:(NSInteger)aMuteExpire;

/**
 *  \
 *  Occurs when the group members are removed from the mute list.
 *
 *  @param aGroup           The group instance.
 *  @param aMutedMembers    The group members removed from the mute list.
 */
- (void)groupMuteListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
           removedMutedMembers:(NSArray<NSString *> *_Nonnull)aMutedMembers;

/**
 *  \
 *  Occurs when the group members are added to the allowlist.
 *
 *  @param aGroup       The group instance.
 *  @param aMembers     The group members added to the allowlist.
 */
- (void)groupWhiteListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
          addedWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers;

/**
 *  \
 *  Occurs when the group members are removed from the allowlist.
 *
 *  @param aGroup        The group instance.
 *  @param aMembers      The group members removed from the allowlist.
 */
- (void)groupWhiteListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
        removedWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers;


/**
*  \
*  Occurs when the mute state of all group members changes.
*
*  @param aGroup           The group instance.
*  @param aMuted           Whether all the group members are muted.
*/
- (void)groupAllMemberMuteChanged:(AgoraChatGroup *_Nonnull)aGroup
                 isAllMemberMuted:(BOOL)aMuted;

/**
 *  \
 *  Occurs when a group member is added to the admin list.
 *
 *  @param aGroup    The group instance.
 *  @param aAdmin    The group member added to the admin list.
 */
- (void)groupAdminListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
                     addedAdmin:(NSString *_Nonnull)aAdmin;

/**
 *  \
 *  Occurs when a groupmember is removed from the admin list.
 *
 *  @param aGroup    The group instance.
 *  @param aAdmin    The group member removed from the admin list.
 */
- (void)groupAdminListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
                   removedAdmin:(NSString *_Nonnull)aAdmin;

/**
 *  \
 *  Occurs when the group owner changes.
 *
 *  @param aGroup       The group instance.
 *  @param aNewOwner    The new owner.
 *  @param aOldOwner    The old owner.
 */
- (void)groupOwnerDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
                   newOwner:(NSString *_Nonnull)aNewOwner
                   oldOwner:(NSString *_Nonnull)aOldOwner;

/**
 *  \
 *  Occurs when users join a group.
 *
 *  @param group       The group instance.
 *  @param userIds   The users that join the group.
 */
- (void)userDidJoinGroup:(AgoraChatGroup *_Nonnull)group
                   users:(NSArray<NSString*> *_Nonnull)userIds;

/**
 *  \
 *  Occurs when users leave the group.
 *
 *  @param group       The group instance.
 *  @param userIds    The users that leave the group.
 */
- (void)userDidLeaveGroup:(AgoraChatGroup *_Nonnull)group
                    users:(NSArray<NSString *>* _Nonnull)userIds;

/**
 *  \
 *  Occurs when the group announcement updates.
 *
 *  @param aGroup           The group instance.
 *  @param aAnnouncement    The group announcement.
 */
- (void)groupAnnouncementDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
                      announcement:(NSString *_Nullable)aAnnouncement;

/**
 *  \
 *  Occurs when the group shared file is uploaded.
 *
 *  @param aGroup       The group instance.
 *  @param aSharedFile  The shared file.
 */
- (void)groupFileListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
               addedSharedFile:(AgoraChatGroupSharedFile *_Nonnull)aSharedFile;

/**
 *  \
 *  Occurs when the shared file of the group is removed.
 *
 *  @param aGroup      The group instance.
 *  @param aFileId     The ID of the shared file.
 */
- (void)groupFileListDidUpdate:(AgoraChatGroup *_Nonnull)aGroup
             removedSharedFile:(NSString *_Nonnull)aFileId;

/**
 *  \
 *  Occurs when the disabled state of group changes.
 *
 *  @param aGroup           The group instance.
 *  @param aDisabled        Whether the group is disabled.
 */
 - (void)groupStateChanged:(AgoraChatGroup *)aGroup
                isDisabled:(BOOL)aDisabled;

/**
 *  \
 *  Occurs when the group specification update,Need to call for details of the API (IAgoraChatGroupManager.h : getGroupSpecificationFromServerWithId) to get the latest information
 *
 *  @param aGroup      The group instance.
 */
- (void)groupSpecificationDidUpdate:(AgoraChatGroup *)aGroup;
/**
 *  \
 *  Occurs when a custom attribute(s) of a group member is/are changed.
 *
 *  @param groupId           The group ID.
 *  @param userId            The user ID of the group member whose custom attributes are changed.
 *  @param attributes        The modified custom attributes, in key-value format.
 *  @param operatorId        The user ID of the operator.
 */
- (void)onAttributesChangedOfGroupMember:(NSString *_Nonnull)groupId userId:(NSString *_Nonnull)userId attributes:(NSDictionary <NSString*,NSString*>*_Nullable)attributes operatorId:(NSString *_Nonnull)operatorId;

/**
 *  \
 *  Occurs when a namecard of a group member is changed
 *  @param groupId           The group ID.
 *  @param userId            The user ID of the group member whose namecard is
 *  @param namecard        The modified namecard.
 */
- (void)onUserGroupNamecardChanged:(NSString *_Nonnull)groupId userId:(NSString *_Nonnull)userId namecard:(NSString *_Nullable)namecard;

@end
