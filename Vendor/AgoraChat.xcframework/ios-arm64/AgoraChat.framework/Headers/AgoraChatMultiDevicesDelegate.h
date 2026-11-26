/**
 *  \
 *  @header AgoraChatMultiDevicesDelegate.h
 *  @abstract This protocol defined the callbacks of Multi-device
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatConversation.h"

/**
 *  \
 *  Multi-device event types.
 * 
 *  This enumeration takes user A logged into both device A1 and device A2 as an example to illustrate the various multi-device event types and when these events are triggered.
 */
typedef NS_ENUM(NSInteger, AgoraChatMultiDevicesEvent) {
    AgoraChatMultiDevicesEventUnknow = -1,         /** \ Default. */
    AgoraChatMultiDevicesEventContactRemove = 2,    /** \ If user A deletes a contact on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventContactAccept = 3,    /** \ If user A accepts a contact invitation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventContactDecline = 4,   /** \ If user A declines a contact invitation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventContactBan = 5,       /** \ If user A adds another user into the block list on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventContactAllow = 6,     /** \ If user A removes a user from the block list on device A1, this event is triggered on device A2. */
    
    AgoraChatMultiDevicesEventGroupCreate = 10,     /** \ If user A creates a chat group on Device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupDestroy = 11,    /** \ If user A destroys a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupJoin = 12,       /** \ If user A joins a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupLeave = 13,      /** \ If user A leaves a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupApply = 14,      /** \ If user A requests to join a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupApplyAccept = 15,    /** \ If user A receives another user's request to join the chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupApplyDecline = 16,   /** \ If user A declines another user's request to join the chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupInvite = 17,     /** \ If user A invites other users to join the chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupInviteAccept = 18,   /** \ If user A accepts another user's group invitation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupInviteDecline = 19,  /** \ If user A declines another user's group invitation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupKick = 20,       /** \ If user A removes other users from a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupBan = 21,        /** \ If user A is added to the block list on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupAllow = 22,      /** \ If user A removes other users from a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupBlock = 23,      /** \ If user A blocks messages from a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupUnBlock = 24,    /** \ If user A unblocks messages from a chat group on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupAssignOwner = 25,    /** \ If user A assigns a group owner on device A1, this event is triggered on device A2.*/
    AgoraChatMultiDevicesEventGroupAddAdmin = 26,   /** \ If user A adds a group admin on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupRemoveAdmin = 27,    /** \ If user A removes a group admin on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupAddMute = 28,    /** \ If user A mutes other group members on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupRemoveMute = 29,     /** \ If user A unmutes other group members in device A1, this event is triggered on device A2. */
    
    AgoraChatMultiDevicesEventGroupAddWhiteList = 30,  /** \ If user A adds a group member to the allow list in device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupRemoveWhiteList = 31,   /** \ If user A removes a group member from the allow list on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupAllBan = 32,    /** \ If user A mutes all group members on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupRemoveAllBan = 33,  /** \ If user A unmutes all group members in device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupUpdate = 34, /** \ If user A updates group information on device A1, this event is triggered on device A2. */
    
    AgoraChatMultiDevicesEventChatThreadCreate = 40, /** \  If user A creates a message thread on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventChatThreadDestroy = 41,/** \  If user A destroys a message thread on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventChatThreadJoin = 42,/** \ If user A joins a message thread on device A1, this event is triggered on device A2.*/
    AgoraChatMultiDevicesEventChatThreadLeave = 43,/** \ If user A leaves a message thread on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventChatThreadUpdate = 44,/** \ If user A updates a message thread on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventChatThreadKick = 45,/** \ If user A is kicked out of a message thread on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventGroupMemberAttributesChanged = 52,/** \ If user A modifies a custom attribute of a group member on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationPinned = 60, /** \ If user A pins a conversation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationUnpinned = 61,/** \ If user A unpins a conversation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationDelete = 62,/** \ If user A deletes a conversation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationUpdateMark = 63, /** \ If user A add/remove a conversation mark on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationMuteInfoChanged = 64, /** \ If user A sets the Do Not Disturb mode for a conversation on device A1, this event is triggered on device A2. */
    /** \ If user A clear unread message count for a conversation on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventConversationUnreadMessageCountCleared = 65,
    /** \ If user A clear unread message count for all conversations on device A1, this event is triggered on device A2. */
    AgoraChatMultiDevicesEventAllConversationUnreadMessageCountCleared = 66,
};

@protocol AgoraChatMultiDevicesDelegate <NSObject>

@optional

/**
 *  \
 *  The multi-device contact event callback.
 *
 *  @param aEvent       The event type.
 *  @param aUsername    The username.
 *  @param aExt         The extended Information.
 */
- (void)multiDevicesContactEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent
                                  username:(NSString * _Nonnull)aUsername
                                       ext:(NSString * _Nullable)aExt;

/**
 *  \
 *  The multi-device group event callback.
 *
 *  @param aEvent       The event type.
 *  @param aGroupId     The group ID.
 *  @param aExt         The extended Information.
 */
- (void)multiDevicesGroupEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent
                                 groupId:(NSString * _Nonnull)aGroupId
                                     ext:(id _Nullable)aExt;
/*!
 *  \
 *  The multi-device message thread event callback.
 *
 *  @param aEvent       The event type.
 *  @param aThreadId    The message thread ID.
 *  @param aExt         The extended Information.
 */

- (void)multiDevicesChatThreadEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent
                                 threadId:(NSString * _Nonnull)aThreadId
                                     ext:(id _Nullable)aExt;

/*!
 *  \
 *  The multi-device event callback for setting the Do Not Disturb mode for a single conversation.
 *
 *  @param aEvent       The event type.
 *  @param undisturbData         The extended Information.
 */
- (void)multiDevicesUndisturbEventNotifyFormOtherDeviceData:(NSString *_Nullable)undisturbData __deprecated_msg("Use -multiDevicesConversationEvent:conversationId:conversationType: instead");
/*!
 *  \
 *  The multi-device event callback for removing historical messages of a single conversation from the server.
 *
 *  @param conversationId       The conversation ID.
 *  @param deviceId        The device ID.
 */
-(void)multiDevicesMessageBeRemoved:(NSString *_Nonnull)conversationId deviceId:(NSString *_Nonnull)deviceId;

/*!
 *  \
 *  The multi-device event callback for the operation of a single conversation.User needs to call the ``IAgoraChatManager#getAllConversations`` method to get the latest conversation list when receiving the conversation multi-device event.
 *
 *  @param event The event type.
 *  @param conversationId The conversation ID.
 *  @param conversationType The conversation type.
 */
- (void)multiDevicesConversationEvent:(AgoraChatMultiDevicesEvent)event conversationId:(NSString *_Nonnull)conversationId conversationType:(AgoraChatConversationType)conversationType;

@end
