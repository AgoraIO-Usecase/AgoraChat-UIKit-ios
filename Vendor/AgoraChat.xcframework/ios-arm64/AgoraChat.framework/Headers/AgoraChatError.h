/**
 *  \
 *  @header AgoraChatError.h
 *  @abstract The SDK defined error.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatErrorCode.h"

/**
 *  \ 
 *  The error defined by the SDK.
 */
@interface AgoraChatError : NSObject

/**
 *  \ 
 *  The error code.
 */
@property (nonatomic) AgoraChatErrorCode code;

/**
 *  \ 
 *  The error description.
 */
@property (nonatomic, copy) NSString *errorDescription;


#pragma mark - Internal SDK

/**
 *  \
 *  Initializes an error instance.
 *
 *  @param aDescription  The Error description.
 *  @param aCode         The Error code.
 *
 *  @result The Error instance.
 */
- (instancetype)initWithDescription:(NSString *)aDescription
                               code:(AgoraChatErrorCode)aCode;

/**
 *  \
 *  Creates an error instance.
 *
 *  @param aDescription  The Error description.
 *  @param aCode         The Error code.
 *
 *  @result The Error instance.
 */
+ (instancetype _Nonnull)errorWithDescription:(NSString * _Nullable)aDescription
                                         code:(AgoraChatErrorCode)aCode;

@end
