/**
 *  \
 *  @header AgoraChatroomManagerDelegate.h
 *  @abstract This protocol defined the callbacks of chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The casuse type for kicking out from a chatroom.
 */
typedef NS_ENUM(NSInteger, AgoraChatroomBeKickedReason)
{
    AgoraChatroomBeKickedReasonBeRemoved = 0, /** \ Removed by chatroom owner type */
    AgoraChatroomBeKickedReasonDestroyed,     /** \ Chatroom has been destroyed type*/
    AgoraChatroomBeKickedReasonOffline,       /** \ Account offline type*/
};

@class AgoraChatroom;

/**
 *  \
 *  The callbacks of chatroom.
 */
@protocol AgoraChatroomManagerDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when a user joined the chat room.
 *
 *  @param aChatroom   The chat room.
 *  @param aUsername    The user that joined the chat room.
 *  @param ext                 The extension information.
 *
 */
- (void)userDidJoinChatroom:(AgoraChatroom *)aChatroom
                       user:(NSString *)aUsername
                        ext:(NSString* _Nullable)ext;

/**
 *  \
 *  Occurs when a user leaves a chatroom.
 *
 *  @param aChatroom    The chatroom user left.
 *  @param aUsername    The user who leaved chatroom
 */
- (void)userDidLeaveChatroom:(AgoraChatroom *)aChatroom
                        user:(NSString *)aUsername;

/**
 *  \
 *  Occurs when a user is dismissed from a chat room.
 *
 *  @param aChatroom    The chatroom user is dismissed from.
 *  @param aReason      The reason of the user was kicked out.
 */
- (void)didDismissFromChatroom:(AgoraChatroom *)aChatroom
                        reason:(AgoraChatroomBeKickedReason)aReason;

/**
 *  \
 *  Occurs when the chatroom specification update,Need to call for a chat room details API (IAgoraChatroomManager. H: getChatroomSpecificationFromServerWithId) to get the latest information chat room
 *
 *  @param aChatroom       The chatroom.
 */
- (void)chatroomSpecificationDidUpdate:(AgoraChatroom *)aChatroom;

/**
 *  \
 *  Occurs when one or more members are added to the mute list of the chat room.
 *
 *  @param aChatroom       The chat room.
 *  @param aMutes             The muted chat room members. The parameter value is represented as key-value pairs, where the key is the user ID of the muted user and the value is the mute expiration timestamp in millisecond.Value == -1 means muted forever.
 */
- (void)chatroomMuteListDidUpdate:(AgoraChatroom *)aChatroom
                addedMutedMembers:(NSDictionary<NSString *,NSNumber*> *)aMutes;

/**
 *  \
 *  Users are removed from the mute list.
 *
 *  @param aChatroom        The Chatroom.
 *  @param aMutedMembers    The users who are removed from MutedList.
 */
- (void)chatroomMuteListDidUpdate:(AgoraChatroom *)aChatroom
              removedMutedMembers:(NSArray<NSString *> *)aMutes;

/**
 *  \
 *  Users are added to the allowlist.
 *
 *  @param aChatroom        The Chatroom.
 *  @param aMutedMembers    The users who are added to allowlist.
 */
- (void)chatroomWhiteListDidUpdate:(AgoraChatroom *)aChatroom
             addedWhiteListMembers:(NSArray<NSString *> *)aMembers;

/**
 *  \
 *  Users are removed from the allowlist.
 *
 *  @param aChatroom        The Chatroom.
 *  @param aMembers    The users who are removed from the allowlist.
 */
- (void)chatroomWhiteListDidUpdate:(AgoraChatroom *)aChatroom
           removedWhiteListMembers:(NSArray<NSString *> *)aMembers;

/**
 *  \
 *  Whether group members are all muted.
 *
 *  @param aChatroom      The Chatroom.
 *  @param aMuted         Whether all members are muted.
 */
- (void)chatroomAllMemberMuteChanged:(AgoraChatroom *)aChatroom
                    isAllMemberMuted:(BOOL)aMuted;

/**
 *  \
 *  A user is added to the admin list.
 *
 *  @param aChatroom    The Chatroom
 *  @param aAdmin       The user who is added to the admin list.
 */
- (void)chatroomAdminListDidUpdate:(AgoraChatroom *)aChatroom
                        addedAdmin:(NSString *)aAdmin;

/**
 *  \
 *  A user is removed from the admin list.
 *
 *  @param aChatroom    The Chatroom.
 *  @param aAdmin       The user who is removed from adminList.
 */
- (void)chatroomAdminListDidUpdate:(AgoraChatroom *)aChatroom
                      removedAdmin:(NSString *)aAdmin;

/**
 *  \
 *  The owner is updated.
 *
 *  @param aChatroom    The Chatroom
 *  @param aNewOwner    The New Owner
 *  @param aOldOwner    The Old Owner
 */
- (void)chatroomOwnerDidUpdate:(AgoraChatroom *)aChatroom
                      newOwner:(NSString *)aNewOwner
                      oldOwner:(NSString *)aOldOwner;

/**
 *  \
 *  The announcement is updated.
 *
 *  @param aChatroom        The Chatroom
 *  @param aAnnouncement    The Announcement content.
 */
- (void)chatroomAnnouncementDidUpdate:(AgoraChatroom *)aChatroom
                         announcement:(NSString * _Nullable )aAnnouncement;
/**
 *  \
 *  The announcement is updated.
 *
 *  @param roomid        The Chatroom's id
 *  @param attributeMap    The propertyMap of chatroom
 *  @param fromId    operator's id
 */
- (void)chatroomAttributesDidUpdated:( NSString * _Nonnull )roomId attributeMap:(NSDictionary<NSString*,NSString*> * _Nonnull)attributeMap from:(NSString * _Nonnull)fromId;
/**
 *  \
 *  The announcement is updated.
 *
 *  @param roomid        The Chatroom's id
 *  @param attributeMap    The propertyMap of chatroom
 *  @param fromId    operator's id
 */
- (void)chatroomAttributesDidRemoved:( NSString * _Nonnull )roomId attributes:(NSArray<__kindof NSString*> * _Nonnull)attributes from:(NSString * _Nonnull)fromId;

#pragma mark - Deprecated methods

/**
 *  \
 *  A user joined a chatroom.
 *
 *  @param aChatroom    The chatroom user joined.
 *  @param aUsername    The user who joined chatroom.
 */
- (void)userDidJoinChatroom:(AgoraChatroom *)aChatroom
                       user:(NSString *)aUsername __deprecated_msg("Use -userDidJoinChatroom:user:ext: instead");

/**
 *  \
 *  Users are added to the mute list.
 *
 *  @param aChatroom        The Chatroom.
 *  @param aMutes           The users who are muted.
 *  @param aMuteExpire      The mute expire duration, not available at this time.
 */
- (void)chatroomMuteListDidUpdate:(AgoraChatroom *)aChatroom
                addedMutedMembers:(NSArray<NSString *> *)aMutes
                       muteExpire:(NSInteger)aMuteExpire __deprecated_msg("Use -chatroomMuteListDidUpdate:addedMutedMembers: instead");;
@end

NS_ASSUME_NONNULL_END
