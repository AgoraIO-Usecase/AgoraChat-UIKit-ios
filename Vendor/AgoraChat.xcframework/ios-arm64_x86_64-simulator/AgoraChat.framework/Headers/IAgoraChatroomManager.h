/**
 *  \
 *  @header IAgoraChatroomManager.h
 *  @abstract This protocol defines the chat room operations.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatCommonDefs.h"
#import "AgoraChatroomManagerDelegate.h"
#import "AgoraChatroomOptions.h"
#import "AgoraChatroom.h"
#import "AgoraChatPageResult.h"

#import "AgoraChatCursorResult.h"

@class AgoraChatError;

/**
 *  \
 *  A class that manages the chatrooms.
 */
@protocol IAgoraChatroomManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \
 *  Adds the SDK delegate.
 *
 *  @param aDelegate  The delegate that you want to add: ChatroomManagerDelegate.
 *  @param aQueue     (Optional) The queue of calling the delegate methods. To run the app on the main thread, set this parameter as nil.
 */
- (void)addDelegate:(id<AgoraChatroomManagerDelegate> _Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable)aQueue;

/**
 *  \
 *  Removes the delegate.
 *
 *  @param aDelegate  The delegate that you want to remove.
 */
- (void)removeDelegate:(id<AgoraChatroomManagerDelegate> _Nonnull)aDelegate;

#pragma mark - Fetch Chatrooms

/**
 *  \
 *  Gets the specified number of chat rooms from the server.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chat room list. See AgoraChatPageResult.
 */
- (AgoraChatPageResult<AgoraChatroom*> *_Nullable)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                                                 pageSize:(NSInteger)aPageSize
                                                    error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Gets the specified number of chat rooms from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */

- (void)getChatroomsFromServerWithPage:(NSInteger)aPageNum
                              pageSize:(NSInteger)aPageSize
                            completion:(void (^_Nullable)(AgoraChatPageResult<AgoraChatroom*> *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;


#pragma mark - Edit Chatroom

/**
 *  \
 *  Joins a chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result  The chatroom instance.
 */
- (AgoraChatroom *)joinChatroom:(NSString * _Nonnull)aChatroomId
                       error:(AgoraChatError ** _Nullable)pError;

/**
 *  \
 *  Joins a chatroom.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId          The chatroom ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)joinChatroom:(NSString *_Nonnull)aChatroomId
          completion:(void (^_Nullable)(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Joins the chat room.
 *
 *  This is an asynchronous method.
 *
 *  @param aChatroomId           The chat room ID.
 *  @param ext                           The extension information.
 *  @param leaveOtherRooms     Whether to leave all the currently joined chat rooms when joining a chat room.
                                                   - `YES`：Yes.  The user joins the chat room, while leaving all other chat rooms.
                                                   -  (Default) `NO`:  No. The user joins the chat room, without leaving all other chat rooms.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)joinChatroom:(NSString *_Nonnull)aChatroomId
                 ext:(NSString* _Nullable)ext
     leaveOtherRooms:(BOOL)leaveOtherRooms
          completion:(void (^_Nullable)(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Leaves a chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 */
- (void)leaveChatroom:(NSString *_Nonnull)aChatroomId
                error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Leaves a chatroom.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId          The chatroom ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)leaveChatroom:(NSString *_Nonnull)aChatroomId
           completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Fetch

/**
 *  \
 *  Fetches the specific chatroom.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId           The chatroom ID.
 *  @param pError                The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable)getChatroomSpecificationFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                            error:(AgoraChatError *_Nullable*)pError;

/**
 *  \
 *  Fetches the chat room specifications.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId           The chatroom ID.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomSpecificationFromServerWithId:(NSString *_Nonnull)aChatroomId
                                      completion:(void (^_Nullable)(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Fetches the chat room specifications.
 *
 *  This is an asynchronous method.
 *
 *  @param aChatroomId           The chatroom ID.
 *  @param aFetchMembers         Whether to get the member list. If you set the parameter as YES, it will return no more than 200 members.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomSpecificationFromServerWithId:(NSString *_Nonnull)aChatroomId
                                    fetchMembers:(bool)aFetchMembers
                                      completion:(void (^_Nullable)(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the list of chatroom members from the server.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCursor          The cursor. Set this parameter as nil when you call this method for the first time.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result    The list of chatroom members and the cursor.
 *
 */
- (AgoraChatCursorResult<NSString*> *_Nullable)getChatroomMemberListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                            cursor:(NSString *_Nullable)aCursor
                                                          pageSize:(NSInteger)aPageSize
                                                             error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Gets the list of chatroom members from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCursor          The cursor. Set this parameter as nil when you call this method for the first time.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomMemberListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                       cursor:(NSString *_Nullable)aCursor
                                     pageSize:(NSInteger)aPageSize
                                   completion:(void (^_Nullable)(AgoraChatCursorResult<NSString*> *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the blocklist of chatroom from the server. 
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 */
- (NSArray<NSString *> *_Nullable)getChatroomBlacklistFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                            pageNumber:(NSInteger)aPageNum
                                                              pageSize:(NSInteger)aPageSize
                                                                 error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Gets the chatroom's blocklist. 
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomBlacklistFromServerWithId:(NSString *_Nonnull)aChatroomId
                                  pageNumber:(NSInteger)aPageNum
                                    pageSize:(NSInteger)aPageSize
                                  completion:(void (^_Nullable)(NSArray<NSString *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the list of members who are muted in the chatroom from the server.
 *
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param pError           The error information if the method fails: Error.
 *
 */
- (NSArray<NSString *> *_Nullable)getChatroomMuteListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                           pageNumber:(NSInteger)aPageNum
                                                             pageSize:(NSInteger)aPageSize
                                                                error:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Gets the list of members who were muted in the chatroom from the server.
 *
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomMuteListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                 pageNumber:(NSInteger)aPageNum
                                   pageSize:(NSInteger)aPageSize
                                 completion:(void (^_Nullable)(NSArray<NSString *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Gets the allowlist of a chatroom from the server.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 */
- (NSArray<NSString *> *_Nullable)getChatroomWhiteListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                                                 error:(AgoraChatError **_Nullable)pError;


/**
 *  \
 *  Gets the allowlist of a chatroom from the server.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomWhiteListFromServerWithId:(NSString *_Nonnull)aChatroomId
                                  completion:(void (^_Nullable)(NSArray<NSString *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Checks whether the current user is on the allowlist.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 */
- (BOOL)isMemberInWhiteListFromServerWithChatroomId:(NSString *_Nonnull)aChatroomId
                                              error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Checks whether the current user is on the allowlist.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)isMemberInWhiteListFromServerWithChatroomId:(NSString *_Nonnull)aChatroomId
                                         completion:(void (^_Nullable)(BOOL inWhiteList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Checks whether the current user is on the mute list.
 *
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)isMemberInMuteListFromServerWithChatroomId:(NSString *_Nonnull)aChatroomId
                                        completion:(void (^_Nullable)(BOOL inMuteList, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Gets the announcement of a chatroom from the server.
 * 
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result    The announcement of chatroom.
 */
- (NSString *_Nullable)getChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                                               error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Gets the announcement of a chatroom from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)getChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                           completion:(void (^_Nullable)(NSString *_Nullable aAnnouncement, AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Edit

/**
 *  \
 *  Changes the chatroom‘s subject. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aSubject     The new subject of the chatroom.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result    The chatroom instance.
 */
- (AgoraChatroom *)updateSubject:(NSString *_Nullable )aSubject
                  forChatroom:(NSString *_Nonnull)aChatroomId
                        error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Changes the chatroom subject. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aSubject         The new subject of the chatroom.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)updateSubject:(NSString *_Nullable )aSubject
          forChatroom:(NSString *_Nonnull)aChatroomId
           completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Changes chatroom description. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aDescription The new description.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result    The chatroom instance.
 */
- (AgoraChatroom *_Nullable )updateDescription:(NSString *_Nullable )aDescription
                                forChatroom:(NSString *_Nonnull)aChatroomId
                                      error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Changes the chatroom's description. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aDescription     The new description.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)updateDescription:(NSString *_Nullable )aDescription
              forChatroom:(NSString *_Nonnull)aChatroomId
               completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes members from a chatroom. 
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers     The users to be removed from the chatroom.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result    The chatroom instance.
 */
- (AgoraChatroom *_Nullable )removeMembers:(NSArray<NSString *> *_Nonnull)aMembers
                           fromChatroom:(NSString *_Nonnull)aChatroomId
                                  error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Removes members from a chatroom. 
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method. 
 *
 *  @param aMembers         The users to be removed from the chatroom.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)removeMembers:(NSArray<NSString *> *_Nonnull)aMembers
         fromChatroom:(NSString *_Nonnull)aChatroomId
           completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds users to the chatroom's blocklist. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers     The users to be added to the blocklist.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result    The chatroom instance.
 */
- (AgoraChatroom *_Nullable )blockMembers:(NSArray<NSString *> *_Nonnull)aMembers
                          fromChatroom:(NSString *_Nonnull)aChatroomId
                                 error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Adds users to the chatroom's blocklist. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMembers         The users to be added to the chatroom.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)blockMembers:(NSArray<NSString *> *_Nonnull)aMembers
        fromChatroom:(NSString *_Nonnull)aChatroomId
          completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Removes users from chatroom blocklist.
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers     The users to be removed from the blocklist.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result    The chatroom instance.
 */
- (AgoraChatroom *_Nullable )unblockMembers:(NSArray<NSString *> *_Nonnull)aMembers
                            fromChatroom:(NSString *_Nonnull)aChatroomId
                                   error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Removes users from the chatroom blocklist. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 * 
 *  @param aMembers         The users to be removed from the blocklist.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)unblockMembers:(NSArray<NSString *> *_Nonnull)aMembers
          fromChatroom:(NSString *_Nonnull)aChatroomId
            completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Changes the chatroom owner. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId  The chatroom ID.
 *  @param aNewOwner    The new owner.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )updateChatroomOwner:(NSString *_Nonnull)aChatroomId
                                     newOwner:(NSString *_Nonnull)aNewOwner
                                        error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Changes the chatroom owner. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aNewOwner        The new owner.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)updateChatroomOwner:(NSString *_Nonnull)aChatroomId
                   newOwner:(NSString *_Nonnull)aNewOwner
                 completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds a chatroom admin. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aAdmin       The new admin.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result  The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )addAdmin:(NSString *_Nonnull)aAdmin
                        toChatroom:(NSString *_Nonnull)aChatroomId
                             error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Adds a chatroom admin. 
 * 
 *  Only the chatroom owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aAdmin           The new admin.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)addAdmin:(NSString *_Nonnull)aAdmin
      toChatroom:(NSString *_Nonnull)aChatroomId
      completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroomp, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes a chatroom admin. 
 * 
 *  Only the chatroom owner can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aAdmin       The admin to be removed.
 *  @param aChatroomId  The chatroom ID.
 *  @param pError       The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )removeAdmin:(NSString *_Nonnull)aAdmin
                         fromChatroom:(NSString *_Nonnull)aChatroomId
                                error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Removes a chatroom admin. 
 * 
 *  Only the chatroom owner and admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aAdmin           The admin to be removed.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)removeAdmin:(NSString *_Nonnull)aAdmin
       fromChatroom:(NSString *_Nonnull)aChatroomId
         completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Mutes chatroom members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMuteMembers         The list of members to mute.
 *  @param aMuteMilliseconds    Muted time duration in millisecond.
 *  @param aChatroomId          The chatroom ID.
 *  @param pError               The error information if the method fails: Error.
 *
 *  @result  The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )muteMembers:(NSArray<NSString *> *_Nonnull)aMuteMembers
                     muteMilliseconds:(NSInteger)aMuteMilliseconds
                         fromChatroom:(NSString *_Nonnull)aChatroomId
                                error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Mutes chatroom members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is an asynchronous method.
 *
 *  @param aMuteMembers         The list of mute.
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aChatroomId          The chatroom ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method call fails.
 *
 */
- (void)muteMembers:(NSArray<NSString *> *_Nonnull)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
       fromChatroom:(NSString *_Nonnull)aChatroomId
         completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Unmutes chatroom members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers         The list of members to unmute.
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )unmuteMembers:(NSArray<NSString *> *_Nonnull)aMembers
                           fromChatroom:(NSString *_Nonnull)aChatroomId
                                  error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Unmutes chatroom members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is an asynchronous method.
 *
 *  @param aMembers         The list of unmute.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)unmuteMembers:(NSArray<NSString *> *_Nonnull)aMembers
         fromChatroom:(NSString *_Nonnull)aChatroomId
           completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;



/**
 *  \
 *  Mutes all members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )muteAllMembersFromChatroom:(NSString *_Nonnull)aChatroomId
                                               error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Mutes all members. 
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 * 
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)muteAllMembersFromChatroom:(NSString *_Nonnull)aChatroomId
                        completion:(void(^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Unmute all members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )unmuteAllMembersFromChatroom:(NSString *_Nonnull)aChatroomId
                                                 error:(AgoraChatError **_Nullable )pError;


/**
 *  \
 *  Unmute all members.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)unmuteAllMembersFromChatroom:(NSString *_Nonnull)aChatroomId
                          completion:(void(^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Adds users to the allowlist.
 * 
 *  Only the chatroom owner and admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers         The members to be added to the allowlist.
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )addWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers
                                 fromChatroom:(NSString *_Nonnull)aChatroomId
                                        error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Adds members to the allowlist.
 * 
 *  Only the chatroom owner and admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMembers         The members to be added to the allowlist.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)addWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers
               fromChatroom:(NSString *_Nonnull)aChatroomId
                 completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes the members of the allowlist.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aMembers         The members to be removed from the allowlist.
 *  @param aChatroomId      The chatroom ID.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result   The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )removeWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers
                                    fromChatroom:(NSString *_Nonnull)aChatroomId
                                           error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Removes members from the allowlist.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMembers         The members to be removed from the allowlist.
 *  @param aChatroomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)removeWhiteListMembers:(NSArray<NSString *> *_Nonnull)aMembers
                  fromChatroom:(NSString *_Nonnull)aChatroomId
                    completion:(void (^_Nullable )(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Changes the announcement of the chatroom.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aAnnouncement    The announcement of the chatroom.
 *  @param pError           The error information if the method fails: Error.
 *
 *  @result  The chatroom instance. See AgoraChatroom.
 */
- (AgoraChatroom *_Nullable )updateChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                                              announcement:(NSString *_Nullable )aAnnouncement
                                                     error:(AgoraChatError **_Nullable )pError;

/**
 *  \
 *  Changes the announcement of chatroom.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chatroom ID.
 *  @param aAnnouncement    The announcement of the chatroom.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)updateChatroomAnnouncementWithId:(NSString *_Nonnull)aChatroomId
                            announcement:(NSString *_Nullable)aAnnouncement
                              completion:(void (^_Nullable)(AgoraChatroom *_Nullable aChatroom, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Sets custom attributes of the chat room.
 * 
 *  @note
 *  This method does not overwrite attributes set by others.
 * 
 *  This is an asynchronous method.
 *
 *  @param roomId      The chat room ID.
 *  @param attributes  The custom chat room attributes in key-value pairs, where the key is the attribute name and the value is the attribute value.
 *  @param autoDelete  Whether to delete the chat room attributes set by the member when he or she exits the chat room.
      * - (Default)`YES`: Yes;
      * - `NO`: No.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)setChatroomAttributes:(NSString *_Nonnull)roomId attributes:(NSDictionary<NSString*,NSString*> *_Nonnull)keyValues autoDelete:(BOOL)autoDelete completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError,NSDictionary<NSString*,AgoraChatError*> *_Nullable failureKeys))completionBlock ;
/**
 *  \
 *  Sets a custom chat room attribute.
 * 
 *  @note
 *  This method does not overwrite attributes set by others.
 * 
 *  This is an asynchronous method.
 *
 *  @param roomId    The chat room ID.
 *  @param key       The chat room attribute key that specifies the attribute name. The attribute name can contain 128 characters at most. 
	 *               A chat room can have a maximum of 100 custom attributes. The following character sets are supported:
      * - 26 lowercase English letters (a-z)
      * - 26 uppercase English letters (A-Z)
      * - 10 numbers (0-9)
      * - "_", "-", "."
 *  @param value     The chat room attribute value. The attribute value can contain a maximum of 4096 characters. The total length of custom chat room attributes cannot exceed 10 GB for each app.
 *  @param autoDelete  Whether to delete the custom chat room attributes set by the member when he or she exits the chat room.
      * - (Default)`YES`: Yes;
      * - `NO`: No.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)setChatroomAttribute:(NSString *_Nonnull)roomId key:(NSString *_Nonnull)key value:(NSString *_Nonnull)value autoDelete:(BOOL)autoDelete completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError))completionBlock;
/**
 *  \
 *  Sets custom chat room attributes forcibly.
 * 
 *  @note
 *  This method overwrites attributes set by others.
 * 
 *  This is an asynchronous method.
 *
 *  @param roomId      The chat room ID.
 *  @param attributes    The custom chat room attributes in key-value pairs, where the key is the attribute name and the value is the attribute value.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)setChatroomAttributesForced:(NSString *_Nonnull)roomId attributes:(NSDictionary<NSString*,NSString*> *_Nonnull)keyValues autoDelete:(BOOL)autoDelete completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError,NSDictionary<NSString*,AgoraChatError*> *_Nullable failureKeys))completionBlock;

/**
 *  \
 *  Sets a custom chat room attribute forcibly.
 * 
 *  @note
 *  This method overwrites attributes set by others.
 * 
 *  This is an asynchronous method.
 *
 *  @param roomId      The chat room ID.
 *  @param key         The chat room attribute key that specifies the attribute name. The attribute name can contain 128 characters at most. 
 *                 A chat room can have a maximum of 100 custom attributes. The following character sets are supported:
 * - 26 lowercase English letters (a-z)
 * - 26 uppercase English letters (A-Z)
 * - 10 numbers (0-9)
 * - "_", "-", "."
 *  @param value       The attribute value to set. A single Value can not exceed 4096 characters. The total attribute can not exceed 10 GB.
 *  @param autoDelete  Whether to delete the chat room attributes set by the member when he or she exits the chat room.
 * - (Default)`YES`: Yes;
 * - `NO`: No.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)setChatroomAttributeForced:(NSString *_Nonnull)roomId key:(NSString *_Nonnull)key value:(NSString *_Nonnull)value autoDelete:(BOOL)autoDelete completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError))completionBlock;

/**
 *  \
 *  Removes custom chat room attributes.
 * 
 *  @note
 *  This method does not remove attributes set by other members.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chat room ID.
 *  @param attributes       The keys of the chat room attributes to remove. 
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)removeChatroomAttributes:(NSString *_Nonnull)roomId attributes:(NSArray <__kindof NSString*> * _Nonnull)keyValues completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError,NSDictionary<NSString*,AgoraChatError*> *_Nullable failureKeys))completionBlock;
/**
 *  \
 *  Removes a custom chat room attribute.
 * 
 *  @note
 *  This method does not remove attributes set by other members.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chat room ID.
 *  @param key              The key of the chat room attribute to remove. 
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key, and the value is the reason for the failure.
 *
 */
- (void)removeChatroomAttribute:(NSString *_Nonnull)roomId key:(NSString * _Nonnull)key completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError))completionBlock;
/**
 *  \
 *  Removes custom chat room attributes forcibly.
 * 
 *  @note
 *  This method removes attributes set by other members.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chat room ID.
 *  @param keyValues        The array of chat room attribute keys. 
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails.
 *
 */
- (void)removeChatroomAttributesForced:(NSString *_Nonnull)roomId attributes:(NSArray <__kindof NSString*> * _Nonnull)keyValues completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError,NSDictionary<NSString*,AgoraChatError*> *_Nullable failureKeys))completionBlock;

/**
 *  \
 *  Removes custom chat room attributes forcibly.
 * 
 *  @note
 *  This method removes attributes set by other members.
 * 
 *  This is an asynchronous method.
 *
 *  @param aChatroomId      The chat room ID.
 *  @param key              The keys of the custom chat room attributes to remove.
 *  @param aCompletionBlock The completion block, which contains the error message if the method call fails. If certain attribute keys fail to be added, the SDK returns `failureKeys map` in key-value format, where the key is the attribute key and the value is the reason for the failure.
 *
 */
- (void)removeChatroomAttributeForced:(NSString *_Nonnull)roomId key:(NSString * _Nonnull)key completionBlock:(void (^_Nullable)(AgoraChatError *_Nullable aError))completionBlock;
/**
 *  \
 *  Fetch the properties of chatroom form sever.
 *  This is an asynchronous method.
 *
 *  @param roomId      The chatroom ID.
 *  @param keys      Chat room attribute keys.Empty callback all.
 *  @param aCompletionBlock The completion block, which contains keyValues and the error message if the method call fails.
 *
 */
- (void)fetchChatroomAttributes:(NSString *_Nonnull)roomId keys:(NSArray <__kindof NSString *> * _Nullable)keys completion:(void (^_Nullable)(AgoraChatError *_Nullable aError,NSDictionary<NSString*,NSString*> *_Nullable properties ))completionBlock;
/**
 *  \
 *  Fetch the properties of chatroom form sever.
 *  This is an asynchronous method.
 *
 *  @param roomId      The chatroom ID.
 *  @param aCompletionBlock The completion block, which contains keyValues and the error message if the method call fails.
 *
 */
- (void)fetchChatroomAllAttributes:(NSString * _Nonnull)roomId completion:(void (^ _Nullable)(AgoraChatError * _Nullable error,NSDictionary<NSString*,NSString*> * _Nullable properties))completionBlock;

@end
