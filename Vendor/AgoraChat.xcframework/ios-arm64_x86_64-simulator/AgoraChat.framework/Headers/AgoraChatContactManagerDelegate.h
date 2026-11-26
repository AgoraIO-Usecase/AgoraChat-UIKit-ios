/**
 *  \
 *  @header     AgoraChatContactManagerDelegate.h
 *  @abstract   The protocol of contact callbacks definitions
 *  @author     Hyphenate
 *  @version    3.00
 */

#import <Foundation/Foundation.h>

@class AgoraChatContact;
@class AgoraChatError;

/**
 *  \
 *  The contact related callbacks.
 */
@protocol AgoraChatContactManagerDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when a friend request is approved, user A will receive this callback after user B approved user A's friend request.
 *
 *  @param aUsername    The user ID who approves a friend's request.
 */
- (void)friendRequestDidApproveByUser:(NSString * _Nonnull)aUsername;

/**
 *  \
 *  Occurs when a friend request is declined.
 *
 *  User A will receive this callback after user B declined user A's friend request.
 *
 *  @param aUsername   The user ID who declined a friend request.
 */
- (void)friendRequestDidDeclineByUser:(NSString * _Nonnull)aUsername;

/**
 *  \
 *  Occurs when a user is removed as a contact by another user.
 *
 *  User A and B both will receive this callback after User B unfriended User A.
 *
 *  @param aUsername   The user who unfriended the current user
 */
- (void)friendshipDidRemoveByUser:(NSString * _Nonnull)aUsername;

/**
 *  \
 *  Occurs when the user is added as a contact by another user.
 *
 *  Both user A and B will receive this callback after User B agreed user A's add-friend invitation.
 *
 *  @param aUsername   The user ID of the peer user.
 */
- (void)friendshipDidAddByUser:(NSString *_Nonnull)aUsername;

/**
 *  \
 *  Occurs when a user receives a friend request.
 *
 *  User A will receive this callback when receiving a friend request from User B.
 *
 *  @param aUsername   Friend request sender user ID
 *  @param aMessage    Friend request message
 */
- (void)friendRequestDidReceiveFromUser:(NSString *_Nonnull)aUsername
                                message:(NSString *_Nullable)aMessage;
/**
 * \
 *  Occurs when the contact information changes.
 * 
 *  @param contact The contact object which contains the contact information object `AgoraChatUserInfo`.
 */
- (void)onFriendInfoChanged:(AgoraChatContact * _Nonnull)contact;

@end
