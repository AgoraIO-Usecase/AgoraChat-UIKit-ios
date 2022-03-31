//
//  EMHollowedOutPathDelegate.h
//  EaseIMKit
//
//  Created by 冯钊 on 2022/3/7.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol EMHollowedOutPathDelegate <NSObject>

- (NSArray <UIBezierPath *>*)hollowedOutPathsInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
