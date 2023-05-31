//
//  EMMsgURLPreviewBubbleView.m
//  EaseIMKit
//
//  Created by 冯钊 on 2023/5/24.
//

#import "EMMsgURLPreviewBubbleView.h"
#import "EaseURLPreviewManager.h"
#import "UIImageView+EaseWebCache.h"
#import "Easeonry.h"
#import "EaseEmojiHelper.h"
#import "UIImage+EaseUI.h"

@interface EMMsgURLPreviewBubbleView ()
{
    EaseChatViewModel *_viewModel;
}

@property (nonatomic, strong) CAGradientLayer *textBgLayer;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation EMMsgURLPreviewBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textBgLayer.frame = CGRectMake(0, 0, self.bounds.size.width, _contentView.isHidden ? self.bounds.size.height : _imageView.frame.origin.y);
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    [maskPath moveToPoint:CGPointMake(16, h)];
    [maskPath addLineToPoint:CGPointMake(w - 4, h)];
    [maskPath addQuadCurveToPoint:CGPointMake(w, h - 4) controlPoint:CGPointMake(w, h)];
    [maskPath addLineToPoint:CGPointMake(w, 16)];
    [maskPath addQuadCurveToPoint:CGPointMake(w - 16, 0) controlPoint:CGPointMake(w, 0)];
    [maskPath addLineToPoint:CGPointMake(16, 0)];
    [maskPath addQuadCurveToPoint:CGPointMake(0, 16) controlPoint:CGPointMake(0, 0)];
    [maskPath addLineToPoint:CGPointMake(0, h - 16)];
    [maskPath addQuadCurveToPoint:CGPointMake(16, h) controlPoint:CGPointMake(0, h)];
    _shapeLayer.path = maskPath.CGPath;
}

#pragma mark - Subviews
- (void)_setupSubviews
{
    self.backgroundColor = [UIColor colorWithRed:0.92 green:0.951 blue:1 alpha:1];
    
    _textBgLayer = [CAGradientLayer layer];
    _textBgLayer.startPoint = CGPointZero;
    _textBgLayer.endPoint = CGPointMake(1, 1);
    _textBgLayer.locations = @[@0, @1];
    if (self.direction == AgoraChatMessageDirectionSend) {
        _textBgLayer.colors = @[
            (id)[UIColor colorWithRed:0.18 green:0.282 blue:0.98 alpha:1].CGColor,
            (id)[UIColor colorWithRed:0.573 green:0.188 blue:0.894 alpha:1].CGColor
        ];
    } else {
        _textBgLayer.colors = @[
            (id)[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1].CGColor,
            (id)[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1].CGColor
        ];
    }
    [self.layer addSublayer:_textBgLayer];

    _textView = [[UITextView alloc] init];
    _textView.font = _viewModel.textMessaegFont;
    _textView.backgroundColor = UIColor.clearColor;
    _textView.scrollEnabled = NO;
    _textView.contentInset = UIEdgeInsetsZero;
    if (self.direction == AgoraChatMessageDirectionSend) {
        _textView.textColor = _viewModel.sentFontColor;
    } else {
        _textView.textColor = _viewModel.reveivedFontColor;
    }
    if (self.direction == AgoraChatMessageDirectionSend) {
        _textView.linkTextAttributes = @{
            NSForegroundColorAttributeName: _textView.textColor
        };
    }
    [self addSubview:_textView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = UIColor.whiteColor;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.937 blue:1 alpha:1];
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColor.blackColor;
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    _titleLabel.numberOfLines = 1;
    [_contentView addSubview:_titleLabel];
    
    [_textView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.edges.equalTo(@(UIEdgeInsetsMake(8, 12, 8, 12)));
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = UIColor.blackColor;
    _descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [_contentView addSubview:_descLabel];
    
    _shapeLayer = [CAShapeLayer layer];
    self.layer.mask = _shapeLayer;
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    self.image = nil;
    AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)model.message.body;
    NSString *text = [EaseEmojiHelper convertEmoji:body.text];
    NSMutableAttributedString *attaStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *checkArr = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    if (checkArr.count == 1) {
        NSTextCheckingResult *result = checkArr.firstObject;
        NSString *urlStr = result.URL.absoluteString;
        NSRange range = [text rangeOfString:urlStr options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            NSURL *url = [NSURL URLWithString:urlStr];
            [attaStr setAttributes:@{
                NSLinkAttributeName : url,
                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                NSUnderlineColorAttributeName: self.direction == AgoraChatMessageDirectionSend ? _viewModel.sentFontColor : self.tintColor
            } range:NSMakeRange(range.location, urlStr.length)];
            EaseURLPreviewResult *result = [EaseURLPreviewManager.shared resultWithURL:url];
            if (result && result.state != EaseURLPreviewStateFaild) {
                [self updateLayoutWithURLPreview: result];
            } else {
                [self updateLayoutWithoutURLPreview];
            }
        }
    } else {
        [self updateLayoutWithoutURLPreview];
    }
    
    [attaStr addAttributes:@{
        NSForegroundColorAttributeName: self.direction == AgoraChatMessageDirectionSend ? _viewModel.sentFontColor : _viewModel.reveivedFontColor,
        NSFontAttributeName: _viewModel.textMessaegFont,
    } range:NSMakeRange(0, attaStr.length)];
    
    _textView.attributedText = attaStr;
}

- (void)updateLayoutWithURLPreview:(EaseURLPreviewResult *)result
{
    [_textView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@8);
        make.right.equalTo(@-12);
        make.width.equalTo(@253);
    }];
    if (result.state == EaseURLPreviewStateSuccess) {
        _imageView.hidden = NO;
        _titleLabel.hidden = NO;
        _contentView.hidden = NO;
        _descLabel.hidden = result.desc.length <= 0;
        
        [_imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_textView.ease_bottom).offset(8);
            make.left.right.equalTo(self);
            make.height.equalTo(@0);
        }];
        [_contentView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_imageView.ease_bottom);
            make.left.right.equalTo(_imageView);
            make.bottom.equalTo(self);
        }];
        [_titleLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@12);
            make.right.equalTo(@-12);
            if (result.desc.length <= 0) {
                make.bottom.equalTo(@-8);
            }
        }];
        if (result.desc.length > 0) {
            [_descLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(_titleLabel.ease_bottom).offset(4);
                make.left.equalTo(@12);
                make.bottom.equalTo(@-8);
                make.right.equalTo(@-12);
            }];
        } else {
            [_descLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
        }
        
        [_imageView Ease_setImageWithURL:[NSURL URLWithString:result.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, EaseImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error || image.size.width == 0 || image.size.height == 0) {
                return;
            }
            [_imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(_textView.ease_bottom).offset(8);
                make.left.right.equalTo(self);
                make.height.equalTo(@(253 / image.size.width * image.size.height));
            }];
            if (_delegate && [_delegate respondsToSelector:@selector(URLPreviewBubbleViewNeedLayout:)]) {
                [_delegate URLPreviewBubbleViewNeedLayout:self];
            }
        }];
        _titleLabel.text = result.title;
        _descLabel.text = result.desc;
    } else {
        _imageView.hidden = YES;
        _contentView.hidden = NO;
        _titleLabel.hidden = NO;
        _descLabel.hidden = YES;
        
        [_imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
        [_descLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
        
        [_titleLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(_textView.ease_bottom).offset(8);
            make.left.equalTo(@12);
            make.right.equalTo(@-12);
            make.bottom.equalTo(@-8);
        }];
    }
}

- (void)updateLayoutWithoutURLPreview
{
    _imageView.hidden = YES;
    _contentView.hidden = YES;
    _titleLabel.hidden = YES;
    _descLabel.hidden = YES;
    
    [_textView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@8);
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-8);
    }];
    [_contentView Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
    [_imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
    [_titleLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
    [_descLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
}

@end
