//
//  AgoraChatMessageReaction.h
//  AgoraChat
//
//  Created by 冯钊 on 2022/2/11.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The message reaction object.
 */
@interface AgoraChatMessageReaction : NSObject

/**
 *  \
 *  The Reaction content.
 */
@property (readonly, nullable) NSString *reaction;

/**
 *  \
 *  The count of the users who added this Reaction.
 */
@property (readonly) NSUInteger count;

/**
 *  \
 *  Whether the current user added this Reaction.
 *  - `Yes`: Yes;
 *  - `No`: No.
 */
@property (readonly) BOOL isAddedBySelf;

/**
 *  \
 *  The list of users that added this Reaction.
 *
 *  **Note**
 *  To get the entire list of users adding this Reaction, you can call {@link #getReactionDetail(IAgoraChatManager)} which returns the user list with pagination. Other methods like {@link #reactionList(AgoraChatMessage)}, {@link #getReactionList(IAgoraChatManager)} or {@link messageReactionDidChange(AgoraChatManagerDelegate)} can get the first three users.
 */
@property (readonly, nullable) NSArray <NSString *>*userList;

@end

NS_ASSUME_NONNULL_END
