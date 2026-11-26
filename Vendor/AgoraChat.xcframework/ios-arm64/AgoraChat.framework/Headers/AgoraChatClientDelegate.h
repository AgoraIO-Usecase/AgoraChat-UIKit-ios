/**
 *  \
 *  @header AgoraChatClientDelegate.h
 *  @abstract The protocol provides callbacks related to account login status
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatErrorCode.h"
#import "AgoraChatOptions.h"
#import "AgoraChatLoginExtensionInfo.h"

/**
 *  \ 
 *  The connection state.
 */
typedef NS_ENUM(NSInteger, AgoraChatConnectionState) {
    AgoraChatConnectionConnected = 0,  /**
                                 * \ The SDK is connected to the chat server.
                                 */
    AgoraChatConnectionDisconnected,   /**
                                 * \ The SDK is disconnected from the chat server.
                                 */
    AgoraChatConnectionConnecting = 2, /**
                                 * \ The SDK is connecting to the chat server.
                                 */
};

@class AgoraChatError;

/**
 *  \ 
 *  @abstract This protocol provides a number of utility classes callback
 */
@protocol AgoraChatClientDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when the connection state between the SDK and the server changes.
 * 
 *  The SDK triggers this callback in any of the following situations:
 *   - After login, the device is disconnected from the internet.
 *   - After login, the network status changes.
 *
 *  @param aConnectionState  The current connection state.
 */
- (void)connectionStateDidChange:(AgoraChatConnectionState)aConnectionState;



/**
 *  \
 *  Occurs when the current user account is logged in to another device.

 *  @param info The device name and extended information of the login device ``AgoraChatLoginInfo``.
 */
- (void)userAccountDidLoginFromOtherDeviceWithInfo:(AgoraChatLoginExtensionInfo* _Nullable)info;

/**
 *  \
 *  Occurs when the current chat user is removed from the server.
 */
- (void)userAccountDidRemoveFromServer;

/**
 *  \
 *  The delegate method will be invoked when the User account is forbidden.
 */
- (void)userDidForbidByServer;

/**
 *  \
 *  The delegate method will be invoked when current IM account is forced to logout with the following reasons:
 *    1. The password is modified;
 *    2. Logged in too many devices;
 *    3. User for forbidden;
 *    4. Forced offline.
 */
- (void)userAccountDidForcedToLogout:(AgoraChatError *_Nullable)aError;

/**
 *  \
 * The token is about to expire.
 *
 * This event occurs from when 20% of the validity period is left.
 */
- (void)tokenWillExpire:(AgoraChatErrorCode)aErrorCode;

/**
 *  \
 *  token did expire
 */
- (void)tokenDidExpire:(AgoraChatErrorCode)aErrorCode;

/**
 *  \
 *  Occurs when the SDK starts pulling offline messages from the server.
 */
- (void)onOfflineMessageSyncStart;

/**
 *  \
 *  Occurs when the SDK finishes pulling offline messages from the server.
 */
- (void)onOfflineMessageSyncFinish;

/**
 *  \
 *  Occurs when a post-login data synchronization starts.
 *
 *  @param type The data type that starts synchronizing.
 */
- (void)syncDataStartWithType:(EMDataSyncType)type;

/**
 *  \
 *  Occurs when a post-login data synchronization finishes. The SDK triggers this callback
 *  when the synchronization ends because of success, failure, timeout, or disconnection.
 *
 *  @param error The error information. It is nil when the synchronization succeeds.
 *  @param type The data type that finished synchronizing.
 */
- (void)syncDataFinished:(AgoraChatError * _Nullable)error type:(EMDataSyncType)type;

/**
 *  \
 *  Occurs when a post-login database opened finishes. The SDK triggers this callback
 *
 *  @param error The error information. It is nil when the synchronization succeeds.
 *  @param username The username of the logged-in user.
 */
- (void)onDatabaseOpened:(AgoraChatError * _Nullable)error username:(NSString *_Nonnull)username;

@end
