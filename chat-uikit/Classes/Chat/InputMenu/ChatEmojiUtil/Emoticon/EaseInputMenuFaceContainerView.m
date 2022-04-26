//
//  EaseInputMenuFaceContainerView.m
//  chat-uikit
//
//  Created by liu001 on 2022/4/25.
//

#import "EaseInputMenuFaceContainerView.h"
#import "UIImage+EaseUI.h"
#import "EaseHeaders.h"
#import "EaseInputMenuEmoticonView.h"


#define kCoverViewWidth 100.0
#define kCoverViewHeight 32.0
#define kEmojiButtonSize 20.0
#define KContentViewHeight 255.0

@interface EaseInputMenuFaceContainerView ()

@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *strikerButton;
@property (nonatomic, strong) UIButton *tenorButton;
@property (nonatomic, strong) UIView *selectedBgView;
@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIView *strikerView;
@property (nonatomic, strong) UIView *tenorView;

@property (nonatomic, assign) CGFloat viewHeight;

@end

@implementation EaseInputMenuFaceContainerView
- (instancetype)initWithViewHeight:(CGFloat)viewHeight {
    self = [super init];
    if (self) {
        self.viewHeight = viewHeight;
        [self placeAndLayoutSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self placeAndLayoutSubviews];
    }
    return self;
}

- (void)placeAndLayoutSubviews {

    [self addSubview:self.segmentView];
    [self addSubview:self.contentView];

    [self.segmentView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(2.0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(44.0));
    }];

    [self.contentView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.segmentView.ease_bottom).offset(2.0);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
//    [self addSubview:self.segmentView];
//    [self addSubview:self.moreEmoticonView];
//
//    [self.segmentView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(self).offset(2.0);
//        make.left.right.equalTo(self);
//        make.height.equalTo(@(44.0));
//    }];
//
//    [self.moreEmoticonView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(self.segmentView.ease_bottom).offset(2.0);
//        make.left.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];
    
}

#pragma mark action
- (void)emojiButtonAction {
    NSLog(@"%s",__func__);
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setContentOffset:CGPointMake(0, 0)];
    //    [self.selectedBgView Ease_updateConstraints:^(EaseConstraintMaker *make) {
    //        make.centerX.equalTo(self.emojiButton);
    //    }];

    }];
}

- (void)strikerButtonAction {
    NSLog(@"%s",__func__);
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setContentOffset:CGPointMake(EaseKitScreenWidth, 0)];
    //    [self.selectedBgView Ease_updateConstraints:^(EaseConstraintMaker *make) {
    //        make.centerX.equalTo(self.strikerButton);
    //    }];

    }];
}

- (void)tenorButtonAction {
    NSLog(@"%s",__func__);
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setContentOffset:CGPointMake(EaseKitScreenWidth * 2, 0)];
    //    [self.selectedBgView Ease_updateConstraints:^(EaseConstraintMaker *make) {
    //        make.centerX.equalTo(self.tenorButton);
    //    }];

    }];
}

#pragma mark getter and setter
- (UIButton *)emojiButton {
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc]init];
        [_emojiButton setImage:[UIImage easeUIImageNamed:@"face_emoji"] forState:UIControlStateNormal];
        [_emojiButton setImage:[UIImage easeUIImageNamed:@"face_emoji_selected"] forState:UIControlStateSelected];
        [_emojiButton addTarget:self action:@selector(emojiButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
    return _emojiButton;
}


- (UIButton *)strikerButton {
    if (_strikerButton == nil) {
        _strikerButton = [[UIButton alloc]init];
        [_strikerButton setImage:[UIImage easeUIImageNamed:@"face_sticker"] forState:UIControlStateNormal];
        [_strikerButton setImage:[UIImage easeUIImageNamed:@"face_sticker_selected"] forState:UIControlStateSelected];
        [_strikerButton addTarget:self action:@selector(strikerButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _strikerButton;
}

- (UIButton *)tenorButton {
    if (_tenorButton == nil) {
        _tenorButton = [[UIButton alloc]init];
        [_tenorButton setImage:[UIImage easeUIImageNamed:@"face_tenor"] forState:UIControlStateNormal];
        [_tenorButton setImage:[UIImage easeUIImageNamed:@"face_tenor_selected"] forState:UIControlStateSelected];
        [_tenorButton addTarget:self action:@selector(tenorButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tenorButton;
}


//#D8D8D866

- (UIView *)selectedBgView {
    if (_selectedBgView == nil) {
        _selectedBgView = [[UIView alloc] init];
        _selectedBgView.backgroundColor = UIColor.grayColor;
        _selectedBgView.layer.cornerRadius = kCoverViewHeight * 0.5;
    }
    return _selectedBgView;
}


- (UIView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UIView alloc] init];
        
        [_segmentView addSubview:self.selectedBgView];
        [_segmentView addSubview:self.emojiButton];
        [_segmentView addSubview:self.strikerButton];
        [_segmentView addSubview:self.tenorButton];
        
            
        [self.selectedBgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.width.equalTo(@(kCoverViewWidth));
            make.height.equalTo(@(kCoverViewHeight));
            make.centerX.equalTo(self.emojiButton);
            make.centerY.equalTo(_segmentView);
        }];
        
        CGFloat emojiWidth = EaseKitScreenWidth / 3.0;
        NSLog(@"%s width:%@",__func__,@(emojiWidth));
        
        [self.emojiButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_segmentView);
            make.left.equalTo(_segmentView);
            make.width.equalTo(@(emojiWidth));
            make.height.equalTo(_segmentView);
        }];

        [self.strikerButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.centerY.equalTo(self.emojiButton);
            make.left.equalTo(self.emojiButton.ease_right);
            make.width.equalTo(@(emojiWidth));
            make.height.equalTo(_segmentView);
        }];
        
        [self.tenorButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.centerY.equalTo(self.emojiButton);
            make.left.equalTo(self.strikerButton.ease_right);
            make.width.equalTo(@(emojiWidth));
            make.height.equalTo(_segmentView);
        }];
    }
    return _segmentView;
}

- (EaseInputMenuEmoticonView *)moreEmoticonView {
    if (_moreEmoticonView == nil) {
        _moreEmoticonView = [[EaseInputMenuEmoticonView alloc] initWithViewHeight:255];
        _moreEmoticonView.backgroundColor = UIColor.redColor;
    }
    return _moreEmoticonView;
}

- (UIView *)strikerView {
    if (_strikerView == nil) {
        _strikerView = [[UIView alloc] init];
        _strikerView.backgroundColor = UIColor.blueColor;
    }
    return _strikerView;
}

- (UIView *)tenorView {
    if (_tenorView == nil) {
        _tenorView = [[UIView alloc] init];
        _tenorView.backgroundColor = UIColor.redColor;
    }
    return _tenorView;
}

- (UIScrollView *)contentView {
    if (_contentView == nil) {
        
        _contentView = [[UIScrollView alloc] init];
        _contentView.scrollEnabled = YES;
        _contentView.bounces = YES;
        _contentView.alwaysBounceHorizontal = YES;
        _contentView.backgroundColor = UIColor.purpleColor;
        _contentView.contentSize = CGSizeMake(EaseKitScreenWidth, KContentViewHeight);
        _contentView.contentOffset = CGPointMake(0, 0);
    
        
        [_contentView addSubview:self.moreEmoticonView];
        [_contentView addSubview:self.strikerView];
        [_contentView addSubview:self.tenorView];

        [self.moreEmoticonView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(_contentView);
            make.width.equalTo(@(EaseKitScreenWidth));
            make.bottom.equalTo(_contentView);
        }];
        
        [self.strikerView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(self.moreEmoticonView.ease_right);
            make.width.equalTo(@(EaseKitScreenWidth));
            make.bottom.equalTo(_contentView);
        }];
        
        [self.tenorView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(self.strikerView.ease_right);
            make.width.equalTo(@(EaseKitScreenWidth));
            make.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView);
        }];
        
    }
    return _contentView;
}

@end

#undef kCoverViewWidth
#undef kCoverViewHeight
#undef kEmojiButtonSize
#undef KContentViewHeight


