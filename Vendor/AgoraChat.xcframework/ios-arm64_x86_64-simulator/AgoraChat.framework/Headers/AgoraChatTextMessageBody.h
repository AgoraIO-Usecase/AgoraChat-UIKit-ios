/**
 *  \
 *  @header AgoraChatTextMessageBody.h
 *  @abstract The text message body.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"

/**
 *  \ 
 *  The text message body.   
 */
@interface AgoraChatTextMessageBody : AgoraChatMessageBody

/**
 *  \ 
 *  The text content.
 */
@property (nonatomic, copy, readonly) NSString *_Nonnull text;

/**
 *  \
 *  The target language codes to translate.
 */
@property (nonatomic, copy) NSArray<NSString*>*_Nullable targetLanguages;

/**
 *  \
 *  Translated information.
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString*,NSString*>*_Nullable translations;
 
/**
 *  \
 *  Initializes a text message body instance.
 *
 *  @param aText   The text content.
 *
 *  @result The text message body instance.
 */
- (instancetype _Nonnull)initWithText:(NSString *_Nullable)aText;

-(instancetype _Nonnull ) init __attribute__((unavailable("call initWithText: instead")));
@end
