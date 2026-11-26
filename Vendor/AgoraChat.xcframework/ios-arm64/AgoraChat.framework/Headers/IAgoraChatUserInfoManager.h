//
//  IAgoraChatUserInfoManager.h
//  HyphenateSDK
//
//  Created by lixiaoming on 2021/3/17.
//  Copyright © 2021 easemob.com. All rights reserved.
//

/**
 *  \
 *  @header IAgoraChatUserInfoManager.h
 *  @abstract The user information operation class.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatUserInfo.h"
#import "AgoraChatError.h"
#import "AgoraChatUserInfoManagerDelegate.h"

@protocol IAgoraChatUserInfoManager <NSObject>

#pragma mark - Delegate

/**
 *  \
 *  Adds a delegate.
 *
 *  @param aDelegate  The object that implements the protocol.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<AgoraChatUserInfoManagerDelegate> _Nullable)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id<AgoraChatUserInfoManagerDelegate> _Nonnull)aDelegate;

#pragma mark - User Info

/**
 *  \
 *  Sets all of the user's information.
 *
 *  @param aUserData           The user information data to set.
 *  @param aCompletionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)updateOwnUserInfo:(AgoraChatUserInfo*_Nonnull)aUserData
               completion:(void (^_Nullable)(AgoraChatUserInfo*_Nullable aUserInfo,AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Sets a specific user information of the user.
 *
 *  @param aValue       The user information data to set.
 *  @param aType         The user information type to set.
 *  @param aCompletionBlock   The completion block, which contains the error message if the method fails.
 */
- (void)updateOwnUserInfo:(NSString*_Nullable )aValue
                 withType:(AgoraChatUserInfoType)aType
               completion:(void (^_Nullable )(AgoraChatUserInfo*_Nullable aUserInfo,AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the user information by user ID.
 *
 *  @param aUserIds            The user ID list.
 *  @param aCompletionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)fetchUserInfoById:(NSArray<NSString*>*_Nonnull)aUserIds
               completion:(void (^_Nullable)(NSDictionary<NSString*,AgoraChatUserInfo*> *_Nullable aUserDatas,AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Gets the specific user information by user ID.
 *
 *  @param aUserIds              The user ID list.
 *  @param aType                 The user information type list.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method fails.
 */
- (void)fetchUserInfoById:(NSArray<NSString*>* _Nonnull)aUserIds
                     type:(NSArray<NSNumber*>*_Nonnull)aType
               completion:(void (^_Nullable)(NSDictionary<NSString*,AgoraChatUserInfo*> *_Nullable aUserDatas,AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the user information from local memory by user ID.
 *
 *  @param aUserIds            The user ID list.
 *  @param aCompletionBlock    The completion block, which contains the error message if the method fails.
 */
- (NSDictionary<NSString*,AgoraChatUserInfo*> *_Nullable)getUserInfoByIds:(NSArray<NSString*>*_Nonnull)aUserIds;

/**
 *  \
 *  Subscribes to user attribute update events of non-friend users by user ID.
 *
 *  @param userIds            The array of user IDs to subscribe to.
 *  @param completionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)subscribeUsersInfo:(NSArray<NSString*>*_Nonnull)userIds
                       completion:(void (^_Nullable)(AgoraChatError *_Nullable error))completionBlock;
/**
 *  \
 *  Unsubscribes from user attribute update events of non-friend users by user ID.
 *
 *  @param userIds            The array of user IDs to unsubscribe from.
 *  @param completionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)unsubscribeUsersInfo:(NSArray<NSString*>*_Nonnull)userIds
                         completion:(void (^_Nullable)(AgoraChatError *_Nullable error))completionBlock;
/**
 *  \
 *  Gets user attributes of non-friend users whose attribute update events are subscribed to.
 * 
 *  @param completionBlock    The completion block, which contains the error message if the method fails.
 */
- (void)fetchSubscribedUsers:(void (^_Nullable)(NSArray<AgoraChatUserInfo*> *_Nullable users,AgoraChatError *_Nullable error))completionBlock;
@end

