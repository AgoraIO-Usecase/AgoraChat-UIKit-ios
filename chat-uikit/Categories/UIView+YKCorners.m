//
//  UIView+YKCorners.m
//  YKCornersButton_Example
//
//  Created by 吴焰基 on 2019/8/14.
//  Copyright © 2019 SDGH-technology. All rights reserved.
//

#import "UIView+YKCorners.h"
#import <objc/runtime.h>
#import "EaseChatViewModel.h"

static NSString *radiusFloatKey = @"radiusFloatKey";
static NSString *radiusCornerKey = @"radiusCornerKey";
static NSString *lineColorKey = @"lineColorKey";
static NSString *lineWidthKey = @"lineWidthKey";
static NSString *fillColorKey = @"fillColorKey";
static NSString *shapeLayerKey = @"shapeLayerKey";

@interface UIView()

/**
 圆角弧度
 */
@property (nonatomic, assign) CGFloat _radiusFloat;
/**
 圆角方向
 */
@property (nonatomic, assign) UIRectCorner _radiusCorner;
/**
 边线颜色
 */
@property (nonatomic, strong) UIColor *_lineColor;
/**
 边线宽度
 */
@property (nonatomic, assign) CGFloat _lineWidth;
/**
 内部颜色
 */
@property (nonatomic, strong) UIColor *_fillColor;
/**
 绘制 layer
 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation UIView (YKCorners)

#pragma mark - getter

- (CGFloat)_radiusFloat {
    return [objc_getAssociatedObject(self, &radiusFloatKey) floatValue];
}
- (UIRectCorner)_radiusCorner {
    return [objc_getAssociatedObject(self, &radiusCornerKey) unsignedIntegerValue];
}
- (UIColor *)_lineColor {
    return objc_getAssociatedObject(self, &lineColorKey);
}
- (CGFloat)_lineWidth {
    return [objc_getAssociatedObject(self, &lineWidthKey) floatValue];
}
- (UIColor *)_fillColor {
    return objc_getAssociatedObject(self, &fillColorKey);
}
- (CAShapeLayer *)shapeLayer {
    return objc_getAssociatedObject(self, &shapeLayerKey);
}

#pragma mark - setter
- (void)set_radiusFloat:(CGFloat)radiusFloat {
    objc_setAssociatedObject(self, &radiusFloatKey, [NSNumber numberWithFloat:radiusFloat], OBJC_ASSOCIATION_COPY);
}
- (void)set_radiusCorner:(NSUInteger)radiusCorner {
    objc_setAssociatedObject(self, &radiusCornerKey, [NSNumber numberWithUnsignedInteger:radiusCorner], OBJC_ASSOCIATION_COPY);
}
- (void)set_lineColor:(UIColor *)lineColor {
    objc_setAssociatedObject(self, &lineColorKey, lineColor, OBJC_ASSOCIATION_RETAIN);
}
- (void)set_lineWidth:(CGFloat)radiusFloat {
    objc_setAssociatedObject(self, &lineWidthKey, [NSNumber numberWithFloat:radiusFloat], OBJC_ASSOCIATION_COPY);
}
- (void)set_fillColor:(UIColor *)fillColor {
    objc_setAssociatedObject(self, &fillColorKey, fillColor, OBJC_ASSOCIATION_RETAIN);
}
- (void)setShapeLayer:(CAShapeLayer *)shapeLayer {
    objc_setAssociatedObject(self, &shapeLayerKey, shapeLayer, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - method

- (UIView * (^)(UIRectCorner))radiusCorner {
    return ^(UIRectCorner radiusCorner) {
        self._radiusCorner = radiusCorner;
        return self;
    };
}

- (UIView * (^)(CGFloat))radiusFloat {
    return ^(CGFloat radiusFloat) {
        self._radiusFloat = radiusFloat;
        return self;
    };
}

- (UIView * (^)(CGFloat))lineWidth {
    return ^(CGFloat lineWidth) {
        self._lineWidth = lineWidth;
        return self;
    };
}


- (UIView * (^)(UIColor *))lineColor {
    return ^(UIColor *lineColor) {
        self._lineColor = lineColor;
        return self;
    };
}


- (UIView * (^)(UIColor *))fillColor {
    return ^(UIColor *fillColor) {
        self._fillColor = fillColor;
        return self;
    };
}

-(void)manualDrawing
{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    //延时处理是为了让自动布局生效
    [self performSelector:@selector(drawing) withObject:nil afterDelay:0.001];
}

#pragma mark - 绘制方法

- (void)drawing
{
    if( self._radiusFloat == 0)
    {
        return;
    }
    
    if(self.shapeLayer)
    {
        return;
    }

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self._radiusCorner cornerRadii:CGSizeMake(8, 10)];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = maskPath.CGPath;
    self.shapeLayer.lineWidth = self._lineWidth;
    self.shapeLayer.strokeColor = self._lineColor.CGColor;
    self.shapeLayer.fillColor = self._fillColor.CGColor;
    self.shapeLayer.frame = self.bounds;
    [self setCornerRadius:self.bounds];
    //[self.layer addSublayer:self.shapeLayer];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setCornerRadius:(CGRect)bounds
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPathRef path = [self CYPathCreateWithRoundedRect:bounds];
    shapeLayer.path = path;
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
    //self.layer.mask = shapeLayer;
    //self.clipsToBounds = YES;
}

//切圆角函数
- (CGPathRef)CYPathCreateWithRoundedRect:(CGRect)bounds
{
    BubbleCornerRadius cornerRadius = {16,16,16,4};
    
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + cornerRadius.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadius.topLeft;
     
    const CGFloat bottomLeftCenterX = minX + cornerRadius.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadius.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX - cornerRadius.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadius.bottomRight;
    
    const CGFloat topRightCenterX = maxX - cornerRadius.topRight;
    const CGFloat topRightCenterY = minY + cornerRadius.topRight;
    //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
     
    CGMutablePathRef path = CGPathCreateMutable();
    //顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,cornerRadius.topLeft, M_PI, 3 * M_PI_2, NO);
    //顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadius.topRight, 3 * M_PI_2, 0, NO);
    //底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadius.bottomRight,0, M_PI_2, NO);
    //底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadius.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}

@end
