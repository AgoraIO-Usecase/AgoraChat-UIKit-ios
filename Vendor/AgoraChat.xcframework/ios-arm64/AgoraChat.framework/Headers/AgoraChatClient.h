/**
 *  @header AgoraChatClient.h
 *  @abstract SDK Client
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatClientDelegate.h"
#import "AgoraChatError.h"
#import "AgoraChatMultiDevicesDelegate.h"
#import "AgoraChatOptions.h"
#import "AgoraChatPushOptions.h"

#import "IAgoraChatManager.h"
#import "IAgoraChatroomManager.h"
#import "IAgoraChatContactManager.h"
#import "IAgoraChatGroupManager.h"
#import "IAgoraChatThreadManager.h"
#import "IAgoraChatPushManager.h"
#import "IAgoraChatUserInfoManager.h"
#import "IAgoraChatPresenceManager.h"

#import "AgoraChatDeviceConfig.h"
#import "AgoraChatLocalNotificationManager.h"
#import "AgoraChatLogDelegate.h"

/**
 * \
 *  This class is the entry of the Chat SDK, which is responsible for management of modules like login, logout, and connection. 
 * 
 * With this class, you can access other modules such as group [AgoraChatClient sharedClient].groupManager.
 *
 */
@interface AgoraChatClient : NSObject
{
  AgoraChatPushOptions *_pushOptions;
}

/**
 *  \
 *  The SDK version number.
 */
@property(nonatomic, strong, readonly) NSString * _Nonnull version;

/**
 *  \
 *  The ID of the user currently logged in to your chat app.
 */
@property(atomic, strong, readonly) NSString * _Nullable currentUsername;

/**
 *  \
 *  The SDK setting options. For example, whether to use HTTPs by default.
 */
@property(nonatomic, strong, readonly) AgoraChatOptions * _Nonnull options;

/**
 *  \
 *  The chat manager module.
 */
@property(nonatomic, strong, readonly) id<IAgoraChatManager> _Nullable chatManager;

/**
 *  \
 *  The contact manager module.
 */
@property(nonatomic, strong, readonly) id<IAgoraChatContactManager> _Nullable contactManager;

/**
 *  \
 *  The group manager module.
 */
@property(nonatomic, strong, readonly) id<IAgoraChatGroupManager> _Nullable groupManager;

/**
 *  \
 *  The thread manager module.
 */
@property (nonatomic, strong, readonly) id<IAgoraChatThreadManager> _Nullable threadManager;

/*!
 *  \
 *  The chat room manager module.
 */
@property(nonatomic, strong, readonly) id<IAgoraChatroomManager> _Nullable roomManager;

/**
 *  \
 *   The push manager module.
 */
@property (nonatomic, strong, readonly) id<IAgoraChatPushManager> _Nullable pushManager;

/**
 *  \
 * 
 * Whether the current user is already logged in to the chat server.
 *  
 * - `YES`：The current user is already logged in.
 * - `NO`：The current user is not logged in.
 */
@property(nonatomic, readonly) BOOL isLoggedIn;

/**
 *  \
 *  Whether the SDK is connected to the chat server.
 * 
 * - `YES`：Yes.
 * - `NO`：No.
 */
@property(nonatomic, readonly) BOOL isConnected __deprecated_msg("Use -connectionState instead");

/**
 *  \
 *  The connection state of the SDK to the chat server.
 */
@property (nonatomic, readonly) AgoraChatConnectionState connectionState;

/**
 *  \
 *  The token used by the current user to access the chat server.
 * 
 * The user needs to use the user ID and password for the first login. If the login succeeds, a token is returned and the user can use it for subsequent logins.
 */
@property(nonatomic, readonly) NSString * _Nullable accessUserToken;

/**
 *  \
 *  The user attribute manager module.
 */
@property(nonatomic, strong, readonly) id<IAgoraChatUserInfoManager> _Nullable userInfoManager;

/**
 *  \
 *  The presence manager module.
 */
@property (nonatomic, strong, readonly) id<IAgoraChatPresenceManager> _Nullable presenceManager;

-(instancetype _Nonnull ) init __attribute__((unavailable("call sharedClient instead")));
-(instancetype _Nonnull ) copy __attribute__((unavailable("call sharedClient instead")));
-(instancetype _Nonnull ) mutableCopy __attribute__((unavailable("call sharedClient instead")));
/**
 *  \
 *  Creates a Client instance. The Client class is the entry to the Chat SDK. You need to call this method to create a Client instance before calling any other methods.
 */
+ (instancetype _Nonnull )sharedClient;


/**
 *  \
 *  The SDK version number.
 */
- (NSString *)version;

#pragma mark - Delegate  

/**
 *  \
 *  Adds a delegate. 
 *
 *  @param aDelegate  The delegate that you want to add.
 *  @param aQueue     (optional) The queue of calling delegate methods. If you want to run the app on the main thread, set this parameter as `nil`. */
- (void)addDelegate:(id<AgoraChatClientDelegate>_Nonnull)aDelegate
      delegateQueue:(dispatch_queue_t _Nullable )aQueue;

/**
 *  \
 *  Removes a delegate.
 *
 *  @param aDelegate  The delegate that you want to remove.
 */
- (void)removeDelegate:(id _Nonnull )aDelegate;

/**
 *  \
 *  Adds the multi-device delegate.
 *
 *  @param aDelegate  The delegate that you want to add. 
 *  @param aQueue     The queue of calling delegate methods.
 */
- (void)addMultiDevicesDelegate:(id<AgoraChatMultiDevicesDelegate>_Nonnull)aDelegate
                  delegateQueue:(dispatch_queue_t _Nullable )aQueue NS_SWIFT_NAME(addMultiDevices(delegate:queue:));

/**
 *  \
 *  Removes the multi-device delegate.
 *
 *  @param aDelegate  The multi-device delegate that you want to delete.
 */
- (void)removeMultiDevicesDelegate:(id<AgoraChatMultiDevicesDelegate>_Nonnull)aDelegate;

#pragma mark - Initialize SDK

/**
 *  \
 *  Initializes the SDK.
 *
 *  @param aOptions   The SDK options.
 *
 *  @Result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)initializeSDKWithOptions:(AgoraChatOptions * _Nonnull )aOptions;

#pragma mark - Change AppKey

/**
 *  \
 *  Updates the the App Key, the unique identifier used to access the chat server.
 *
 * You can only update the App Key when you are logged out. 
 *
 *  @param aAppkey  The new App Key. 
 *
 *  @Result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)changeAppkey:(NSString * _Nonnull)aAppkey;

/**
 *  \
 *  Updates the the AppId, the unique identifier used to access the chat server.
 *
 * You can only update the AppId when you are logged out.
 *
 *  @param aAppId  The new AppId.
 *
 *  @Result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)changeAppId:(NSString * _Nonnull)aAppId;

#pragma mark - Login

/**
 *  \
 * Logs in to the chat server with a token.  
 * 
 * This is an asynchronous method. This method supports automatic login.
 *
 *  @param aUsername        The user ID. The maximum length is 64 characters. Ensure that you set this parameter. Supported characters include the 26 English letters (a-z), the ten numbers (0-9), the underscore (_), the hyphen (-), and the English period (.). This parameter is case insensitive, and upper-case letters are automatically changed to low-case ones. If you want to set this parameter as a regular expression, set it as ^[a-zA-Z0-9_-]+$.
 *  @param aToken           The token for login to the chat server.
 *  @param aCompletionBlock The completion block, which contains the user ID and the error message if the method fails.
 *
 */
- (void)loginWithUsername:(NSString *_Nonnull)aUsername
                    token:(NSString *_Nonnull)aToken
               completion:(void (^_Nullable)(NSString * _Nonnull aUsername, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Renews the user token when the current token expires.
 *
 *  If you are logged in with an Chat user token and you are notified via the ClientDelegate callback that the token is about to expire, you can call this method to renew the token to prevent unknown issues caused by an invalid token.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param newToken The new Chat token。
 *
 *  @result The result which contains the description of the cause to the failure if call fails.
 */
- (AgoraChatError *_Nullable)renewToken:(NSString *_Nonnull)newToken;

/**
 *  \
 *  Renews the user token when the current token expires.
 *
 *  If you are logged in with an Chat user token and you are notified via the ClientDelegate callback that the token is about to expire, you can call this method to renew the token to prevent unknown issues caused by an invalid token.
 *
 *  This is an asynchronous method.
 *
 *  @param newToken The new Chat token。
 *
 *  @result The result which contains the description of the cause to the failure if call fails.
 */
- (void)renewToken:(NSString *_Nonnull)newToken completion:(void (^_Nullable)(AgoraChatError* _Nullable aError))aCompletionBlock;

#pragma mark - Logout

/**
 *  \
 *  Logs out of the chat server.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aIsUnbindDeviceToken Whether to unbind the user ID from the device.
 *  - `Yes`：Yes. Once the user ID is unbound from the device, the user device stops receiving push notifications from the Apple Push Notifications service.
 *    If the unbinding fails, the SDK returns an error that includes the reason for the failure.
 *  - `NO`：No.
 *
 *  @result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)logout:(BOOL)aIsUnbindDeviceToken;

/**
 *  \
 *  Logs out of the chat server.
 *
 *  This is an asynchronous method.
 *
 *  @param aIsUnbindDeviceToken   Whether to unbind the user ID from the device.
 *  - `Yes`：Yes. Once the user ID is unbound from the device, the user device stops receiving push notifications from the Apple Push Notifications service.
 *    If the unbinding fails, the SDK returns an error that includes the reason for the failure.
 *  - `NO`：No.
 *  @param aCompletionBlock  The completion block, which contains the token and the error message if the method fails.
 *
 */
- (void)logout:(BOOL)aIsUnbindDeviceToken
    completion:(void (^_Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

#pragma mark - PushKit

/**
 *  \
 *  Uses the PushKit token to bind the user and the device, which is required to enable Apple PushKit Service. 
 * 
 *  The Apple PushKit service is used to implement VoIP push notifications.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aPushToken      The PushKit token to bind.
 *
 *  @result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)bindPushKitToken:(NSData *_Nullable)aPushToken;

/**
 *  \
 *  Registers a PushKit token.
 * 
 *  The Apple PushKit service is used to implement VoIP push notifications.
 *
 *  This is an asynchronous method.
 *
 *  @param aPushToken           The PushKit token to register.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)registerPushKitToken:(NSData *_Nullable)aPushToken
                  completion:(void (^_Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Unbinds the Apple PushKit token from the device.
 * 
 *  This method plays the same role as the `unRegisterPushKitTokenWithCompletion` method.
 * 
 *  The Apple PushKit service is used to implement VoIP push notifications.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @result A description of the issue that caused this call to fail.
 */
- (AgoraChatError *_Nullable)unBindPushKitToken;

/**
 *  \
 *  Unregisters the Apple PushKit token.
 * 
 *  This method plays the same role as the `unBindPushKitToken` method.
 * 
 *  This is an asynchronous method.
 * 
 *  The Apple PushKit service is used to implement VoIP push notifications.
 *
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)unRegisterPushKitTokenWithCompletion:(void (^_Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

#pragma mark - APNs

/**
 *  \
 *  Binds the device token.
 * 
 *  Device token binding is required to enable Apple Push Notification Service.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aDeviceToken  The device token to bind.
 *
 *  @Result If the binding succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (AgoraChatError *_Nullable)bindDeviceToken:(NSData *_Nonnull)aDeviceToken;

/**
 *  \
 *  Registers the device token.
 * 
 *  Device token binding is required to enable Apple push notification service.
 * 
 *  This is an asynchronous method.
 *
 *  @param aDeviceToken         The device token to bind.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)aDeviceToken
                                           completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the Agora RTC token, token expiration time, and RTC UID matching the Agora Chat user ID according to the channel name (channelName).
 *
 * You must enable the Agora RTC feature before calling this API.
 *
 *  If the channel name is set to nil, an RTC token valid for all channels will be generated.
 *
 *  This is an asynchronous method.
 *
 *  @param aChannelName      The Agora RTC channel name.
 *  @param aCompletionBlock  The completion block, which contains the token, expiration time, and RTC UID. The error message is included if the method fails.
 */
- (void)getRTCTokenWithChannel:(NSString* _Nullable)aChannelName
                    completion:(void (^_Nonnull)(NSUInteger rtcUId,NSString * _Nullable aToken,NSInteger expiredTs, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the Agora Chat user IDs matching the Agora RTC UIDs.
 *
 * This is an asynchronous method.
 *
 *  @param uIds      The Agora RTC UID array.
 *  @param aCompletionBlock  The completion block, which contains the mapping between Agora Chat user IDs and Agora RTC UIDs. The error message is included if the method fails.
 */
- (void)getUserIdByRTCUIds:(NSArray<NSNumber*>* _Nonnull)uIds completion:(void (^_Nullable)(NSDictionary<NSNumber*,NSString*> * _Nullable accountInfos, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Registers the device token.
 *
 *  Device token binding is required to enable Apple push notification service.
 *
 *  This is an asynchronous method.
 *
 *  @param aCertName               The certification name to bind.
 *  @param aDeviceToken         The device token to bind.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)registerForRemoteNotificationsWithCertName:(NSString *_Nonnull)aCertName
                                       deviceToken:(NSData *_Nonnull)aDeviceToken
                                        completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Binds the FCM token, call this API when integrated FCM Notification
 *
 *  This is an asynchronous method.
 *
 *  @param aFCMToken  The device token generated by FCM SDK.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 *
 *  @Result If the binding succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail.
 */
- (void)bindFCMToken:(NSString* _Nonnull)aFCMToken
          completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

#pragma mark - Log

/**
 *  \
 *  Uploads the log to the chat server.
 * 
 *  The information in the debug log is used by our engineers to fix errors and improve system performance.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @result If the upload succeeds, the SDK returns `nil`; otherwise, the SDK returns the description of the issue that causes the call to fail. 
 */
- (AgoraChatError *_Nullable)uploadLogToServer;

/**
 *  \
 *  Uploads the debug log to the chat server.
 *
 *  @param aCompletionBlock     The completion block, which contains the token and the error message if the method fails.
 */
- (void)uploadDebugLogToServerWithCompletion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Compresses the debug logs into a gzip archive (.gz).
 * 
 *  You are strongly advised to delete this debug archive once it is no longer used.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param pError  A description of the issue that caused this call to fail.
 *
 *  @result NSString The full file path of the debug archive.
 */
- (NSString *_Nullable)getLogFilesPath:(AgoraChatError **_Nullable)pError;

/**
 *  \
 *  Compresses the debug logs into a gzip archive (.gz).
 * 
 *  You are strongly advised to delete this debug archive once it is no longer used.
 *
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock     The completion block, which contains the token and the error message if the method fails.
 */
- (void)getLogFilesPathWithCompletion:(void (^_Nullable)(NSString *_Nullable aPath, AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Outputs logs to a log file. 
 * 
 *  You can call this method after the SDK is initialized.
 *
 *  This is a synchronous method and blocks the current thread.
 *
 *  @param aLog The log information to output.
 */
- (void)log:(NSString *_Nonnull)aLog;

/**
 *  \
 *  Adds the log callback delegate.
 *
 *  @param aDelegate  The delegate that you want to add.
 *  @param aQueue     The queue of calling delegate methods.
 */
- (void)addLogDelegate:(id<AgoraChatLogDelegate>_Nonnull)aDelegate
         delegateQueue:(dispatch_queue_t _Nullable )aQueue NS_SWIFT_NAME(addLog(delegate:queue:));

/**
 *  \
 *  Removes the log callback delegate.
 *
 *  @param aDelegate  The log callback delegate that you want to delete.
 */
- (void)removeLogDelegate:(id<AgoraChatLogDelegate>_Nonnull)aDelegate NS_SWIFT_NAME(removeLog(delegate:));

#pragma mark - Multi Devices



/**
 *  \
 *  Gets information of all login devices <AgoraChatDeviceConfig> from the server. 
 *
 *  This is an asynchronous method.
 *
 *  @param aUserID     The user ID.
 *  @param aToken        The token.
 *  @param aCompletionBlock     The completion block, which contains the list and the error message if the method fails.
 *
 */
- (void)getLoggedInDevicesFromServerWithUserId:(NSString *_Nonnull)aUserID
                                         token:(NSString *_Nonnull)aToken
                                    completion:(void (^_Nullable)(NSArray<AgoraChatDeviceConfig*> * _Nullable aList, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Kicks a user out of the app on a specific device.
 *
 *  You can call `getLoggedInDevicesFromServerWithUserId` to retrieve the list of devices that a user is currently logged in to.
 *
 *  This is an asynchronous method.
 *
 *  @param aUserID     The user ID of the user to be kicked out of the app.
 *  @param aToken        The token.
 *  @param aResource     The device to log `aUsername` out from. Call `getLoggedInDevicesFromServerWithUserId` to retrieve the list of devices `aUsername` is currently logged into.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)kickDeviceWithUserId:(NSString *_Nonnull)aUserID
                       token:(NSString *_Nonnull)aToken
                    resource:(NSString *_Nonnull)aResource
                  completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Kicks a user out of the app on all devices.
 *
 *  This is an asynchronous method.
 *
 *  @param aUserID     The user ID.
 *  @param aToken            The token.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)kickAllDevicesWithUserId:(NSString *_Nonnull)aUserID
                           token:(NSString *_Nonnull)aToken
                      completion:(void (^_Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets information of the current login device.
 *
 *  @result Information of the current login device.
 */
- (AgoraChatDeviceConfig * _Nullable)getDeviceConfig:(AgoraChatError **)pError;

#pragma mark - iOS


/**
 *  \
 *  Disconnects from the chat server when the app is switched to the background.
 * 
 *  This method is specific to the iOS platform.
 *
 *  @param aApplication  The current application instance.
 */
- (void)applicationDidEnterBackground:(id _Nonnull )aApplication;

/**
 *  \
 *  Reconnects to the server when your app returns to the foreground.
 * 
 *  This method is specific to the iOS platform.
 *
 *  @param aApplication  The current application instance.
 */
- (void)applicationWillEnterForeground:(id _Nonnull )aApplication;

/**
 *  \
 *  Occurs when the device receives an APNs notification when your app is running in the foreground.
 * 
 *  This event is specific to the iOS platform.
 *
 *  @param application  The current application instance.
 *  @param userInfo     The push content.
 */
- (void)application:(id _Nonnull)application didReceiveRemoteNotification:(NSDictionary * _Nullable)userInfo;


@end
