//
//  UIView+AgoraChatGradient.h
//  EaseChatKit
//
//  Created by zhangchong on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AgoraChatGradient)

@property(nullable, copy) NSArray *az_colors;
@property(nullable, copy) NSArray<NSNumber *> *az_locations;
@property CGPoint az_startPoint;
@property CGPoint az_endPoint;

+ (UIView *_Nullable)az_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)az_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
