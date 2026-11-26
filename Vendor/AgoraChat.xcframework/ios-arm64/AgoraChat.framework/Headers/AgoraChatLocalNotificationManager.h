//
//  AgoraChatLocalNotificationManager.h
//  LocalNotification
//
//  Created by lixiaoming on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AgoraChatNotificationState) {
     AgoraChatWillPresentNotification = 0,
     AgoraChatDidReceiveNotificationResponse
 };

/**
 *  \
 *  The callbacks of chat message notification.
 */
@protocol AgoraChatLocalNotificationDelegate <NSObject>
@optional
/**
 *  \
 *
 *  This method will be called  when  application receives  notification in the foreground.
 *  By completionHandle (UNNotificationPresentationOptions options) callback display style, must be the callback.
 *
 */
- (void)emuserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;
/**
 *  \
 *
 *  This method will be called when user open application notification.
 *  CompletionHandler must be called back
 *
 */
- (void)emuserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler;
/**
 *  \
 *
 *  The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings
 *
 */
- (void)emuserNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification;

/**
 *  \
 *
 *  Getting push messages can be implemented only with this delegate method to uniformly get notification messages
 *
 */
- (void)emGetNotificationMessage:(UNNotification*)notification state:(AgoraChatNotificationState)state;

/**
 *  \
 *
 *  Triggered before the notification pops up. You can modify the UNMutableNotificationContent property in the callback.
 *
 */
- (void)emHandleNotificationContent:(UNMutableNotificationContent*)content;

/**
 *  \
 *
 *  This method is called when the application  received easemob push silent message
 *
 */
- (void)emDidRecivePushSilentMessage:(NSDictionary *)messageDic;

@end

/**
 *  \
 *  A class that manages the chat message notification.
 */
@interface AgoraChatLocalNotificationManager : NSObject
/**
 *  \
 *  Allocs. 
 */ 
 
+(instancetype _Nonnull ) alloc __attribute__((unavailable("call sharedManager instead")));
/**
 *  \
 *  Create an instance. 
 */ 
 
+(instancetype _Nonnull ) new __attribute__((unavailable("call sharedManager instead")));
/**
 *  \
 *  Copy an instance. 
 */ 
 
-(instancetype _Nonnull ) copy __attribute__((unavailable("call sharedManager instead")));
/**
 *  \
 *  Copy and generate a new instance. 
 */ 
 
-(instancetype _Nonnull ) mutableCopy __attribute__((unavailable("call sharedManager instead")));
/**
 *  \
 *  Create an instance. 
 */
 
+  (instancetype _Nonnull )sharedManager;

/**
 *  \
 *
 *  Enables the chat message notification service.
 * 
 *  Once you enable this service, the new message is reported in the notification bar so that users can read them in time.
 *
 */
- (void)launchWithDelegate:(id<AgoraChatLocalNotificationDelegate>)aDelegate;

/**
 *  \
 *
 *  User should call this method in the implementation of  UNUserNotificationCenterDelegate if they have override UNUserNotificationCenterDelegate  in-app.
 *  If you don't want the SDK to execute the callback, don't pass the completionHandler
 *
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;
/**
 *  \
 *  When the system receives a push notification, the callback method is triggered when the notification bar is clicked.
 *  User should call this method in the implementation of UNUserNotificationCenterDelegate if they have override UNUserNotificationCenterDelegate in-app.
 *
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler;
@end

NS_ASSUME_NONNULL_END
