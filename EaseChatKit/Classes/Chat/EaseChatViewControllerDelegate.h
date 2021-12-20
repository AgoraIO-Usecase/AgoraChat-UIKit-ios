//
//  EaseChatViewControllerDelegate.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "EaseUserProfile.h"
#import "EaseMessageModel.h"
#import "EaseExtendMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

//Chat controller callback
@protocol EaseChatViewControllerDelegate <NSObject>

@optional

/* cell callback */

/**
 * Return user profile
 *
 * @discussion Users according to huanxinID in their own user system to match the corresponding user information, and return the corresponding information, otherwise the default implementation
 *
 * @param   huanxinID        huanxin ID
 *
 */
- (id<EaseUserProfile>)userProfile:(NSString *)userID;

/**
 * Avatar selected event
 *
 * @param   userData        The profile of the user pointed to by the currently clicked avatar
 *
 */
- (void)avatarDidSelected:(id<EaseUserProfile>)userData;

/**
 * Avatar long press event
 *
 * @param   userData        The current long-pressed Avatar points to the user profile
 *
 */
- (void)avatarDidLongPress:(id<EaseUserProfile>)userData;

/**
 * Custom cell
 *
 * @param tableView        Current Message view tableView
 * @param messageModel     Message data model
 *
 */
- (UITableViewCell *)cellForItem:(UITableView *)tableView messageModel:(EaseMessageModel *)messageModel;

/**
 * The extension data model group of the current custom cell
 *
 * @param   defaultLongPressItems       Default long - press extended area functional data model group     (The default values are copy, delete, and recall (the sending time is less than 2 minutes).)
 * @param   customCell                  Current long - pressed custom cell
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)customCellLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems customCell:(UITableViewCell*)customCell;


/* Input view callback */

/**
 * EaseChatKit callback before sending a message
 *
 * @param   aMessage      The message to be sent
 *
 */
- (AgoraChatMessage *)willSendMessage:(AgoraChatMessage *)aMessage;

/**
 * Send a message to complete the callback
 *
 * @param   message       Sending a completed message
 * @param   error         Message sending Result
 *
 */
-(void)didSendMessage:(AgoraChatMessage *)message error:(AgoraChatError *)error;

/**
 * The current session enters the extended area data model group
 *
 * @param   defaultInputBarItems        Default function Data model group (default order: photo album, camera, attachments)
 * @param   conversationType            Current session type: single chat, group chat, chat room
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)inputBarExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultInputBarItems conversationType:(AgoraChatConversationType)conversationType;

/**
 * Input area Keyboard input change callback example: @ group member
 *
 * @brief Input area Keyboard input change callback example: @ group member
 *
 */
- (BOOL)textViewShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**
 * 1v1 single chat Peer typing
 */
- (void)peerTyping;

/**
 * 1v1 single chat Peer end typing
 */
- (void)peerEndTyping;


/* Message event callback */

/**
 * Message click event (returns whether the default click event needs to be executed) Defaults to YES
 *
 * @param   message         The currently clicked message
 * @param   userData        The user profile carried by the currently clicked message
 *
 */
- (BOOL)didSelectMessageItem:(AgoraChatMessage *)message userProfile:(id<EaseUserProfile>)userData;

/**
 * The extended area data model group for the current specific message
 *
 * @param   defaultLongPressItems       Default long press extended area function Data model group (default: copy, delete, recall)
 * @param   message                     Current long-press message
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)messageLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems message:(AgoraChatMessage*)message;

@end

NS_ASSUME_NONNULL_END
