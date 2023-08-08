//
//  EaseUserUtils.h
//  EaseIMKit
//
//  Created by 冯钊 on 2023/4/27.
//

#import <Foundation/Foundation.h>
#import "EaseUserProfile.h"

typedef NS_ENUM(NSUInteger, EaseUserModuleType) {
    EaseUserModuleTypeChat,
    EaseUserModuleTypeGroupChat,
};

NS_ASSUME_NONNULL_BEGIN

@protocol EaseUserUtilsDelegate <NSObject>

- (nullable id<EaseUserProfile>)getUserInfo:(NSString *)easeId moduleType:(EaseUserModuleType)moduleType;

@end

@interface EaseUserUtils : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id<EaseUserUtilsDelegate> delegate;

- (nullable id<EaseUserProfile>)getUserInfo:(NSString *)easeId moduleType:(EaseUserModuleType)moduleType;

@end

NS_ASSUME_NONNULL_END
