//
//  AgoraChatThreadManagerDelegate.h
//  HyphenateSDK
//
//  Created by 朱继超 on 2022/3/1.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#ifndef AgoraChatThreadManagerDelegate_h
#define AgoraChatThreadManagerDelegate_h
#import "AgoraChatThread.h"
#import "AgoraChatThreadEvent.h"
NS_ASSUME_NONNULL_BEGIN
/*!
 *  \
 *  The message thread event callback protocol.
 */
@protocol AgoraChatThreadManagerDelegate <NSObject>

@optional
/*!
 *  \
 *  Occurs when a message thread is created.
 * 
 *  @param event The message thread creation event {@link AgoraChatThreadEvent}, which contains the message thread information.
 */
- (void)onChatThreadCreate:(AgoraChatThreadEvent *)event;
/*!
 *  \
 * Occurs when the message thread is updated.
 * 
 * This callback is triggered when the message thread name is changed or a threaded reply is added or recalled.
 *  
 * @param event The message thread update event {@link AgoraChatThreadEvent}, which contains the message thread information.
 */
- (void)onChatThreadUpdate:(AgoraChatThreadEvent *)event;
/*!
 *  \
 *  Occurs when the message thread is destroyed.
 * 
 *  @param event The message thread destruction event {@link AgoraChatThreadEvent}, which contains the message thread information.
 */
- (void)onChatThreadDestroy:(AgoraChatThreadEvent *)event;
/*!
 *  \
 *  Occurs when a user is kicked out of the message thread.
 * 
 *  @param event The user removal event {@link AgoraChatThreadEvent}, which contains the message thread information.
 */
- (void)onUserKickOutOfChatThread:(AgoraChatThreadEvent *)event;

@end

NS_ASSUME_NONNULL_END

#endif /* AgoraChatThreadManagerDelegate_h */
