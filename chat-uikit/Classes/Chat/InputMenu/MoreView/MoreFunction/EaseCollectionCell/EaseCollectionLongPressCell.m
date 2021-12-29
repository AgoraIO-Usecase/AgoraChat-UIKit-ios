//
//  EaseCollectionLongPressCell.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/12/11.
//  Copyright © 2020 djp. All rights reserved.
//

#import "EaseCollectionLongPressCell.h"

@implementation EaseCollectionLongPressCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellLonger = frame.size.width;
        [self setupToolbar];
    }
    return self;
}

- (void)setupToolbar {
    [super setupToolbar];
    self.toolBtn = [[UIButton alloc]init];
    self.toolBtn.layer.masksToBounds = YES;
    self.toolBtn.layer.cornerRadius = 8;
    self.toolBtn.userInteractionEnabled = NO;
    self.toolBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.toolBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [self.contentView addSubview:self.toolBtn];
    [self.toolBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(4);
        make.centerX.equalTo(self.contentView.ease_centerX);
        make.width.height.Ease_equalTo(30);
    }];
    
    self.toolLabel = [[UILabel alloc]init];
    self.toolLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.toolLabel];
    [self.toolLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.toolBtn.ease_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
}

- (void)personalizeToolbar:(EaseExtendMenuModel*)menuItemModel menuViewMode:(EaseExtMenuViewModel*)menuViewModel
{
    [super personalizeToolbar:menuItemModel menuViewMode:menuViewModel];
}

@end
