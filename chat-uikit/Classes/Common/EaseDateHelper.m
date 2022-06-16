//
//  EaseDateHelper.m
//  EaseChatKit
//
//  Created by XieYajie on 2019/2/12.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseDateHelper.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface EaseDateHelper()

@end


static EaseDateHelper *shared = nil;
@implementation EaseDateHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[EaseDateHelper alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

#pragma mark - Getter

- (NSDateFormatter *)_getDateFormatterWithFormat:(NSString *)aFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = aFormat;
    return dateFormatter;
}

- (NSDateFormatter *)dfYMD
{
    if (_dfYMD == nil) {
        _dfYMD = [self _getDateFormatterWithFormat:@"yyyy/MM/dd"];
    }
    
    return _dfYMD;
}

- (NSDateFormatter *)dfHM
{
    if (_dfHM == nil) {
        _dfHM = [self _getDateFormatterWithFormat:@"HH:mm"];
    }
    
    return _dfHM;
}

- (NSDateFormatter *)dfYMDHM
{
    if (_dfYMDHM == nil) {
        _dfYMDHM = [self _getDateFormatterWithFormat:@"yyyy/MM/dd HH:mm"];
    }
    
    return _dfYMDHM;
}

- (NSDateFormatter *)dfYesterdayHM
{
    if (_dfYesterdayHM == nil) {
        _dfYesterdayHM = [self _getDateFormatterWithFormat:@"HH:mm"];
    }
    
    return _dfYesterdayHM;
}

- (NSDateFormatter *)dfBeforeDawnHM
{
    if (_dfBeforeDawnHM == nil) {
        _dfBeforeDawnHM = [self _getDateFormatterWithFormat:@"hh:mm"];
    }
    
    return _dfBeforeDawnHM;
}

- (NSDateFormatter *)dfAAHM
{
    if (_dfAAHM == nil) {
        _dfAAHM = [self _getDateFormatterWithFormat:@"hh:mm"];
    }
    
    return _dfAAHM;
}

- (NSDateFormatter *)dfPPHM
{
    if (_dfPPHM == nil) {
        _dfPPHM = [self _getDateFormatterWithFormat:@"hh:mm"];
    }
    
    return _dfPPHM;
}

- (NSDateFormatter *)dfNightHM
{
    if (_dfNightHM == nil) {
        _dfNightHM = [self _getDateFormatterWithFormat:@"hh:mm"];
    }
    
    return _dfNightHM;
}

#pragma mark - Class Methods

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)aMilliSecond
{
    double timeInterval = aMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(aMilliSecond > 140000000000) {
        timeInterval = aMilliSecond / 1000;
    }
    NSDate *ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval dateType:(EaseDateType)type
{
    NSDate *date = [EaseDateHelper dateWithTimeIntervalInMilliSecondSince1970:aTimeInterval];
    if (type == EaseDateTypeChat) {
        return [EaseDateHelper formattedChatTime:date forDateFormatter:[EaseDateHelper shareHelper].dfYMD];
    }
    if (type == EaseDateTypeConversastion) {
        return [EaseDateHelper formattedConversationTime:date forDateFormatter:[EaseDateHelper shareHelper].dfYMD];
    }
    return @"";
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval forDateFormatter:(NSDateFormatter *)formatter  dateType:(EaseDateType)type {
    NSDate *date = [EaseDateHelper dateWithTimeIntervalInMilliSecondSince1970:aTimeInterval];
    if (type == EaseDateTypeChat) {
        return [EaseDateHelper formattedChatTime:date forDateFormatter:[EaseDateHelper shareHelper].dfYMD];
    }
    if (type == EaseDateTypeConversastion) {
        return [EaseDateHelper formattedConversationTime:date forDateFormatter:[EaseDateHelper shareHelper].dfYMD];
    }
    return @"";
}

+ (NSString *)formattedConversationTime:(NSDate *)aDate forDateFormatter:(NSDateFormatter *)formatter
{
    EaseDateHelper *helper = [EaseDateHelper shareHelper];
    
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8, 2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5, 2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0, 4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSInteger hour = [EaseDateHelper hoursFromDate:aDate toDate:date];
    NSDateFormatter *dateFormatter = helper.dfYMDHM;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:zone];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:aDate];
    
    if (hour <= 24 && hour >= 0) {
        dateFormatter = helper.dfHM;
    }
    else if (hour < 0 && hour >= -24) {
        return @"Yday";
    }
    else if (hour < -24 && hour >= -24 * 6) {
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat", nil];
        
        return [weekdays objectAtIndex:theComponents.weekday];
    } else {
        NSArray *months = [NSArray arrayWithObjects: [NSNull null], @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sept", @"Oct", @"Nov", @"Dec", nil];
        
        return [NSString stringWithFormat:@"%d %@ %d", theComponents.year, (NSString *)[months objectAtIndex:theComponents.month], theComponents.day];
    }
    
    return [dateFormatter stringFromDate:aDate];
}

+ (NSString *)formattedChatTime:(NSDate *)aDate forDateFormatter:(NSDateFormatter *)formatter
{
    EaseDateHelper *helper = [EaseDateHelper shareHelper];
    
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8, 2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5, 2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0, 4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    
    NSInteger hour = [EaseDateHelper hoursFromDate:aDate toDate:date];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    
    //If hasAMPM==TURE, use 12-hour clock, otherwise use 24-hour clock
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    NSString *ts = @"";
    
    if (!hasAMPM) { //24-hour clock
        if (hour <= 24 && hour >= 0) {
            dateFormatter = helper.dfHM;
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = helper.dfYesterdayHM;
            ts = @"Yday";
        } else {
            dateFormatter = helper.dfYMDHM;
        }
    } else {
        if (hour >= 0 && hour <= 6) {
            dateFormatter = helper.dfBeforeDawnHM;
            ts = @"Morn";
        } else if (hour > 6 && hour <= 11 ) {
            dateFormatter = helper.dfAAHM;
            ts = @"AM";
        } else if (hour > 11 && hour <= 17) {
            dateFormatter = helper.dfPPHM;
            ts = @"PM";
        } else if (hour > 17 && hour <= 24) {
            dateFormatter = helper.dfNightHM;
            ts = @"Night";
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = helper.dfYesterdayHM;
            ts = @"Yday";
        } else {
            dateFormatter = helper.dfYMDHM;
        }
    }
    
    ret = [dateFormatter stringFromDate:aDate];
    ret = [NSString stringWithFormat:@"%@%@", ts, ret];
    return ret;
}

#pragma mark Retrieving Intervals

+ (NSInteger)hoursFromDate:(NSDate *)aFromDate
                    toDate:(NSDate *)aToDate
{
    NSTimeInterval ti = [aFromDate timeIntervalSinceDate:aToDate];
    return (NSInteger) (ti / D_HOUR);
}

@end
