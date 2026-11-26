//
//  AgoraChatSilentModeTime.h
//  AgoraChat
//
//  Created by hxq on 2022/3/30.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  \
 *  The silent message time object
 */
@interface AgoraChatSilentModeTime : NSObject <NSCopying,NSCoding>
/*!
 *  \
 *  The number of hours at a time point (The values of 0 to 24).
 *
 */
@property (nonatomic, assign, readonly) int hours;
/*!
 *  \
 *  The number of minutes at a time point (The values of 0 to 60).
 *
 */
@property (nonatomic, assign, readonly) int minutes;

/**
 *  \
 *  Initializes a time point instance.
 *
 *  @param aHours  The  time point hours.
 *  @param aMinutes  The  time point minutes.
 *
 *  @Result The  time point  instance.
 */
- (instancetype)initWithHours:(int)aHours minutes:(int)aMinutes;
@end

NS_ASSUME_NONNULL_END
