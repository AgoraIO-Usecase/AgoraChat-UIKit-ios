/**
 *  \
 *  @header AgoraChatUserInfoManagerDelegate.h
 *  @abstract The delegate protocol for user information change callbacks.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import "AgoraChatUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The delegate protocol for user information change callbacks.
 */
@protocol AgoraChatUserInfoManagerDelegate <NSObject>

@optional

/**
 *  \
 *  Occurs when the current user's information is updated.
 *
 *  @param aUserInfo  The updated user information.
 */
- (void)onSelfUserInfoUpdate:(AgoraChatUserInfo * _Nonnull)aUserInfo;

/**
 *  \
 *  Occurs when other users' information is updated.
 *
 *  @param aUserInfos  The dictionary of updated user information, where the key is the user ID and the value is the user information. When the user information update time of the received message is greater than the local cached update time, the SDK will re-fetch the user information from the server and trigger this callback.
 */
- (void)onUserInfoUpdate:(NSDictionary<NSString *, AgoraChatUserInfo *> * _Nonnull)aUserInfos;

@end

NS_ASSUME_NONNULL_END
