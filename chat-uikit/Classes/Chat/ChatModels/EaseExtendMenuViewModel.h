//
//  EaseExtendMenuViewModel.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/12/7.
//  Copyright © 2020 djp. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  inputMenu "+" extend view style
 */
typedef NS_ENUM(NSInteger, EaseExtendViewStyle) {
    EaseInputMenuExtFuncView = 1,  //inputMenu view
    EasePopupView,                //viewcontroller popup view
};

NS_ASSUME_NONNULL_BEGIN

@interface EaseExtendMenuViewModel : NSObject

// Icon background color
@property (nonatomic, strong) UIColor *iconBgColor;

// View background color
@property (nonatomic, strong) UIColor *viewBgColor;

// Font color
@property (nonatomic, strong) UIColor *fontColor;

// Font size
@property (nonatomic, assign) CGFloat fontSize;

// View size
@property (nonatomic, assign) CGSize collectionViewSize;

// Extend view style
@property (nonatomic) EaseExtendViewStyle extendViewStyle;

@end

NS_ASSUME_NONNULL_END
