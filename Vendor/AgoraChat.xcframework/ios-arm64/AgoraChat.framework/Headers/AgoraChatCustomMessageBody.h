/**
 *  \
 *  @header AgoraChatCustomMessageBody.h
 *  @abstract Custom message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatCommonDefs.h"
#import "AgoraChatMessageBody.h"

/**
 *  \
 *  The custom message body.
 */
@interface AgoraChatCustomMessageBody : AgoraChatMessageBody

/**
 *  \
 *  The custom event.
 */
@property (nonatomic, copy) NSString *event;

/**
 *  \
 *  The custom extension dictionary.
 */
@property (nonatomic, copy) NSDictionary<NSString *,NSString *> *customExt;


/**
 *  \
 *  Initializes a custom message body instance.
 *
 *  @param aEvent   The custom event.
 *  @param aCustomExt The custom extension dictionary.
 *
 *  @result The custom message body instance.
 */
- (instancetype _Nonnull)initWithEvent:(NSString *_Nullable)aEvent customExt:(NSDictionary<NSString *,NSString *> *_Nullable)aCustomExt;

-(instancetype _Nonnull ) init __attribute__((unavailable("call initWithEvent:customExt: instead")));
@end
