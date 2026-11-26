//
//  IAgoraChatPresenceManager.h
//  AgoraChat
//
//  Created by lixiaoming on 2022/1/14.
//  Copyright © 2022 easemob.com. All rights reserved.
//

/*!
 *  \
 *  @header IAgoraChatPresenceManager.h
 *  @abstract The presence management class, responsible for publishing a custom presence state, managing presence subscriptions, querying the current presence state of a user, and adding and removing a delegate.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatPresenceManagerDelegate.h"
#import "AgoraChatError.h"

/*!
 *  \
 *  The presence management protocol that defines how to manage presence states.
 */
@protocol IAgoraChatPresenceManager <NSObject>
/*!
 *  \
 *  Publishes a custom presence state.
 *
 *  @param aDescription The extension information of the presence state. It can be set as nil.
 *  @param aCompletion The completion block, which contains the error message if this method fails.
 */
- (void) publishPresenceWithDescription:(NSString*_Nullable )aDescription
                             completion:(void(^_Nullable )(AgoraChatError*_Nullable error))aCompletion;
/*!
 *  \
 *  Subscribes to a user's presence states. If the subscription succeeds, the subscriber will receive the callback when the user's presence state changes.
 *
 *  @param members The array of IDs of users whose presence states you want to subscribe to.
    @param expiry The expiration time of the presence subscription.
 *  @param aCompletion The completion block, which contains the error message if the method fails.
 */
- (void) subscribe:(NSArray<NSString*>*_Nonnull)members
            expiry:(NSInteger)expiry
        completion:(void(^_Nullable )(NSArray<AgoraChatPresence*>*_Nullable presences,AgoraChatError*_Nullable error))aCompletion;

/*!
 *  \
 *  Unsubscribes from a user's presence states.
 *
 *  @param members The array of IDs of users whose presence states you want to unsubscribe from.
 *  @param aCompletion The completion block, which contains the error message if the method fails.
 */
- (void) unsubscribe:(NSArray<NSString*>*_Nonnull) members
          completion:(void(^_Nullable )(AgoraChatError*_Nullable error))aCompletion;

/*!
 *  \
 *  Uses pagination to get a list of users whose presence states you have subscribed to.
 *
 *  @param pageNum The current page number, starting from 1.
 *  @param pageSize  The number of subscribed users on each page.
 *  @param aCompletion The completion block, which contains IDs of users whose presence states you have subscribed to. Returns nil if you subscribe to no user's presence state.
 */
- (void) fetchSubscribedMembersWithPageNum:(NSUInteger)pageNum
                                  pageSize:(NSUInteger)pageSize
                                Completion:(void(^_Nullable )(NSArray<NSString*>*_Nullable  members,AgoraChatError*_Nullable error))aCompletion;
/*!
 *  \
 *  Gets the current presence state of users.
 *
 *  @param members The array of IDs of users whose current presence state you want to check.
 *  @param aCompletion The completion block, which contains the users whose presence state you have subscribed to.
 */
- (void) fetchPresenceStatus:(NSArray<NSString*>*_Nonnull )members
                  completion:(void(^_Nullable )(NSArray<AgoraChatPresence*>* _Nullable presences,AgoraChatError*_Nullable error))aCompletion;
/*!
 *  \
 *  Adds a delegate.
 *
 *  @param aDelegate  The delegate to be added.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as nil.
 */
- (void) addDelegate:(id<AgoraChatPresenceManagerDelegate> _Nonnull)aDelegate
       delegateQueue:(dispatch_queue_t _Nullable )aQueue;
/*!
 *  \
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void) removeDelegate:(id<AgoraChatPresenceManagerDelegate> _Nonnull)aDelegate;
@end
/* IAgoraChatPresenceManager_h */


