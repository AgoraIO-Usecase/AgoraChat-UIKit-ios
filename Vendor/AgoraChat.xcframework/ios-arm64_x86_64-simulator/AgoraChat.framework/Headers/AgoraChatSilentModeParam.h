//
//  AgoraChatSilentModeParam.h
//  AgoraChat
//
//  Created by hxq on 2022/3/30.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatSilentModeTime.h"

/**
 *  \
 *  Parameter type to no-disturbing mode.
 */
typedef NS_ENUM(NSInteger, AgoraChatSilentModeParamType) {
    AgoraChatSilentModeParamTypeRemindType = 0 , /*!
                                            *  \
                                            * Set push remind type, Single chat not support.
                                            */
    AgoraChatSilentModeParamTypeDuration   , /*!
                                            *  \
                                            * Set silent message duraation.
                                            *
                                            */
    
    AgoraChatSilentModeParamTypeInterval,/*!
                                      *  \
                                      * Set silent message time Interval.
                                      *
                                      */
   

};

/**
 *  \
 *  The remind type of push message.
 */
typedef NS_ENUM(NSInteger, AgoraChatPushRemindType) {
    
    AgoraChatPushRemindTypeAll   , /*!
                                            *  \
                                            * All messages are remind.
                                            */
    AgoraChatPushRemindTypeMentionOnly,/*!
                                      *  \
                                      * Only @me messages are remind.
                                      */
  
    AgoraChatPushRemindTypeNone,/*!
                               *  \
                               * All messages are not remind.
                               */

} ;

/**
 *  \
 *  The silent message params object
 */
@interface AgoraChatSilentModeParam : NSObject
/**
 *  \
 *  Parameter type for silent messages.
 *
 *  If parmType is AgoraChatSilentModeParamTypeRemindType，only the remindType parameter is set.
 *  If parmType is AgoraChatSilentModeParamTypeDuration，only the silentModeDuration parameter is set.
 *  If parmType is AgoraChatSilentModeParamTypeInterval，only the silentModeStartTime and silentModeEndTime  parameters are set.
 */
@property (nonatomic, assign, readonly) AgoraChatSilentModeParamType paramType;
/**
 *  \
 *  The duration for silent messages (in minute).
 *  A value of 0 indicates that silent messages is disabled，A maximum of 7 x 24 x 60 minutes can be set.An expiration timestamp is returned， disabled return 0.
 */
@property (nonatomic, assign) int silentModeDuration;
/**
 *  \
 *   The remind type for push messages.
 */
@property (nonatomic, assign) AgoraChatPushRemindType remindType;
/**
 *  \
 *  The start time of interval type for application push silent mode.
 *
 *  Note: The start time and end time must be both specified.
 *
 */
@property (nonatomic, strong) AgoraChatSilentModeTime *_Nullable silentModeStartTime;
/**
 *  \
 *  The end time of interval type for application push silent mode.
 *
 *  Note: The start time and end time must be both specified.
 *
 */
@property (nonatomic, strong) AgoraChatSilentModeTime *_Nullable silentModeEndTime;

- (instancetype _Nonnull)initWithParamType:(AgoraChatSilentModeParamType)aParamType;
@end

