//
//  EaseDateHelper.h
//  EaseChatKit
//
//  Created by XieYajie on 2019/2/12.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_YEAR      31556926

NS_ASSUME_NONNULL_BEGIN

@interface EaseDateHelper : NSObject


@property (nonatomic, strong) NSDateFormatter *dfYMD;
@property (nonatomic, strong) NSDateFormatter *dfHM;
@property (nonatomic, strong) NSDateFormatter *dfYMDHM;
@property (nonatomic, strong) NSDateFormatter *dfYesterdayHM;

@property (nonatomic, strong) NSDateFormatter *dfBeforeDawnHM;
@property (nonatomic, strong) NSDateFormatter *dfAAHM;
@property (nonatomic, strong) NSDateFormatter *dfPPHM;
@property (nonatomic, strong) NSDateFormatter *dfNightHM;

typedef NS_ENUM(NSInteger, EaseDateType) {
    EaseDateTypeChat,
    EaseDateTypeConversastion
};

+ (instancetype)shareHelper;

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)aMilliSecond;

+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval dateType:(EaseDateType)type;

+ (NSString *)formattedTimeFromTimeInterval:(long long)aTimeInterval forDateFormatter:(NSDateFormatter *)formatter  dateType:(EaseDateType)type;

@end

NS_ASSUME_NONNULL_END
