//
//  AgoraChatCombineMessageBody.h
//  AgoraChat
//
//  Created by li xiaoming on 2023/6/19.
//  Copyright © 2023 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatFileMessageBody.h"

/**
 *  \
 *  The combine message body.
 */
@interface AgoraChatCombineMessageBody : AgoraChatFileMessageBody

/**
 *  \
 *  The message title.
 */
@property (nonatomic,strong) NSString*_Nullable title;

/**
 *  \
 *  The message summary.
 */
@property (nonatomic,strong) NSString*_Nullable summary;

/**
 *  \
 *  The compatible text.
 */
@property (nonatomic,strong) NSString*_Nullable compatibleText;

/**
 *  \
 *  Get the list of messageId included in the combined message.
 */
@property (nonatomic,readonly) NSArray<NSString *> * _Nonnull messageIdList;

/**
 *  \
 *  Initializes a combined message body instance.
 *
 *  @param aTitle   The title of the combined message.
 *  @param aSummary The summary of the combined message.
 *  @param aCompatibleText The compatible text.
 *  @param aMessageIdList The list of messageId included in the combined message.
 *
 *  @result The combined message body instance.
 */

- (instancetype _Nonnull)initWithTitle:(NSString *_Nullable)aTitle
                               summary:(NSString *_Nullable)aSummary
                        compatibleText:(NSString *_Nullable)aCompatibleText
                         messageIdList:(NSArray<NSString*>*_Nonnull)aMessageIdList;

-(instancetype _Nonnull ) init NS_UNAVAILABLE;
@end
