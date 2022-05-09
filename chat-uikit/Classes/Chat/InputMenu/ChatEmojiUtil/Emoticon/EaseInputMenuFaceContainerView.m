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
#import "chat_uikit-Swift.h"
#import "chat-uikit-Bridging-Header.h"

@import Stipop;
@import GiphyUISDK;


#define kCoverViewWidth 100.0
#define kCoverViewHeight 32.0
#define kEmojiButtonSize 20.0
#define KContentViewHeight 255.0

@interface EaseInputMenuFaceContainerView ()<EaseInputMenuStripopViewDelegate>

@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *strikerButton;
@property (nonatomic, strong) UIButton *giphyButton;
@property (nonatomic, strong) UIView *selectedBgView;
@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *strikerView;
@property (nonatomic, strong) UIView *giphyView;

@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation EaseInputMenuFaceContainerView
- (instancetype)initWithViewHeight:(CGFloat)viewHeight {
    self = [super init];
    if (self) {
        self.viewHeight = viewHeight;
        self.selectedIndex = 0;
        [self placeAndLayoutSubviews];
        [self updateUI];

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
        make.height.equalTo(@(KContentViewHeight));
        make.bottom.equalTo(self);
    }];
        
}

#pragma mark EaseInputMenuStripopViewDelegate
- (void)selectedEmojiWithUrlStringWithUrlString:(NSString *)urlString urlType:(NSString *)urlType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedStikerWithUrlString:fileType:)]) {
        [self.delegate selectedStikerWithUrlString:urlString fileType:urlType];
    }
}

#pragma mark action
- (void)resetContainerView {
    self.selectedIndex = 0;
    [self updateUI];
}

- (void)emojiButtonAction {
    self.selectedIndex = 0;
    [self updateUI];
}

- (void)strikerButtonAction {
    self.selectedIndex = 1;
    [self updateUI];
}

- (void)giphyButtonAction {

    self.selectedIndex = 2;
    [self updateUI];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGiphyViewController)]) {
        [self.delegate showGiphyViewController];
    }
    
}

- (void)updateUI {
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView setContentOffset:CGPointMake(EaseKitScreenWidth * self.selectedIndex, 0)];
        [self.selectedBgView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.width.equalTo(@(kCoverViewWidth));
            make.height.equalTo(@(kCoverViewHeight));
            if (self.selectedIndex == 0) {
                make.centerX.equalTo(self.emojiButton);
            }else if(self.selectedIndex == 1) {
                make.centerX.equalTo(self.strikerButton);
            }else {
                make.centerX.equalTo(self.giphyButton);
            }
            make.centerY.equalTo(_segmentView);
        }];

    }];
    
    NSString *suffixName = @"_selected";
    
    NSMutableString *emojiName =  [NSMutableString stringWithString:@"face_emoji"];
    NSMutableString *stikerName = [NSMutableString stringWithString:@"face_sticker"];
    NSMutableString *giphyName =  [NSMutableString stringWithString:@"face_giphy"];

    if (self.selectedIndex == 0) {
        [emojiName appendString:suffixName];
    }else if(self.selectedIndex == 1){
        [stikerName appendString:suffixName];
    }else {
        [giphyName appendString:suffixName];
    }
    

    [_emojiButton setImage:[UIImage easeUIImageNamed:emojiName] forState:UIControlStateNormal];
    [_strikerButton setImage:[UIImage easeUIImageNamed:stikerName] forState:UIControlStateNormal];
    [_giphyButton setImage:[UIImage easeUIImageNamed:giphyName] forState:UIControlStateNormal];

    
}

#pragma mark getter and setter
- (UIButton *)emojiButton {
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc]init];
        [_emojiButton setImage:[UIImage easeUIImageNamed:@"face_emoji"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(emojiButtonAction) forControlEvents:UIControlEventTouchUpInside];
        }
    return _emojiButton;
}


- (UIButton *)strikerButton {
    if (_strikerButton == nil) {
        _strikerButton = [[UIButton alloc]init];
        [_strikerButton setImage:[UIImage easeUIImageNamed:@"face_sticker"] forState:UIControlStateNormal];
        [_strikerButton addTarget:self action:@selector(strikerButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _strikerButton;
}

- (UIButton *)giphyButton {
    if (_giphyButton == nil) {
        _giphyButton = [[UIButton alloc]init];
        [_giphyButton setImage:[UIImage easeUIImageNamed:@"face_giphy"] forState:UIControlStateNormal];
        [_giphyButton addTarget:self action:@selector(giphyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giphyButton;
}


- (UIView *)selectedBgView {
    if (_selectedBgView == nil) {
        _selectedBgView = [[UIView alloc] init];
        _selectedBgView.backgroundColor = [UIColor colorWithDisplayP3Red:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:0.4];

        _selectedBgView.layer.cornerRadius = kCoverViewHeight * 0.5;
    }
    return _selectedBgView;
}


- (UIView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[UIView alloc] init];
        _segmentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.02];
        [_segmentView addSubview:self.selectedBgView];
        [_segmentView addSubview:self.emojiButton];
        [_segmentView addSubview:self.strikerButton];
        [_segmentView addSubview:self.giphyButton];
        
        [self.selectedBgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.width.equalTo(@(kCoverViewWidth));
            make.height.equalTo(@(kCoverViewHeight));
            make.centerX.equalTo(self.emojiButton);
            make.centerY.equalTo(_segmentView);
        }];
        
        CGFloat emojiWidth = EaseKitScreenWidth / 3.0;
        
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
        
        [self.giphyButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
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
    }
    return _moreEmoticonView;
}

- (UIView *)strikerView {
    if (_strikerView == nil) {
        _strikerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, EaseKitScreenWidth, 200)];
        _strikerView.backgroundColor = UIColor.blueColor;
        [_strikerView addSubview:self.stripopView];
        [self.stripopView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.edges.equalTo(_strikerView);
        }];

    }
    return _strikerView;
}

- (UIView *)giphyView {
    if (_giphyView == nil) {
        _giphyView = [[UIView alloc] init];
    }
    return _giphyView;
}

- (UIScrollView *)contentView {
    if (_contentView == nil) {
        
        _contentView = [[UIScrollView alloc] init];
        _contentView.scrollEnabled = NO;
        _contentView.bounces = NO;
        _contentView.alwaysBounceHorizontal = YES;
        _contentView.contentSize = CGSizeMake(EaseKitScreenWidth, KContentViewHeight);
        _contentView.contentOffset = CGPointMake(0, 0);
            
        [_contentView addSubview:self.moreEmoticonView];
        [_contentView addSubview:self.stripopView];
        [_contentView addSubview:self.giphyView];

        [self.moreEmoticonView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(_contentView);
            make.width.equalTo(@(EaseKitScreenWidth));
            make.height.equalTo(@(KContentViewHeight));
            make.bottom.equalTo(_contentView);
        }];

        [self.stripopView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(self.moreEmoticonView.ease_right);
            make.size.equalTo(self.moreEmoticonView);
            make.bottom.equalTo(_contentView);
        }];

        [self.giphyView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_contentView);
            make.left.equalTo(self.stripopView.ease_right);
            make.right.equalTo(_contentView);
            make.size.equalTo(self.moreEmoticonView);
            make.bottom.equalTo(_contentView);
        }];
    }
    return _contentView;
}



- (EaseInputMenuStripopView *)stripopView {
    if (_stripopView == nil) {
        _stripopView = [[EaseInputMenuStripopView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, KContentViewHeight)];
        _stripopView.delegate = self;
    }
    return _stripopView;
}


@end

#undef kCoverViewWidth
#undef kCoverViewHeight
#undef kEmojiButtonSize
#undef KContentViewHeight


