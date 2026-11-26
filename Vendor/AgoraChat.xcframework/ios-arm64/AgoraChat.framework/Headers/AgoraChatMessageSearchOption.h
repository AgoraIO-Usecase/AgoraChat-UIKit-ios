//
//  AgoraChatMessageSearchOption.h
//  AgoraChat
//
//  Created by OpenAI Codex on 2026/4/2.
//

#import <Foundation/Foundation.h>
#import "AgoraChatConversation.h"

/**
 *  \
 *  The match type for search keywords.
 */
typedef NS_ENUM(NSInteger, EMKeywordListMatchType) {
    EMKeywordListMatchTypeOR,
    EMKeywordListMatchTypeAND
};
/**
 *  \
 *  The parameter configuration class for server message search.
 *  This feature requires the "Message Search" service to be enabled in the Console.
 */
@interface AgoraChatMessageSearchOption : NSObject

/**
 \ The search keyword list (each keyword 1-120 characters, total maximum 120 characters, up to 5 keywords).
 */
@property (nonatomic, strong) NSArray<NSString *> * _Nonnull keywordList;

/**
 \ The search keyword match type
 */
@property (nonatomic) EMKeywordListMatchType keywordMatchType;

/**
 \ Conversation ID filter (optional). For one-to-one chat, it is the other user's ID; for group/chatroom, it is the group/chatroom ID. Empty means searching all conversations.
 */
@property (nonatomic, strong) NSString * _Nullable conversationId;

/**
 \ Message type filter (optional), does not support command messages and voice messages search.
 */
@property (nonatomic, strong) NSArray<NSNumber *> * _Nullable msgTypes;

/**
 \ The start time for query. Unix timestamp in milliseconds. Must be specified with endTime.
 */
@property (nonatomic) NSInteger startTime;

/**
 \ The end time for query. Unix timestamp in milliseconds. Must be specified with startTime.
 */
@property (nonatomic) NSInteger endTime;

/**
 \ Search scope (default content only). See {@link AgoraChatConversation.AgoraChatMessageSearchScope}.
 */
@property (nonatomic) AgoraChatMessageSearchScope searchScope;
@end
