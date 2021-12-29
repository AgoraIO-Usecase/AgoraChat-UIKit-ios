//
//  EaseAlertView.h
//  EaseIM
//
//  Created by zhangchong on 2020/9/27.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseAlertView : UIView

- (instancetype)initWithTitle:(nullable NSString *)title message:(NSString *)message;

- (void)show;

@end

NS_ASSUME_NONNULL_END
