//
//  IAgoraChatThreadManager.h
//  AgoraChat
//
//  Created by 朱继超 on 2022/3/1.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatThreadManagerDelegate.h"
#import "AgoraChatThread.h"
#import "AgoraChatCursorResult.h"
@class AgoraChatMessage;
NS_ASSUME_NONNULL_BEGIN
@protocol IAgoraChatThreadManager <NSObject>
@required

#pragma mark - Delegate

/*!
 *  \
 *  Add delegate
 *
 *  @param aDelegate  Delegate is kindof protocol AgoraChatThreadManagerDelegate
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<AgoraChatThreadManagerDelegate>)aDelegate
      delegateQueue:(_Nullable dispatch_queue_t)aQueue;

/*!
 *  \
 *  Remove delegate
 *
 *  @param aDelegate   Delegate is kindof protocol AgoraChatThreadManagerDelegate
 */
- (void)removeDelegate:(id<AgoraChatThreadManagerDelegate>)aDelegate;


#pragma mark - Get Thread
/*!
 *  \
 *  Get the thread detail
 *  @param threadId The id of the subarea to get
 *  @param aCompletionBlock Returns the callback, containing an AgoraChatThread object and an AgoraChatError error object
 */
- (void)getChatThreadFromSever:(NSString *)threadId completion:(void (^)(AgoraChatThread *_Nullable  thread, AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Get the subzones the user has joined from the server
 *  @param aCursor cursor The position cursor of the last fetch
 *  @param pageSize Number of single requests limit 50
 *  @param aCompletionBlock Returns the callback, containing an AgoraChatCursorResult object and an AgoraChatError error object
 */
- (void)getJoinedChatThreadsFromServerWithCursor:(NSString *)aCursor
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^)(AgoraChatCursorResult<AgoraChatThread*>* _Nullable result, AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Get the subareas under a group from the server
 *  @param parentId The session id of the upper level of the sub-area
 *  @param aCursor The position cursor of the last fetch
 *  @param pageSize Number of single requests limit 50
 *  @param aCompletionBlock Returns the callback, containing an AgoraChatCursorResult object and an AgoraChatError error object
 */
- (void)getChatThreadsFromServerWithParentId:(NSString *)parentId cursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize completion:(void (^)(AgoraChatCursorResult<AgoraChatThread*> * _Nullable result, AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Get the mine subareas  under a group from the server
 *  @param parentId The session id of the upper level of the sub-area
 *  @param aCursor The position cursor of the last fetch
 *  @param pageSize Number of single requests limit 50
 *  @param aCompletionBlock Returns the callback, containing an AgoraChatCursorResult object and an AgoraChatError error object
 */
- (void)getJoinedChatThreadsFromServerWithParentId:(NSString *)parentId cursor:(NSString *)aCursor pageSize:(NSInteger)aPageSize completion:(void (^)(AgoraChatCursorResult<AgoraChatThread*> * _Nullable result, AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Get a list of members in a subsection
 *  @param threadId The id of the subarea to get members
 *  @param aCursor cursor The position cursor of the last fetch
 *  @param pageSize Number of single requests limit 50
 *  @param aCompletionBlock Returns the callback, containing an AgoraChatCursorResult object and an AgoraChatError error object
 */
- (void)getChatThreadMemberListFromServerWithId:(NSString *)threadId cursor:(NSString *)aCursor pageSize:(NSInteger)pageSize completion:(void (^)(AgoraChatCursorResult<NSString*> * _Nullable aResult, AgoraChatError * _Nullable aError))aCompletionBlock;

/*!
 *  \
 *  Get the thread detail
 *  @param threadIds The ids of the subarea to get(No more than 20 ids for a single request)
 *  @param aCompletionBlock Return the callback, including a dictionary key is the sub-area id, value is the AgoraChatMessage object
 */
- (void)getLastMessageFromSeverWithChatThreads:(NSArray <NSString *>*)threadIds completion:(void (^)(NSDictionary<NSString*,AgoraChatMessage*>* _Nullable messageMap, AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Remove sub-zone members (only available for group management)
 *  @param aUser To remove the user's ease id
 *  @param athreadId subarea id to operate
 *  @param aCompletionBlock return callback, success or failure
 */
- (void)removeMemberFromChatThread:(NSString *)aUser
             threadId:(NSString *)athreadId
           completion:(void (^)(AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Update subzone name (only available for group managers or creators)
 *  @param name the name you want to change（limit 64 character）
 *  @param threadId subarea id to operate
 *  @param aCompletionBlock return callback, success or failure
 */
- (void)updateChatThreadName:(NSString *)name
                  threadId:(NSString *)athreadId
                 completion:(void (^)(AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  Create a subsection
 *  @param threadName The id of the subarea to get（limit 64 character）
 *  @param messageId The message id of the operation to create the sub-area
 *  @param parentId The session id where the message of the operation creates the sub-area is also the to of that message
 *  @param completion Returns the callback, containing an AgoraChatThread object and an AgoraChatError error object
 */
- (void)createChatThread:(NSString *)threadName messageId:(NSString *)messageId parentId:(NSString *)parentId completion:(void (^)(AgoraChatThread *_Nullable  thread,AgoraChatError * _Nullable aError))aCompletionBlock;
/*!
 *  \
 *  join a subsection
 *  @param threadId The id of the subzone to join
 *  @param aCompletionBlock return callback, success or failure
 */
- (void)joinChatThread:(NSString *)threadId completion:(void (^)(AgoraChatThread *_Nullable  thread,AgoraChatError * _Nullable aError))aCompletionBlock;

/*!
 *  \
 *  leave a subsection
 *  @param threadId The id of the subzone to leave
 *  @param aCompletionBlock return callback, success or failure
 */
- (void)leaveChatThread:(NSString *)athreadId completion:(void (^)(AgoraChatError * _Nullable aError))aCompletionBlock;

/*!
 *  \
 *  destroy a subsection
 *  @param threadId The id of the subzone to destroy
 *  @param aCompletionBlock return callback, success or failure
 */
- (void)destroyChatThread:(NSString *)athreadId completion:(void (^)(AgoraChatError * _Nullable aError))aCompletionBlock;

@end
NS_ASSUME_NONNULL_END
