/**
 *  \
 *  @header IAgoraChatGroupManager.h
 *  @abstract This protocol defines the group operations.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatCommonDefs.h"
#import "AgoraChatGroupManagerDelegate.h"
#import "AgoraChatGroup.h"
#import "AgoraChatGroupConfigs.h"
#import "AgoraChatCursorResult.h"
#import "AgoraChatGroupSharedFile.h"

/**
 *  \
 *  The group operations.
 */
@protocol IAgoraChatGroupManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \
 *  Adds delegate.
 *
 *  @param aDelegate  The delegate to be added.
 *  @param aQueue     (optional) The queue of calling delegate methods. Pass in nil to run on main thread.
 */
- (void)addDelegate:(id<AgoraChatGroupManagerDelegate> _Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable )aQueue;

/**
 *  \
 *  Removes delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id _Nonnull)aDelegate;


#pragma mark - Get Group

/**
 *  \
 *  Gets the local information of all groups created and joined by the current user.
 *
 *  @result  The group list.
 *
 */
- (NSArray<AgoraChatGroup *> *_Nullable )getJoinedGroups;

/**
 *  \
 *  Clears the information of all groups in the local database.
 *
 */
- (void)cleanAllGroupsFromDB;


#pragma mark - Get group from server

/**
 * \
 * Gets groups count of the current user joined from the server.
 *
 * This is an asynchronous method.
 *
 * @param aCompletionBlock             The completion block, which contains the error message if the method fails.
 *
 */
- (void)getJoinedGroupsCountFromServerWithCompletion:(void (^_Nullable)(NSInteger groupCount, AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Create

/**
 *  \
 *  Creates a group(with group avatar).
 *
 *  This is an asynchronous method.
 *
 *  @param subject         The subject of the group.
 *  @param avatar          The group avatar.
 *  @param description     The description of the group.
 *  @param invitees        The members of the group. Do not include the creator.
 *  @param message         The invitation message.
 *  @param setting         The group options.
 *  @param completionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)createGroupWithSubject:(NSString *_Nullable)subject
                    avatar:(NSString *_Nullable)avatar
                   description:(NSString *_Nullable)description
                      invitees:(NSArray<NSString *> * _Nullable)invitees
                       message:(NSString *_Nullable)message
                       setting:(AgoraChatGroupConfigs *_Nullable)setting
                    completion:(void (^_Nullable)(AgoraChatGroup *_Nullable group, AgoraChatError *_Nullable error))completionBlock;

#pragma mark - Fetch Info

/**
 *  \
 *  Fetches the group specification, including: ID, name, description, setting, owner, admins.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId              The group ID.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupSpecificationFromServerWithId:(NSString *_Nonnull)aGroupId
                                   completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Fetches the group specification, including: ID, name, description, setting, owner, admins.
 *
 *  @param aGroupId              The group ID.
 *  @param fetchMembers          Whether to fetch the group members. The default action fetches at most 200 members.
 *  @param aCompletionBlock      The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupSpecificationFromServerWithId:(NSString *_Nonnull)aGroupId
                                 fetchMembers:(BOOL)fetchMembers
                                   completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the list of group members from the server.
 *
 *  @param aGroupId         The group ID.
 *  @param aCursor          The cursor when joins the group. Sets the parameter as nil for the first time.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupMemberListFromServerWithId:(NSString *_Nonnull)aGroupId
                                    cursor:(NSString *_Nullable)aCursor
                                  pageSize:(NSInteger)aPageSize
                                completion:(void (^_Nullable)(AgoraChatCursorResult<NSString*> * _Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the list of group members from the server.
 *
 *  @param groupId         The group ID.
 *  @param cursor          The cursor when joins the group. Sets the parameter as nil for the first time. Next time, pass the value returned last time.
 *  @param limit       The page size.
 *  @param completionBlock The completion block, which contains the error message if the method fails. The result contains the group member's information, including id and join time.
 *
 */
- (void)fetchGroupMemberInfoListFromServerWithGroupId:(NSString *_Nonnull)groupId
                                               cursor:(NSString *_Nonnull)cursor
                                              limit:(NSInteger)limit
                                           completion:(void (^_Nullable)(AgoraChatCursorResult<AgoraChatGroupMemberInfo*>* _Nullable cursorResult, AgoraChatError *_Nullable error))completionBlock;

/**
 *  \
 *  Gets the group's blocklist.
 * 
 *  Only the group owner or admin can call this method.
 *
 *  @param aGroupId         The group ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupBlacklistFromServerWithId:(NSString *_Nonnull)aGroupId
                               pageNumber:(NSInteger)aPageNum
                                 pageSize:(NSInteger)aPageSize
                               completion:(void (^_Nullable)(NSArray<NSString *> * _Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the mutelist of the group from the server.
 *
 *  Only the group owner or admin can call this method.
 *
 *  @param aGroupId         The group ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupMuteListFromServerWithId:(NSString *_Nonnull)aGroupId
                              pageNumber:(NSInteger)aPageNum
                                pageSize:(NSInteger)aPageSize
                              completion:(void (^_Nullable)(NSArray<NSString *> * _Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the mutelist of the group from the server.
 *
 *  Only the group owner or admin can call this method.
 *
 *  @param aGroupId         The group ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)fetchGroupMuteListFromServerWithId:(NSString *_Nonnull)aGroupId
                              pageNumber:(NSInteger)aPageNum
                                pageSize:(NSInteger)aPageSize
                              completion:(void (^_Nullable)(NSDictionary<NSString *, NSNumber *> *_Nullable aDict, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the share files of group from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aPageNum         The page number.
 *  @param aPageSize        The page size.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)getGroupFileListWithId:(NSString *_Nonnull)aGroupId
                    pageNumber:(NSInteger)aPageNum
                      pageSize:(NSInteger)aPageSize
                    completion:(void (^_Nullable)(NSArray<AgoraChatGroupSharedFile *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Gets the allowlist of group from the server.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupWhiteListFromServerWithId:(NSString *_Nonnull)aGroupId
                               completion:(void (^_Nullable)(NSArray<NSString *> * _Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Gets whether the member is on the allowlist.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)isMemberInWhiteListFromServerWithGroupId:(NSString *_Nonnull)aGroupId
                                      completion:(void (^_Nullable)(BOOL inWhiteList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Checks whether the current user is on the mute list of a group.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)isMemberInMuteListFromServerWithGroupId:(NSString * _Nonnull)aGroupId
                                     completion:(void (^ _Nonnull)(BOOL inMuteList, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the announcement of group from the server.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getGroupAnnouncementWithId:(NSString *_Nonnull)aGroupId
                        completion:(void (^_Nullable)(NSString * _Nullable aAnnouncement, AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Public Group

/**
 *  \
 *  Joins a public group. The group must be public and must not require approval for join requests.
 *
 *  @param aGroupId         The public group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)joinPublicGroup:(NSString *_Nonnull)aGroupId
             completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Requests to join a public group that requires approval.
 *
 *  @param aGroupId         The public group ID.
 *  @param aMessage         The information in the request.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)requestToJoinPublicGroup:(NSString *_Nonnull)aGroupId
                         message:(NSString *_Nullable)aMessage
                      completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;
#pragma mark - Edit Group

/**
 *  \
 *  Invites users to join a group.
 *
 *  @param aUsers           The users who are invited to join the group.
 *  @param aGroupId         The group ID.
 *  @param aMessage         The welcome message.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addMembers:(NSArray<NSString *> * _Nonnull)aUsers
           toGroup:(NSString *_Nonnull)aGroupId
           message:(NSString *_Nullable)aMessage
        completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes members from the group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aUsers           The members to be removed from the group.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeMembers:(NSArray<NSString *> * _Nonnull)aUsers
            fromGroup:(NSString *_Nonnull)aGroupId
           completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds users to blocklist of the group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aMembers         The users to be added to the blockList.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)blockMembers:(NSArray<NSString *> * _Nonnull)aMembers
           fromGroup:(NSString *_Nonnull)aGroupId
          completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes users out of the blocklist of the group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aMembers         The users to be removed from the blockList.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)unblockMembers:(NSArray<NSString *> * _Nonnull)aMembers
             fromGroup:(NSString *_Nonnull)aGroupId
            completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Changes the group subject.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aSubject         The new subject of the group.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateGroupSubject:(NSString *_Nullable)aSubject
                  forGroup:(NSString *_Nonnull)aGroupId
                completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Changes the group avatar.
 *
 *  Only the group owner can call this method.
 *
 *  @param avatar         The new subject of the group.
 *  @param groupId         The group ID.
 *  @param completionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateGroupAvatar:(NSString *_Nullable)avatar
                  groupId:(NSString *_Nonnull)groupId
               completion:(void (^_Nullable)(AgoraChatGroup *_Nullable group, AgoraChatError *_Nullable error))completionBlock;

/**
 *  \
 *  Batch updates group configs.
 *
 *  Only the group owner can call this method.
 *
 *  @param groupId The group ID.
 *  @param type The group config fields to update. Values can be combined with bitwise OR. Only selected fields are read from configs.
 *  @param configs The group configs.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)updateGroupWithId:(NSString *_Nonnull)groupId
                    types:(AgoraChatGroupConfigsType)type
                  configs:(AgoraChatGroupConfigs *_Nonnull)configs
               completion:(void (^_Nullable)(AgoraChatGroup *_Nullable
                                             group, AgoraChatError *_Nullable error))aCompletionBlock;
/**
 *  \
 *  Changes the group description.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aDescription     The new group‘s description.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateDescription:(NSString *_Nullable)aDescription
                 forGroup:(NSString *_Nonnull)aGroupId
               completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Leaves a group. The owner can't leave the group, can only destroy the group.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)leaveGroup:(NSString *_Nonnull)aGroupId
        completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Destroys a group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)destroyGroup:(NSString *_Nonnull)aGroupId
    finishCompletion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Blocks group messages, so the server blocks the messages from the group. 
 *  
 *  The group owner can't block the group's messages.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)blockGroup:(NSString *_Nonnull)aGroupId
        completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Unblocks group messages.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)unblockGroup:(NSString *_Nonnull)aGroupId
          completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Changes the owner of the group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aGroupId   The group ID.
 *  @param aNewOwner  The new group owner.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateGroupOwner:(NSString *_Nonnull)aGroupId
                newOwner:(NSString *_Nonnull)aNewOwner
              completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds group admin.
 * 
 *  This is an asynchronous method.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aAdmin      The admin to be added.
 *  @param aGroupId    The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addAdmin:(NSString *_Nonnull)aAdmin
         toGroup:(NSString *_Nonnull)aGroupId
      completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes the group admin.
 * 
 *  Only the group owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aAdmin     The admin to be removed.
 *  @param aGroupId   The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeAdmin:(NSString *_Nonnull)aAdmin
          fromGroup:(NSString *_Nonnull)aGroupId
         completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Mutes group members.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  This is an asynchronous method.
 *
 *  @param aMuteMembers         The list of mute, type is <NSString>
 *  @param aMuteMilliseconds    Muted time duration in millisecond
 *  @param aGroupId             The group ID.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 */
- (void)muteMembers:(NSArray<NSString *> * _Nonnull)aMuteMembers
   muteMilliseconds:(NSInteger)aMuteMilliseconds
          fromGroup:(NSString *_Nonnull)aGroupId
         completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Unmutes group members.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aMembers        The list of members to be unmuted.
 *  @param aGroupId        The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)unmuteMembers:(NSArray<NSString *> * _Nonnull)aMembers
            fromGroup:(NSString *_Nonnull)aGroupId
           completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  mute all members.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)muteAllMembersFromGroup:(NSString *_Nonnull)aGroupId
                     completion:(void(^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Unmutes all members.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)unmuteAllMembersFromGroup:(NSString *_Nonnull)aGroupId
                       completion:(void(^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds members to the allowlist.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  @param aMembers         The members to be added to the allowlist.
 *  @param aGroupId         The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addWhiteListMembers:(NSArray<NSString *> * _Nonnull)aMembers
                  fromGroup:(NSString *_Nonnull)aGroupId
                 completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes members from the allowlist.
 * 
 *  This is an asynchronous method.
 * 
 *  Only the chatroom owner or admin can call this method.
 *
 *  @param aMembers        The members to be removed from the allowlist.
 *  @param aGroupId        The group ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeWhiteListMembers:(NSArray<NSString *> * _Nonnull)aMembers
                     fromGroup:(NSString *_Nonnull)aGroupId
                    completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Uploads the share file of group.
 *
 *  @param aGroupId        The group ID.
 *  @param aFilePath       The path of file.
 *  @param pError      The error information if the method fails: Error.
 *
 *  @result    The group instance.
 */
- (void)uploadGroupSharedFileWithId:(NSString *_Nonnull)aGroupId
                           filePath:(NSString* _Nonnull)aFilePath
                           progress:(void (^_Nullable)(int progress))aProgressBlock
                         completion:(void (^_Nullable)(AgoraChatGroupSharedFile *_Nullable aSharedFile, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Downloads the share file of group.
 *
 *  @param aGroupId         The group ID.
 *  @param aFilePath        The path of file.
 *  @param aSharedFileId    The shared file ID.
 *  @param aProgressBlock   The block of attachment upload progress
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)downloadGroupSharedFileWithId:(NSString *_Nonnull)aGroupId
                             filePath:(NSString *_Nonnull)aFilePath
                         sharedFileId:(NSString *_Nonnull)aSharedFileId
                             progress:(void (^_Nullable)(int progress))aProgressBlock
                           completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes the share file of group.
 *
 *  @param aGroupId         The group ID.
 *  @param aSharedFileId    The share file ID.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)removeGroupSharedFileWithId:(NSString *_Nonnull)aGroupId
                       sharedFileId:(NSString *_Nonnull)aSharedFileId
                         completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Updates the announcement of group.
 * 
 *  Only the chatroom owner or admin can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aAnnouncement    The announcement of the group.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateGroupAnnouncementWithId:(NSString *_Nonnull)aGroupId
                         announcement:(NSString *_Nullable)aAnnouncement
                           completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Updates the extended information of the group.
 * 
 *  Only the group owner can call this method.
 *
 *  @param aGroupId         The group ID.
 *  @param aExt             The extended information of the group.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updateGroupExtWithId:(NSString *_Nonnull)aGroupId
                         ext:(NSString *_Nullable)aExt
                  completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;




#pragma mark - Application

/**
 *  \
 *  Approves a group request.
 * 
 *  Only the group owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aUsername        The user who sends the request for join the group.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)approveJoinGroupRequest:(NSString *_Nonnull)aGroupId
                         sender:(NSString *_Nonnull)aUsername
                     completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Declines a group request.
 * 
 *  Only the group owner can call this method.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aUsername        The user who sends the request for join the group.
 *  @param aReason          The reason for declining.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)declineJoinGroupRequest:(NSString *_Nonnull)aGroupId
                         sender:(NSString *_Nonnull)aUsername
                         reason:(NSString *_Nullable)aReason
                     completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Accepts a group invitation.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aUsername        The user who initiates the invitation. 
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)acceptInvitationFromGroup:(NSString *_Nonnull)aGroupId
                          inviter:(NSString *_Nonnull)aUsername
                       completion:(void (^_Nullable)(AgoraChatGroup *_Nullable aGroup, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Declines a group invitation.
 * 
 *  This is an asynchronous method.
 *
 *  @param aGroupId         The group ID.
 *  @param aInviter         The user who send the invitation.
 *  @param aReason          The reason of declining.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)declineGroupInvitation:(NSString *_Nonnull)aGroupId
                       inviter:(NSString *_Nonnull)aInviter
                        reason:(NSString *_Nullable)aReason
                    completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;


#pragma mark - Group member attributes
/**
*  \
*  Sets custom attributes of a group member.
*
*  @param groupId      The group ID.
*  @param userId       The user ID of the group member for whom the custom attributes are set.
*  @param attributes   The map of custom attributes in key-value format. In a key-value pair, if the value is set to an empty string, the custom attribute will be deleted.
*  @param completion The completion block, which contains the error message if the method call fails.
*/
- (void)setMemberAttribute:(NSString *_Nonnull)groupId userId:(NSString *_Nonnull)userId attributes:(NSDictionary<NSString*,NSString*> *_Nonnull)attributes completion:(void (^_Nullable)(AgoraChatError *_Nullable error))completionBlock;

/**
*  \
*  Gets all custom attributes of a group member.
*
*  @param groupId      The group ID.
*  @param userId       The user ID of the group member whose all custom attributes are retrieved.
*  @param completion   The completion block, which contains the map of all retrieved attributes and the error message (AgoraChatError) if the method call fails:
* - If the method call succeeds, the SDK returns the map of retrieved custom attributes in key-value pairs. In this case, AgoraChatError is empty.
* - If the method call fails, the SDK returns the reason for the failure (AgoraChatError). In this case, the map of custom attributes is empty.
* - If both the map of custom attributes and AgoraChatError are empty, no custom attribute is set for the group member.
*/
- (void)fetchMemberAttribute:(NSString *_Nonnull)groupId userId:(NSString *_Nonnull)userId completion:(void (^ _Nullable)(NSDictionary<NSString *,NSString *> * _Nullable, AgoraChatError * _Nullable))completionBlock;
/**
*  \
*  Gets custom attributes of multiple group members by attribute key.
*
*  @param groupId        The group ID.
*  @param userIds        The array of user IDs of group members whose custom attributes are retrieved.(limitation is ten.More than callback error. )
*  @param keys           The array of keys of custom attributes to be retrieved.
*  @param completion     The completion block, which contains the map of retrieved attributes and the error message (AgoraChatError) if the method call fails.
* - If the method call succeeds, the SDK returns the map of retrieved custom attributes in key-value pairs. In this case, AgoraChatError is empty. If no custom attribute is set for a group members, the map of custom attribute is empty for this member.
* - If the method call fails, the SDK returns the reason for the failure (AgoraChatError). In this case, the map of custom attributes is empty for the group members.
* - If both the map of custom attributes and AgoraChatError are empty, no custom attribute is set for the group members.
*/
- (void)fetchMembersAttributes:(NSString *_Nonnull)groupId userIds:(NSArray<__kindof NSString *> *_Nonnull)userIds keys:(NSArray<__kindof NSString *> *_Nonnull)keys completion:(void (^_Nullable)(NSDictionary<NSString*,NSDictionary<NSString*,NSString*>*> *_Nullable attributes, AgoraChatError *_Nullable error))completionBlock;

/**
*  \
*  Updates own group namecard.
*  @param groupId        The group ID.
*  @param namecard      The namecard to be set. Pass nil to delete the
*  @param completion     The completion block, which contains the error message if the method call fails.
*/
- (void)updateGroupNamecard:(NSString* _Nonnull)groupId
                   namecard:(NSString*_Nullable)namecard
                 completion:(void (^_Nullable)(AgoraChatError *_Nullable error))completionBlock;

/**
 * \
 *  Get local group namecard
 *  @param groupId        The group ID.
 *  @param userId          The userId to get.
 *  @return Return the group nickname in cache, return nil if not found.
 */
- (NSString* _Nullable)getGroupNamecardWithGroupId:(NSString* _Nonnull)groupId
                                                     userId:(NSString*_Nonnull)userId;
@end
