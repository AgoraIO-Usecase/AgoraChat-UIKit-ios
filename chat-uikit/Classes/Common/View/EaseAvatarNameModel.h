//
//  EaseAvatarNameModel.h
//  EaseIM
//
//  Created by zhangchong on 2020/8/19.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EaseHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseAvatarNameModel : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImage *avatarImg;

@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) NSAttributedString *detail;

@property (nonatomic, strong) NSString *timestamp;

- (instancetype)initWithInfo:(NSString *)keyWord img:(UIImage *)img msg:(AgoraChatMessage *)msg time:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
