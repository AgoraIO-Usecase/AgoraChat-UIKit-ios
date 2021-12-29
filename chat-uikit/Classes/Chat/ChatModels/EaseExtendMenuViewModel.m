//
//  EaseExtendMenuViewModel.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/12/7.
//  Copyright © 2020 djp. All rights reserved.
//

#import "EaseExtendMenuViewModel.h"
#import "UIColor+EaseUI.h"

@implementation EaseExtendMenuViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _iconBgColor = [UIColor whiteColor];
        _viewBgColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _fontColor = [UIColor colorWithHexString:@"#999999"];
        _fontSize = 12;
        _collectionViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
        _extendViewStyle = EasePopupView;
    }
    return self;
}

- (void)setIconBgColor:(UIColor *)iconBgColor
{
    if (iconBgColor) {
        _iconBgColor = iconBgColor;
    }
}

- (void)setViewBgColor:(UIColor *)viewBgColor
{
    if (viewBgColor) {
        _viewBgColor = viewBgColor;
    }
}

- (void)setFontColor:(UIColor *)fontColor
{
    if (fontColor) {
        _fontColor = fontColor;
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (fontSize) {
        _fontSize = fontSize;
    }
}

- (void)setCollectionViewSize:(CGSize)collectionViewSize
{
    _collectionViewSize = collectionViewSize;
}

@end
