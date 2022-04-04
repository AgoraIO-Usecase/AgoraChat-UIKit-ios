//
//  EMTimeConvertUtils.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/18.
//

#import <Foundation/Foundation.h>


struct EMTimeTuple {
    NSCalendarUnit unitType;//差值类型 minute hour day week month year
    NSInteger intervals;//相差间隔数
};

@interface EMTimeConvertUtils : NSObject

+ (NSInteger )timeConvertTimestamp:(NSString *)formatTime formatter:(NSString *)format;

+ (NSString *)timestampConvertTime:(NSInteger)timestamp formatter:(NSString *)format;

/// Description 根据时间戳与当前时间比对获取差值转换为相差的年数月数周数天数时数分数
/// @param timeStamp a timestamp
+ (struct EMTimeTuple)durations:(NSTimeInterval )timeStamp;

+ (NSString *)durationString:(NSTimeInterval )timeStamp;

@end

