/**
 *  \
 *  @header AgoraChatCmdMessageBody.h
 *  @abstract The command message body object.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"

/**
 *  \
 *  The command message body.
 */
@interface AgoraChatCmdMessageBody : AgoraChatMessageBody

/**
 *  \
 *  The command content.
 */
@property (nonatomic, copy) NSString *action;

/**
 *  \
 *  Whether this cmd msg is delivered to the online users only. The default value is NO. Set this parameter as YES and the msg is delivered to the online users only, so the offline users won't receive the msg when they log in later.
 */
@property (nonatomic) BOOL isDeliverOnlineOnly;

/**
 *  \
 *  The construct command message body.
 *  Developer self-defined command string that can be used for specifing custom action/command. See `ext` in `AgoraChatMessage`.
 *  
 *  @param aAction  The self-defined command string content.
 *
 *  @result The instance of command message body.
 */
- (instancetype _Nonnull)initWithAction:(NSString * _Nonnull)aAction;

-(instancetype _Nonnull ) init __attribute__((unavailable("call initWithAction: instead")));
@end
