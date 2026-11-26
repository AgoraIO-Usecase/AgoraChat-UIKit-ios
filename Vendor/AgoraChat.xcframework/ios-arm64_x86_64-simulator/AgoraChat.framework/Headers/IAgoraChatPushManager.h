//
//  IAgoraChatPushManager.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2020/10/26.
//  Copyright © 2020 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatCommonDefs.h"
#import "AgoraChatPushOptions.h"
#import "AgoraChatError.h"
#import "AgoraChatCursorResult.h"
#import "AgoraChatSilentModeResult.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  \
 *  @header IAgoraChatPushManager.h
 *  @abstract The push related management protocol class.
 *  @author Hyphenate
 *  @version 3.00
 */

@protocol IAgoraChatPushManager <NSObject>

/**
 *  \
 *  The message push configuration options.
 *
 */
@property (nonatomic, strong, readonly) AgoraChatPushOptions *_Nullable pushOptions;



/**
 *  \
 *  Sets the display style for the push notification.
 * 
 *  This is an asynchronous method.
 *
 *  @param pushDisplayStyle     The display style of the push notification.
 *  @param aCompletionBlock     The completion block, which contains the error message if the method fails.
 */
- (void)updatePushDisplayStyle:(AgoraChatPushDisplayStyle)pushDisplayStyle
                    completion:(void (^ _Nullable)(AgoraChatError * _Nullable aError))aCompletionBlock;

/**
 *  \
 *  Sets the display name of the push notification.
 * 
 *  This is an asynchronous method.
 *
 *  @param aDisplayName     The display name of the push notification.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)updatePushDisplayName:(NSString * _Nonnull)aDisplayName
                   completion:(void (^_Nullable)(NSString * _Nullable aDisplayName, AgoraChatError * _Nullable aError))aCompletionBlock;



/**
 *  \
 *  Gets the push options from the server.
 * 
 *  This is an asynchronous method.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
- (void)getPushNotificationOptionsFromServerWithCompletion:(void (^_Nullable )(AgoraChatPushOptions *_Nullable aOptions, AgoraChatError *_Nullable aError))aCompletionBlock;


/**
 *  \
 *  Set global silent mode  message data.
 *
 *  @param aParam Silent mode data parameter model ,See AgoraChatSilentModeParam.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)setSilentModeForAll:(AgoraChatSilentModeParam*_Nullable )aParam completion:(void (^_Nullable )(AgoraChatSilentModeResult *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Get global silent mode  message data.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 */
-(void)getSilentModeForAllWithCompletion:(void (^_Nullable )(AgoraChatSilentModeResult *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Get all conversations mute info from server.
 *
 *  @param completionBlock The method completes the callback called. If the method call fails, the reason for the failure will be included. If the callback `AgoraChatError` is empty, you can call the `IAgoraChatManager#getAllConversations` method to re-obtain the session list and refresh the UI..
 */
- (void)syncSilentModeConversationsFromServerCompletion:(void (^_Nullable )(AgoraChatError *_Nullable error))completionBlock;



/**
 *  \
 *  Set conversation silent mode  message data.
 *
 *  @param aConversationId  The conversation Id.
 *  @param aConversationType  The conversation type.
 *  @param aParam Silent mode data parameter model ,See AgoraChatSilentModeParam.
 *  @param aCompletionBlock  The completion block, which contains the error message if the method fails.
 *
 */
- (void)setSilentModeForConversation:(NSString*_Nonnull)aConversationId
                    conversationType:(AgoraChatConversationType)aConversationType
                              params:(AgoraChatSilentModeParam*_Nullable )aParam
                          completion:(void (^_Nullable )(AgoraChatSilentModeResult *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Get conversation silent mode  message data.
 *
 *  @param aConversationId  The conversation Id.
 *  @param aConversationType  The conversation type.
 *  @param aCompletionBlock  The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)getSilentModeForConversation:(NSString*_Nonnull)aConversationId
                    conversationType:(AgoraChatConversationType)aConversationType
                          completion:(void (^_Nullable )(AgoraChatSilentModeResult *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Clear conversation  remind type for push messages.
 *
 *  @param aConversationId  The conversation Id.
 *  @param aConversationType  The conversation type.
 *  @param aCompletionBlock  The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)clearRemindTypeForConversation:(NSString*_Nonnull)aConversationId
                      conversationType:(AgoraChatConversationType)aConversationType
                            completion:(void (^_Nullable )(AgoraChatSilentModeResult *_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Gets the silent mode data setting for multiple sessions.
 *  Notice:A maximum of 20 pieces of data at a time.If it is not set or set to expire , it will not be returned in the result dictionary
 *
 *  @param aConversationArray The conversations array。
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 */
- (void)getSilentModeForConversations:(NSArray<AgoraChatConversation *>*_Nonnull)aConversationArray
                           completion:(void (^_Nullable )(NSDictionary<NSString*,AgoraChatSilentModeResult*>*_Nullable aResult, AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Set the translation language for push messages.
 *
 *  @param aLaguangeCode Translation language code.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)setPreferredNotificationLanguage:(NSString*_Nullable)aLaguangeCode
                              completion:(void (^_Nullable )(AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *  Get the translation language for push messages.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)getPreferredNotificationLanguageCompletion:(void (^_Nullable )(NSString *_Nullable aLaguangeCode,AgoraChatError *_Nullable aError))aCompletionBlock;

/**
 *  \
 *  Set the push template for offline push.
 *
 *  @param aPushTemplateName push template name.
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)setPushTemplate:(NSString* _Nullable)aPushTemplateName
             completion:(void (^ _Nullable)(AgoraChatError *_Nullable aError))aCompletionBlock;
/**
 *  \
 *   Gets the offline push template for Settings.
 *
 *  @param aCompletionBlock The completion block, which contains the error message if the method fails.
 *
 *
 */
- (void)getPushTemplate:(void (^ _Nullable)(NSString *_Nullable aPushTemplateName, AgoraChatError *_Nullable aError))aCompletionBlock;



@end

NS_ASSUME_NONNULL_END
