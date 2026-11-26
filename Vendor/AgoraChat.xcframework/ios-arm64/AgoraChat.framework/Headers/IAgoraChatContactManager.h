/**
 *  \
 *  @header IAgoraChatContactManager.h
 *  @abstract The protocol defines the operations of contact.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatCommonDefs.h"
#import "AgoraChatContactManagerDelegate.h"
#import "AgoraChatContact.h"
#import "AgoraChatCursorResult.h"

@class AgoraChatError;

/**
 *  \
 *  The contact management.
 */
@protocol IAgoraChatContactManager <NSObject>

@required

#pragma mark - Delegate

/**
 *  \
 *  Adds delegate.
 *
 *  @param aDelegate  The delegate to be added.
 *  @param aQueue     (optional) The queue of calling delegate methods. You need to set this parameter as nil to run on main thread.
 */
- (void)addDelegate:(id<AgoraChatContactManagerDelegate> _Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t)aQueue;

/**
 *  \
 *  Removes delegate.
 *
 *  @param aDelegate  The delegate to be removed.
 */
- (void)removeDelegate:(id _Nonnull)aDelegate;


#pragma mark - Contact Operations

/**
 *  \
 *  Gets all contacts from the local database.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @result The contact NSArray.
 */
- (NSArray<NSString *> *_Nullable )getContacts;

/**
 *  \
 *  Gets all contacts from the local database.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @result The contact NSArray.
 */
- (NSArray<AgoraChatContact*>* _Nullable)getAllContacts;

/**
 *  \
 *  Set remark for  contact.
 *
 *  This is an asynchronous method.
 *
 *  @param userId  The contact userId.
 *  @param remark  The remark information.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)setContactRemark:(NSString* _Nonnull)userId remark:(NSString*_Nullable)remark completion:(void (^_Nullable)(AgoraChatContact* _Nullable contact, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets  contact by userId.
 *
 *  This is a synchronous method.
 *
 *  @param userId  The contact userId.
 *  @return The contact info of userId.
 *
 */
- (AgoraChatContact* _Nullable)getContact:(NSString* _Nonnull)userId;

/**
 *  \
 *  Adds a contact.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername        The user to be added as a contact.
 *  @param aMessage         The invitation message.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addContact:(NSString *_Nonnull)aUsername
           message:(NSString *_Nullable )aMessage
        completion:(void (^_Nullable )(NSString *_Nullable aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Deletes a contact.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aUsername                The contact to be deleted.
 *  @param aIsDeleteConversation    Whether to keep the associated conversation and messages. Yes means delete the contact and synchronisely delete the conversations between the contact and the user. No means don't delete the conversations when deleting the contact.
 *
 *  @result The error information if the method fails: Error.
 */
- (AgoraChatError *_Nullable )deleteContact:(NSString *_Nonnull)aUsername
                isDeleteConversation:(BOOL)aIsDeleteConversation;

/**
 *  \
 *  Deletes a contact.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername                The contact to be deleted.
 *  @param aIsDeleteConversation    Whether to delete the related conversation. Yes means delete the contact and synchronisely delete the conversations between the contact and the user. No means don't delete the conversations when deleting the contact.
 *  @param aCompletionBlock         The completion block, which contains the error message if the method fails.
 *
 */
- (void)deleteContact:(NSString *_Nonnull)aUsername
 isDeleteConversation:(BOOL)aIsDeleteConversation
           completion:(void (^_Nullable )(NSString *_Nullable aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Approves a friend request.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername        The user who initiated the friend request.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)approveFriendRequestFromUser:(NSString *_Nonnull)aUsername
                          completion:(void (^_Nullable )(NSString *_Nullable aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Declines a friend request.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername        The user who initiated the friend request.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)declineFriendRequestFromUser:(NSString *_Nonnull)aUsername
                          completion:(void (^_Nullable )(NSString *aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;


#pragma mark - Blacklist Operations


/**
 *  \
 *  Gets the blocklist from the server.
 *
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getBlackListFromServerWithCompletion:(void (^_Nullable )(NSArray<NSString *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the blocklist from the local.
 *  @return The blacklist.
 */
- (NSArray<NSString *> *_Nullable)getBlackList;
/**
 *  \
 *  Adds a user to the blocklist.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername        The user to be added into the blocklist.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)addUserToBlackList:(NSString *_Nonnull)aUsername
                completion:(void (^_Nullable)(NSString *_Nullable aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Adds multiple users to the blocklist.
 *
 *  This is an asynchronous method.
 *
 *  @param aBlackList       The users to be added into the blocklist.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)saveBlackList:(NSArray<NSString *> *_Nonnull)aBlackList
           completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Removes the user from the blocklist.
 *
 *  This is an asynchronous method.
 *
 *  @param aUsername        The user to be removed from the blocklist.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)removeUserFromBlackList:(NSString *_Nonnull)aUsername
                     completion:(void (^_Nullable )(NSString *_Nullable aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Other platform

/**
 *  \
 *  Gets the ID list of the current account on another platform (Windows or Web)
 *  The ID usage is similar to friend username.
 *
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getSelfIdsOnOtherPlatformWithCompletion:(void (^_Nullable)(NSArray<NSString *> *_Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;

@end
