/**
 *  \
 *  @header AgoraChatroom.h
 *  @abstract Chatroom
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatCommonDefs.h"

/**
 *  \
 *  The enum of chat room permission types.
 */
typedef NS_ENUM(NSInteger, AgoraChatroomPermissionType) {
    AgoraChatroomPermissionTypeNone   = -1,    /** \ Unknown type*/
    AgoraChatroomPermissionTypeMember = 0,     /** \ Normal member type*/
    AgoraChatroomPermissionTypeAdmin,          /** \ Chatroom admin type*/
    AgoraChatroomPermissionTypeOwner,          /** \ Chatroom owner  type*/
};


/**
 *  \
 *  The chat room object.
 */
@interface AgoraChatroom : NSObject

/**
 *  \
 *  The chat room ID.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable chatroomId;

/**
 *  \
 *  The subject of the chat room.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable subject;

/**
 *  \
 *  The description of chat room.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable description;

/**
 *  \
 *  The owner of the chat room. There is only one owner per chat room.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable owner;

/**
 *  \
 *  The announcement of the chat room.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable announcement;

/**
 *  \
 *  The admins of the chatroom.
 *
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> * _Nullable adminList;

/**
 *  \
 *  The list of members in the chat room.
 */
@property (nonatomic, copy, readonly) NSArray<NSString *> * _Nullable memberList;

/**
 *  \
 *  The blocklist of the chatroom.
 *
 *  Only the chatroom owner can call the method. Returns nil if the user is not the chatroom owner.
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> * _Nullable blacklist;

/**
 *  \
 *  The list of muted members.
 *
 *  Only the chatroom owner can call the method. Returns nil if the user is not the chatroom owner.Return a key-value pairs, where the key is the user ID of the muted user and the value is the mute expiration timestamp in millisecond.Value == -1 means muted forever.
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber*> * _Nullable muteMembers;

/**
*  \
*  The allowlist members <NSString>
*
*  Only the chatroom owner can call the method. Returns nil if the user is not the chatroom owner.
*/
@property (nonatomic, strong, readonly) NSArray<NSString *> * _Nullable whitelist;

/**
 *  \
 *  The chatroom membership type of the current login account.
 */
@property (nonatomic, readonly) AgoraChatroomPermissionType permissionType;

/**
 *  \
 *  The maximum member number of the chat room.
 */
@property (nonatomic, readonly) NSInteger maxOccupantsCount;

/**
 *  \
 *  The current number of members in the chat room.
 *  This includes the chat room owner, administrators, and regular members.
 *  You can get this information after joining the chat room.
 *  This property is updated when members join or leave the chat room.
 */
@property (nonatomic, readonly) NSInteger occupantsCount;

/**
 *  \
 *  Checks whether all members are muted,This propery is available once join the chat room.
 *  After joining the chat room, when you receive a callback for muting or unmuting all members, this property will be updated.
 */
@property (nonatomic, readonly) BOOL isMuteAllMembers;

/**
 * \
 * Gets the timestamp(ms) when the chat room was created.
 * This property is available once join the chat room.
 */
@property (nonatomic,readonly) NSInteger createTimestamp;

/**
 * \
 * Current user is in allow list or not.
 * This property is available once join the chat room.
 * This property will be updated when current user is added or removed from the white list.
 * - `true`: In white list.
 * - `false`: Not in white list.
 */
@property (nonatomic,readonly) BOOL isInWhitelist;

/**
 * \
 * Gets the timestamp(ms) when Current user will be unmuted.
 *
 * This property is available once join the chat room.
 * This property will be updated when current use is muted or unmuted.
 *
 * - Current use is not muted if it is zero.
 * - Means cannot get MuteUntilTimeStamp correctly if it is be set with -1;
 */
@property (nonatomic,readonly) NSInteger muteExpireTimestamp;

/**
 *  \
 *  Constructs a chatroom instance with chatroom ID.
 *
 *  @param aChatroomId   The chatroom ID.
 *
 *  @result The chatroom instance.
 */
+ (instancetype _Nullable)chatroomWithId:(NSString * _Nonnull )aChatroomId;

/**
 *  \
 *  The list of muted members.
 *
 *  Only the chatroom owner can call the method. Returns nil if the user is not the chatroom owner.
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> * _Nullable muteList __deprecated_msg("Use muteMembers instead");

@end
