/**
 *  \
 *  @header AgoraChatPushOptions.h
 *  @abstract The setting options of Apple Push Notification.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatCommonDefs.h"

#define kPushNickname @"nickname"
#define kPushDisplayStyle @"notification_display_style"
#define kPushNoDisturbing @"notification_no_disturbing"
#define kPushNoDisturbingStartH @"notification_no_disturbing_start"
#define kPushNoDisturbingStartM @"notification_no_disturbing_startM"
#define kPushNoDisturbingEndH @"notification_no_disturbing_end"
#define kPushNoDisturbingEndM @"notification_no_disturbing_endM"

/**
 *  \ 
 *  The display style of push message.
 */
typedef NS_ENUM(NSInteger, AgoraChatPushDisplayStyle) {
    AgoraChatPushDisplayStyleSimpleBanner = 0, /**
                                         *  \
                                         *  A simple banner that displays "You have a new message".
                                         */
    AgoraChatPushDisplayStyleMessageSummary,   /**
                                         *  \ 
                                         *  Displays the message's content.
                                         */
};

/**
 *  \ 
 *  The options for Apple Push Notification service (APNs).
 */
@interface AgoraChatPushOptions : NSObject

/**
 *  \ 
 *  The user's nickname to be displayed in the notification.
 */
@property (nonatomic, strong, readonly) NSString * _Nullable displayName;

/**
 *  \ 
 *  The display style of the notification.
 */
@property (nonatomic, readonly) AgoraChatPushDisplayStyle displayStyle;

@end
