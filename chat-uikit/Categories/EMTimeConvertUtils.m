//
//  EMTimeConvertUtils.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/18.
//

#import "EMTimeConvertUtils.h"

@implementation EMTimeConvertUtils

#pragma mark - 将某个时间String转化成 时间戳
+ (NSInteger )timeConvertTimestamp:(NSString *)formatTime formatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];  //（@"YYYY-MM-dd hh:mm:ss"）----------注意>hh为12小时制,HH为24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    timeSp *= 1000;
    return timeSp;
}

#pragma mark - 将某个时间戳转化成 时间Str
+ (NSString *)timestampConvertTime:(NSInteger)timestamp formatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    timestamp /= 1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    if ([format isEqual:@"HH:mm:ss"] && confromTimespStr.length<8) {
        confromTimespStr = @"00:00:00";
    }
    if ([format isEqual:@"YYYY-MM-dd HH:mm:ss"] && confromTimespStr.length<18) {
        confromTimespStr = @"2000-01-01 00:00:00"; //默认返回
    }
    return confromTimespStr;
}

+ (struct EMTimeTuple)durations:(NSTimeInterval )timeStamp {
    // 当前时间
    NSDate *ago = [NSDate dateWithTimeIntervalSince1970:(timeStamp/1000.0)];
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得NSDate的每一个元素
    NSInteger years = [calendar component:NSCalendarUnitYear fromDate:ago];
    NSInteger months = [calendar component:NSCalendarUnitMonth fromDate:ago];
    NSInteger weeks = [calendar component:NSCalendarUnitWeekOfMonth fromDate:ago];
    NSInteger days = [calendar component:NSCalendarUnitDay fromDate:ago];
    NSInteger hours = [calendar component:NSCalendarUnitHour fromDate:ago];
    NSInteger minutes = [calendar component:NSCalendarUnitMinute fromDate:ago];
    NSInteger seconds = [calendar component:NSCalendarUnitSecond fromDate:ago];
    if (seconds < 60) {
        struct EMTimeTuple tuple = {NSCalendarUnitMinute,1};
        return tuple;
    }
    if (minutes < 60) {
        struct EMTimeTuple tuple = {NSCalendarUnitMinute,minutes};
        return tuple;
    }
    if (minutes >= 60 && hours <= 24) {
        struct EMTimeTuple tuple = {NSCalendarUnitHour,hours};
        return tuple;
    }
    if (weeks < 1 && days >= 1) {
        struct EMTimeTuple tuple = {NSCalendarUnitDay,days};
        return tuple;
    }
    if (weeks >= 1 && months < 1) {
        struct EMTimeTuple tuple = {NSCalendarUnitWeekOfMonth,weeks};
        return tuple;
    }
    if (months >= 1 && years < 1) {
        struct EMTimeTuple tuple = {NSCalendarUnitMonth,months};
        return tuple;
    }
    if (years >= 1) {
        struct EMTimeTuple tuple = {NSCalendarUnitYear,years};
        return tuple;
    }
    struct EMTimeTuple tuple = {-999,-999};
    return tuple;
}

+ (NSString *)durationString:(NSTimeInterval )timeStamp {
    if (timeStamp <= 0) {
        return @"";
    }
    // 当前时间
    NSDate *ago = [NSDate dateWithTimeIntervalSince1970:(timeStamp/1000.0)];
    
    NSDate *current = [NSDate date];
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得NSDate的每一个元素
    NSInteger years = [calendar component:NSCalendarUnitYear fromDate:current] - [calendar component:NSCalendarUnitYear fromDate:ago];
    NSInteger months =  [calendar component:NSCalendarUnitMonth fromDate:current] - [calendar component:NSCalendarUnitMonth fromDate:ago];
    NSInteger weeks =  [calendar component:NSCalendarUnitWeekOfMonth fromDate:current] - [calendar component:NSCalendarUnitWeekOfMonth fromDate:ago];
    NSInteger days =  [calendar component:NSCalendarUnitDay fromDate:current] - [calendar component:NSCalendarUnitDay fromDate:ago];
    NSInteger hours =  [calendar component:NSCalendarUnitHour fromDate:current] - [calendar component:NSCalendarUnitHour fromDate:ago];
    NSInteger minutes =  [calendar component:NSCalendarUnitMinute fromDate:current] - [calendar component:NSCalendarUnitMinute fromDate:ago];
    NSInteger seconds =  [calendar component:NSCalendarUnitSecond fromDate:current] - [calendar component:NSCalendarUnitSecond fromDate:ago];
    
    if (years >= 1) {
        return [NSString stringWithFormat:@"%luy ago",years];
    }
    if (months >= 1 && months < 12) {
        return [NSString stringWithFormat:@"%lumo ago",months];
    }
    if (weeks >= 1 && months < 1) {
        return [NSString stringWithFormat:@"%luw ago",weeks];
    }
    if (days < 7 && days >= 1) {
        return [NSString stringWithFormat:@"%lud ago",days];
    }
    if (hours >= 1 && hours < 24) {
        return [NSString stringWithFormat:@"%luh ago",hours];
    }
    if (minutes >= 1 && minutes < 60) {
        return [NSString stringWithFormat:@"%lum ago",minutes];
    }
    if (seconds < 60 && minutes < 1) {
        return @"1m ago";
    }
    return @"recently";
}

@end
