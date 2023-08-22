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
#import "EditToolBar.h"

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
- (nullable id<EaseUserProfile>)userProfile:(NSString *)userID;

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
- (nullable UITableViewCell *)cellForItem:(UITableView *)tableView messageModel:(EaseMessageModel *)messageModel;

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
-(void)didSendMessage:(AgoraChatMessage *)message error:(nullable AgoraChatError *)error;

-(void)didSendMessage:(AgoraChatMessage *)message thread:(AgoraChatThread *)thread error:(nullable AgoraChatError *)error;

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
- (BOOL)textView:(UITextView*)textView ShouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**
 * Input area selection change callback example: @ group member
 */
- (void)textViewDidChangeSelection:(UITextView *)textView;
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

/**
 * The extended area data model group for the current specific message model
 *
 * @param   defaultLongPressItems       Default long press extended area function Data model group (default: copy, delete, recall)
 * @param   messageModel                     Current long-press message model
 *
 */
- (NSMutableArray<EaseExtendMenuModel *> *)messageLongPressExtMenuItemArray:(NSMutableArray<EaseExtendMenuModel*>*)defaultLongPressItems messageModel:(EaseMessageModel*)messageModel;



//MARK: - chatThreadFunction
- (void)didSelectThreadBubble:(EaseMessageModel *)model;

- (void)createThread:(EaseMessageModel *)model;
//MARK: - joined thread

/// Description When you receive create thread notification message,click text join in the thread.
/// - Parameter threadId: threadId
- (void)joinChatThreadFromNotifyMessage:(NSString *)threadId;

/// Description pop back
- (void)popThreadChat;

/// Description When owner or admin changed thread name,you'll receive it.
/// - Parameter threadName: threadName updated
- (void)threadNameChange:(NSString *)threadName;
//TODO: - 增加thread对象回调

/// Description thread chat header
- (UIView *)threadChatHeader;

/// Description Whether show reaction menu item,you decide.
/// - Parameter message: AgoraChatMessage
- (BOOL)messageLongPressExtShowReaction:(AgoraChatMessage *)message;
// table end scrolling
- (void)scrollViewEndScroll;

/// Description when you want change input bar reply message content,you can return a string.
/// - Parameter message: AgoraChatMessage
- (nullable NSString *)chatBarQuoteMessageShowContent:(AgoraChatMessage *)message;

/// Description When you want custom quote view,you can return a NSAttributedString.
/// - Parameter message: AgoraChatMessage
- (NSAttributedString *)messageCellQuoteViewShowContent:(AgoraChatMessage *)message;

/// Description If you want get  on click quote events,you can implement this method.
/// - Parameter message  AgoraChatMessage
- (BOOL)messageCellDidClickQuote:(AgoraChatMessage *)message;

/// Description If you want get  long press quote events,you can implement this method.
/// - Parameter message: AgoraChatMessage
- (BOOL)messageCellDidLongPressQuote:(AgoraChatMessage *)message;

/// Description When you selected  a message,`EaseChatViewController` will enter edit mode,you can decide whether or not show edit bar.
- (BOOL)messageListEntryEditModeWhetherShowBottom;

/// Description If you implement this means that you want custom modify action flow.
- (void)messageEditAction;

/// Description When `self` enter edit mode,you can click edit bar button to implement some function.
/// - Parameter type: EditBarOperationType contains `Delete` or `Forward`
- (void)messageListEntryEditModeThenOperation:(EditBarOperationType)type;

/// Description When you edit message content,a edited symbol will occur message bottom.you can customize it.
- (NSAttributedString *)editedMessageContentSymbol;

@end

NS_ASSUME_NONNULL_END
