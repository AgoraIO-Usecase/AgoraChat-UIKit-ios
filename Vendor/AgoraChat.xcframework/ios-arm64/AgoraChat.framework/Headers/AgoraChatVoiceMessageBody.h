/**
 *  \
 *  @header AgoraChatVoiceMessageBody.h
 *  @abstract The voice message body.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatFileMessageBody.h"

/**
 *  \
 *  The voice message body.
 */
@interface AgoraChatVoiceMessageBody : AgoraChatFileMessageBody

/**
 *  \ 
 *  The voice duration in seconds. 
 * 
 */
@property (nonatomic) int duration;

/**
 *  \
 *  The text transcribed from the voice message.
 */
@property (nonatomic, copy, readonly) NSString *text;

-(instancetype _Nonnull ) init NS_UNAVAILABLE;
@end
