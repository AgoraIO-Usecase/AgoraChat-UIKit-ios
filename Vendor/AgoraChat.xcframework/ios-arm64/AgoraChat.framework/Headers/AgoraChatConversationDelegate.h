/**
 *  \
 *  @header AgoraChatConversationDelegate.h
 *  @abstract This protocol defines conversation-related callbacks.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

@class AgoraChatConversation;

/**
 *  \
 *  The conversation-related callbacks.
 */
@protocol AgoraChatConversationDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when the conversation list changes.
 *
 *  @param aConversationList  The updated array of conversations.
 */
- (void)conversationListDidUpdate:(NSArray<AgoraChatConversation *> * _Nonnull)aConversationList;

@end
