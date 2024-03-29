//
//  EaseInputMenuRecordAudioView.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/29.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseInputMenuRecordAudioView.h"
#import "EMAudioRecordUtil.h"
#import "UIImage+EaseUI.h"
#import "EaseHeaders.h"

@interface EaseInputMenuRecordAudioView()

@property (nonatomic, strong) NSString *path;
@property (nonatomic) NSInteger maxTimeSecond;

@property (nonatomic) NSInteger timeLength;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int recordDuration;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *img_left_3;
@property (nonatomic, strong) UIImageView *img_left_2;
@property (nonatomic, strong) UIImageView *img_left_1;

@property (nonatomic, strong) UIImageView *img_right_1;
@property (nonatomic, strong) UIImageView *img_right_2;
@property (nonatomic, strong) UIImageView *img_right_3;

@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UILabel *countLabel;

@end


@implementation EaseInputMenuRecordAudioView

- (instancetype)initWithRecordPath:(NSString *)aPath
{
    self = [super init];
    if (self) {
        _path = aPath;
        _maxTimeSecond = 60;
        self.countLabel = [[UILabel alloc]init];
        self.countView = [[UIView alloc]init];
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.recordButton = [[UIButton alloc] init];
    [self.recordButton setBackgroundColor:[UIColor whiteColor]];
    [self.recordButton setImage:[UIImage easeUIImageNamed:@"grayAudioBtn"] forState:UIControlStateNormal];
    self.recordButton.layer.cornerRadius = 40;
    [self.recordButton addTarget:self action:@selector(recordButtonTouchBegin) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchCancelBegin) forControlEvents:UIControlEventTouchDragOutside];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchCancelCancel) forControlEvents:UIControlEventTouchDragInside];
    [self addSubview:self.recordButton];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchCancelEnd) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(@80);
        make.bottom.equalTo(self).offset(-25);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.text = @"Hold to talk";
    [self addSubview:self.titleLabel];
    [self.titleLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.recordButton.ease_top).offset(-20);
        make.height.equalTo(@20);
    }];
    
    self.countView.hidden = YES;
    [self _setupAnimationViews];
    
}

- (void)_setupAnimationViews
{
    
    [self addSubview:self.countView];
    [self.countView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.recordButton.ease_top).offset(-20);
        make.height.equalTo(@20);
    }];
    
    self.countLabel.text = @"00:00";
    self.countLabel.font = [UIFont systemFontOfSize:14.0];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.countView addSubview:self.countLabel];
    [self.countLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(self.countView);
        make.bottom.lessThanOrEqualTo(self.countView.ease_bottom);
        make.width.equalTo(@50);
    }];
    
    [self _setupImgViews];
    [self _setupImgs];
    
    [self.countView addSubview:_img_left_3];
    [self.countView addSubview:_img_left_2];
    [self.countView addSubview:_img_left_1];
    
    [self.countView addSubview:_img_right_1];
    [self.countView addSubview:_img_right_2];
    [self.countView addSubview:_img_right_3];
    
    self.img_left_1.clipsToBounds = YES;
    [self.img_left_1 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.right.equalTo(self.countLabel.ease_left).equalTo(@-15);
    }];
    [self.img_left_2 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.right.equalTo(self.img_left_1.ease_left).equalTo(@-2);
    }];
    [self.img_left_3 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.right.equalTo(self.img_left_2.ease_left).equalTo(@-2);
    }];
    
    [self.img_right_1 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.right.equalTo(self.countLabel.ease_right).equalTo(@15);
    }];
    [self.img_right_2 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.left.equalTo(self.img_right_1.ease_right).equalTo(@2);
    }];
    [self.img_right_3 Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.countLabel);
        make.left.equalTo(self.img_right_2.ease_right).equalTo(@2);
    }];
    
}

#pragma mark - Private Timer

- (void)_setupImgs
{
    self.img_left_3.image = [UIImage easeUIImageNamed:@"audioSlide03-white"];
    self.img_left_2.image = [UIImage easeUIImageNamed:@"audioSlide02-white"];
    self.img_left_1.image = [UIImage easeUIImageNamed:@"audioSlide01-white"];
    
    self.img_right_1.image = [UIImage easeUIImageNamed:@"audioSlide01-white"];
    self.img_right_2.image = [UIImage easeUIImageNamed:@"audioSlide02-white"];
    self.img_right_3.image = [UIImage easeUIImageNamed:@"audioSlide03-white"];
}

- (void)_setupImgViews
{
    self.img_left_3 = [[UIImageView alloc]init];
    self.img_left_2 = [[UIImageView alloc]init];
    self.img_left_1 = [[UIImageView alloc]init];
    self.img_right_1 = [[UIImageView alloc]init];
    self.img_right_2 = [[UIImageView alloc]init];
    self.img_right_3 = [[UIImageView alloc]init];
}

#pragma mark - Timer

- (void)_updateRecordDuration
{
    self.recordDuration += 1;
    int hour = self.recordDuration / 3600;
    int m = (self.recordDuration - hour * 3600) / 60;
    int s = self.recordDuration - hour * 3600 - m * 60;
    
    if (hour > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        self.countLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        if (s < 10)
            self.countLabel.text = [NSString stringWithFormat:@"00:0%i", s];
        else
            self.countLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
    [self _setupImgAnimation:self.recordDuration];
}

- (void)_setupImgAnimation:(int)duration
{
    int selected = duration % 3;
    switch (selected) {
        case 1:
            [self _setupImgs];
            self.img_left_1.image = [UIImage easeUIImageNamed:@"audioSlide01-blue"];
            self.img_right_1.image = [UIImage easeUIImageNamed:@"audioSlide01-blue"];
            break;
        case 2:
            self.img_left_2.image = [UIImage easeUIImageNamed:@"audioSlide02-blue"];
            self.img_right_2.image = [UIImage easeUIImageNamed:@"audioSlide02-blue"];
            break;
        case 0:
            self.img_left_3.image = [UIImage easeUIImageNamed:@"audioSlide03-blue"];
            self.img_right_3.image = [UIImage easeUIImageNamed:@"audioSlide03-blue"];
            break;
        default:
            break;
    }
}

- (void)_startTimer
{
    [self _stopTimer];
    
    self.recordDuration = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_updateRecordDuration) userInfo:nil repeats:YES];
   
}

- (void)_stopTimer
{
    self.countView.hidden = YES;
    self.countLabel.text = @"00:00";
    [self _setupImgs];
    self.titleLabel.hidden = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Private Record
//Start recording
- (void)_startRecord
{
    self.timeLength = 0;
    [self _startTimer];
    self.titleLabel.hidden = YES;
    self.countView.hidden = NO;
    NSString *recordPath = [self.path stringByAppendingFormat:@"/%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
    __weak typeof(self) weakself = self;
    [[EMAudioRecordUtil sharedHelper] startRecordWithPath:recordPath completion:^(NSError * _Nonnull error) {
        if (error) {
            [weakself recordButtonTouchCancelEnd];
            [EaseAlertController showErrorAlert:error.domain];
        } else {
            [weakself _startTimer];
            weakself.titleLabel.hidden = YES;
            weakself.countView.hidden = NO;
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(chatBarRecordAudioViewStartRecord)]) {
                [weakself.delegate chatBarRecordAudioViewStartRecord];
            }
        }
    }];
}
//Stop recording and send a voice message
- (void)_stopRecord
{
    [self _stopTimer];
    
    __weak typeof(self) weakself = self;
    [[EMAudioRecordUtil sharedHelper] stopRecordWithCompletion:^(NSString * _Nonnull aPath, NSInteger aTimeLength) {
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(chatBarRecordAudioViewStopRecord:timeLength:)]) {
            [weakself.delegate chatBarRecordAudioViewStopRecord:aPath timeLength:aTimeLength];
        }
    }];
}

- (void)_cancelRecord
{
    [self _stopTimer];
    
    [[EMAudioRecordUtil sharedHelper] cancelRecord];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarRecordAudioViewCancelRecord)]) {
        [self.delegate chatBarRecordAudioViewCancelRecord];
    }
}

#pragma mark - Action

- (void)recordButtonTouchBegin
{
    self.titleLabel.text = @"Let go to send";
    [self _startRecord];
}

- (void)recordButtonTouchEnd
{
    [self _stopRecord];
    
    self.titleLabel.text = @"Hold to talk";
    [self.recordButton setImage:[UIImage easeUIImageNamed:@"grayAudioBtn"] forState:UIControlStateNormal];
}

- (void)recordButtonTouchCancelBegin
{
    self.titleLabel.hidden = NO;
    self.countView.hidden = YES;
    self.titleLabel.text = @"Let go to cancel";
    [self.recordButton setImage:[UIImage easeUIImageNamed:@"redAudioBtn"] forState:UIControlStateNormal];
}

- (void)recordButtonTouchCancelCancel
{
    self.titleLabel.hidden = YES;
    self.countView.hidden = NO;
    self.titleLabel.text = @"Let go to send";
    [self.recordButton setImage:[UIImage easeUIImageNamed:@"blueAudioBtn"] forState:UIControlStateNormal];
}

- (void)recordButtonTouchCancelEnd
{
    self.titleLabel.text = @"Hold to talk";
    [self.recordButton setImage:[UIImage easeUIImageNamed:@"grayAudioBtn"] forState:UIControlStateNormal];
    
    [self _cancelRecord];
}

@end
