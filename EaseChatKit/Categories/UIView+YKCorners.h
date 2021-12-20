//
//  UIView+YKCorners.h
//  YKCornersButton_Example
//
//  Created by 吴焰基 on 2019/8/14.
//  Copyright © 2019 SDGH-technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YKCorners)

//圆角的方向
- (UIView * (^)(UIRectCorner))radiusCorner;
//圆角的弧度
- (UIView * (^)(CGFloat))radiusFloat;
//边线长度
- (UIView * (^)(CGFloat))lineWidth;
//边线颜色
- (UIView * (^)(UIColor *))lineColor;
//填充颜色
- (UIView * (^)(UIColor *))fillColor;

//手动加载绘制
- (void)manualDrawing;

@end

NS_ASSUME_NONNULL_END
