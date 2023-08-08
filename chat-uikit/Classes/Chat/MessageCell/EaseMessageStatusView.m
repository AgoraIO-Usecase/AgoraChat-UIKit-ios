//
//  EaseMessageStatusView.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/25.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseMessageStatusView.h"
#import "EaseLoadingCALayer.h"
#import "EaseOneLoadingAnimationView.h"
#import "UIImage+EaseUI.h"

@interface EaseMessageStatusView()

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *failButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) IBOutlet EaseOneLoadingAnimationView *loadingView;

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, assign) CGFloat loadingAngle;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation EaseMessageStatusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
    }
    
    return self;
}

#pragma mark - Subviews

- (UIImageView *)statusImageView
{
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc]init];
        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImageView;
}

- (UIButton *)failButton
{
    if (_failButton == nil) {
        _failButton = [[UIButton alloc] init];
        [_failButton setImage:[UIImage easeUIImageNamed:@"iconSendFail"] forState:UIControlStateNormal];
        [_failButton addTarget:self action:@selector(failButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _failButton;
}

- (UIView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[EaseOneLoadingAnimationView alloc]initWithRadius:9.0];
        //_loadingView.backgroundColor = [UIColor lightGrayColor];
    }
    return _loadingView;
}

- (UIImageView *)loadingImageView {
    if (_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.contentMode = UIViewContentModeScaleAspectFill;
        _loadingImageView.image = [UIImage easeUIImageNamed:@"sending"];
        _loadingImageView.hidden = YES;
    }
    return _loadingImageView;
}

#pragma mark - Public

- (void)setSenderStatus:(AgoraChatMessageStatus)aStatus
            isReadAcked:(BOOL)aIsReadAcked
         isDeliverAcked:(BOOL)aIsDeliverAcked
{
    if (aStatus == AgoraChatMessageStatusDelivering) {
        self.hidden = NO;
        [_statusImageView removeFromSuperview];
        [_failButton removeFromSuperview];
        
//        [self addSubview:self.loadingImageView];
//        [self.loadingImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//            make.edges.equalTo(self);
//            make.width.height.equalTo(@20);
//        }];
//        self.loadingImageView.hidden = NO;
//        [self startAnimation];
//
        [self addSubview:self.loadingView];
        [self.loadingView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.equalTo(@20);
        }];
        [self.loadingView startAnimation];
    
    } else if (aStatus == AgoraChatMessageStatusFailed || aStatus == AgoraChatMessageStatusPending) {
        self.hidden = NO;
        [_statusImageView removeFromSuperview];
    
//        [self.loadingImageView.layer removeAllAnimations];
//        self.loadingImageView.hidden = YES;
//
        _loadingView.hidden = YES;
        [_loadingView stopAnimate];
        
        [self addSubview:self.failButton];
        [self.failButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.height.equalTo(@20);
        }];
    } else if (aStatus == AgoraChatMessageStatusSucceed) {
        self.hidden = NO;
        [_failButton removeFromSuperview];

        _loadingView.hidden = YES;
        [_loadingView stopAnimate];
        
//        self.loadingImageView.hidden = YES;
//        [self.loadingImageView.layer removeAllAnimations];
//
        [self.statusImageView setImage:aIsReadAcked ? [UIImage easeUIImageNamed:@"readAck"] : aIsDeliverAcked ? [UIImage easeUIImageNamed:@"deliverAck"] : [UIImage easeUIImageNamed:@"sent"]];
        [self addSubview:self.statusImageView];
        [self.statusImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    } else {
        self.hidden = YES;
        [_statusImageView removeFromSuperview];
        [_failButton removeFromSuperview];
        
//        [self.loadingImageView.layer removeAllAnimations];
//        self.loadingImageView.hidden = YES;
        _loadingView.hidden = YES;
        [_loadingView stopAnimate];
    }
}

#pragma mark - Action

- (void)startAnimation {
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.loadingAngle * (M_PI /180.0f));

    UIViewAnimationOptions animationOptions = UIViewAnimationCurveLinear | UIViewAnimationOptionRepeat;
    [UIView animateWithDuration:0.05 delay:0 options:animationOptions animations:^{
        self.loadingImageView.transform = endAngle;
    } completion:nil];
    self.loadingAngle += 15;
}

- (void)failButtonAction
{
    if (self.resendCompletion) {
        self.resendCompletion();
    }
}


@end
