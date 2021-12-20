//
//  EaseInputMenu.m
//  EaseChat
//
//  Updated by zhangchong on 2020/06/05.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseInputMenu.h"
#import "UIImage+EaseUI.h"
#import "UIColor+EaseUI.h"
#import "EaseTextView.h"
#import "EaseHeaders.h"
#import "UIView+AgoraChatGradient.h"
#import "EaseInputMenu+Private.h"

#define kTextViewMinHeight 36
#define kTextViewMaxHeight 80
#define kIconwidth 36
#define kModuleMargin 4
#define kTopMargin 8

@interface EaseInputMenu()<UITextViewDelegate>

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) EaseTextView *textView;

@property (nonatomic) CGFloat version;

@property (nonatomic) CGFloat previousTextViewContentHeight;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *currentMoreView;
@property (nonatomic, strong) UIButton *conversationToolBarBtn;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UIView *bottomLine;
//@property (nonatomic, strong) UIButton *audioDescBtn;
@property (nonatomic, strong) EaseChatViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray<EaseExtendMenuModel*> *attachmentModelArray;

@end

@implementation EaseInputMenu

- (instancetype)initWithViewModel:(EaseChatViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        _previousTextViewContentHeight = kTextViewMinHeight;
        _viewModel = viewModel;
        [self _setupSubviews];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupAttachment
{
    
}

- (void)_setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
    self.inputView = [[UIView alloc]init];
    self.inputView.backgroundColor = _viewModel.inputMenuBgColor;
    [self addSubview:self.inputView];
    [self.inputView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(0.5);
        make.left.right.width.equalTo(self); 
        make.height.equalTo(@(kIconwidth + kTopMargin * 2));
    }];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.alpha = 0.8;
    [self.inputView addSubview:effectView];
    [effectView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.edges.equalTo(self.inputView);
    }];
    
    self.audioButton = [[UIButton alloc] init];
    [_audioButton setImage:[UIImage easeUIImageNamed:@"audio-unSelected"] forState:UIControlStateNormal];
    [_audioButton setImage:[UIImage easeUIImageNamed:@"character"] forState:UIControlStateSelected];
    [_audioButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:self.audioButton];
    [_audioButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        //make.top.equalTo(self).offset(kTopMargin);
        make.bottom.equalTo(self.inputView).offset(-kTopMargin);
        make.left.equalTo(self).offset(12);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    
    self.conversationToolBarBtn = [[UIButton alloc] init];
    [self.conversationToolBarBtn setImage:[UIImage easeUIImageNamed:@"attachment"] forState:UIControlStateNormal];
    [self.conversationToolBarBtn setImage:[UIImage easeUIImageNamed:@"attachment"] forState:UIControlStateSelected];
    [self.conversationToolBarBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:self.conversationToolBarBtn];
    [self.conversationToolBarBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        //make.top.equalTo(self).offset(kTopMargin);
        make.bottom.equalTo(self.inputView).offset(-kTopMargin);
        make.right.equalTo(self).offset(-12);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    
    self.emojiButton = [[UIButton alloc] init];
    [_emojiButton setBackgroundImage:[UIImage easeUIImageNamed:@"emoji"] forState:UIControlStateNormal];
    [_emojiButton setBackgroundImage:[UIImage easeUIImageNamed:@"character"] forState:UIControlStateSelected];
    [_emojiButton addTarget:self action:@selector(emoticonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:_emojiButton];
    [_emojiButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        //make.top.equalTo(self).offset(kTopMargin);
        make.bottom.equalTo(self.inputView).offset(-kTopMargin);
        make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    
    self.textView = [[EaseTextView alloc] init];
    self.textView.delegate = self;
    [self.textView setTextColor:[UIColor blackColor]];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.textAlignment = NSTextAlignmentLeft;
    
    self.textView.textContainerInset = UIEdgeInsetsMake(9, 13, 9, 21);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.textView.layer.cornerRadius = 17.5;
    [self.inputView addSubview:self.textView];
    [self.textView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(kTopMargin);
        make.height.Ease_equalTo(kTextViewMinHeight);
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleAll) {
            make.left.equalTo(self.audioButton.ease_right).offset(kModuleMargin);
            make.right.equalTo(self.emojiButton.ease_left).offset(-3 * kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoAudio) {
            make.left.equalTo(self).offset(3 * kModuleMargin);
            make.right.equalTo(self.emojiButton.ease_left).offset(-3 * kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoEmoji) {
            make.left.equalTo(self.audioButton.ease_right).offset(kModuleMargin);
            make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoAudioAndEmoji) {
            make.left.equalTo(self).offset(3 * kModuleMargin);
            make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleOnlyText) {
            make.left.equalTo(self).offset(3 * kModuleMargin);
            make.right.equalTo(self).offset(-3 * kModuleMargin);
        }
    }];
    /*
    self.audioDescBtn = [[UIButton alloc]init];
    [self.audioDescBtn setBackgroundColor:[UIColor colorWithHexString:@"#E9E9E9"]];
    [self.audioDescBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.audioDescBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.audioDescBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.audioDescBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.audioDescBtn.layer.cornerRadius = 16;
    [self.textView addSubview:self.audioDescBtn];
    [self.audioDescBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.width.height.equalTo(self.textView);
        make.center.equalTo(self.textView);
    }];
    self.audioDescBtn.hidden = YES;
    [self.audioDescBtn addTarget:self action:@selector(recordButtonTouchBegin) forControlEvents:UIControlEventTouchDown];
    [self.audioDescBtn addTarget:self action:@selector(recordButtonTouchEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.audioDescBtn addTarget:self action:@selector(recordButtonTouchCancelBegin) forControlEvents:UIControlEventTouchDragOutside];
    [self.audioDescBtn addTarget:self action:@selector(recordButtonTouchCancelCancel) forControlEvents:UIControlEventTouchDragInside];
    [self.audioDescBtn addTarget:self action:@selector(recordButtonTouchCancelEnd) forControlEvents:UIControlEventTouchUpOutside];*/
    
    self.bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor clearColor];
    _bottomLine.alpha = 0.1;
    [self addSubview:self.bottomLine];
    [_bottomLine Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textView.ease_bottom).offset(kTopMargin);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
    }];
    
    self.currentMoreView.backgroundColor = [UIColor clearColor];
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    if (!_viewModel.inputMenuBgColor) {
        [self.inputView az_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.currentMoreView) {
        [self.currentMoreView removeFromSuperview];
        [self.bottomLine Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
        }];
    }
    
    self.emojiButton.selected = NO;
    self.conversationToolBarBtn.selected = NO;
    self.audioButton.selected = NO;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarSendMsgAction:)]) {
            [self.delegate inputBarSendMsgAction:self.textView.text];
        }
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //防止输入时在中文后输入英文过长直接中文和英文换行
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    [self _updatetextViewHeight];
    if (self.moreEmoticonView) {
        [self emoticonChangeWithText];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self.textView];
    }
}

#pragma mark - Private

- (NSString *)text
{
    return self.textView.text;
}

- (CGFloat)_gettextViewContontHeight
{
    if (self.version >= 7.0) {
        return ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
    } else {
        return self.textView.contentSize.height;
    }
}

- (void)_updatetextViewHeight
{
    CGFloat height = [self _gettextViewContontHeight];
    if (height < kTextViewMinHeight) {
        height = kTextViewMinHeight;
    }
    if (height > kTextViewMaxHeight) {
        height = kTextViewMaxHeight;
    }
    
    if (height == self.previousTextViewContentHeight) {
        return;
    }
    
    self.previousTextViewContentHeight = height;
    [self.textView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(height);
    }];
    [self.inputView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(kIconwidth + kTopMargin * 2 + height - kTextViewMinHeight);
    }];
}

- (void)_remakeButtonsViewConstraints
{
    if (self.currentMoreView) {
        [self.bottomLine Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.textView.ease_bottom).offset(5);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.currentMoreView.ease_top);
        }];
    } else {
        [self.bottomLine Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.textView.ease_bottom).offset(5);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
        }];
    }
}

- (void)emoticonChangeWithText
{
    if (self.textView.text.length > 0) {
        [self.moreEmoticonView textDidChange:YES];
    } else {
        [self.moreEmoticonView textDidChange:NO];
    }
}

#pragma mark - Action

- (BOOL)_buttonAction:(UIButton *)aButton
{
    BOOL isEditing = NO;
    [self.textView resignFirstResponder];
    if (self.currentMoreView) {
        [self.currentMoreView removeFromSuperview];
        self.currentMoreView = nil;
        [self _remakeButtonsViewConstraints];
    }
    
    if (self.selectedButton != aButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
        self.selectedButton = aButton;
        [aButton setSelected:!aButton.selected];
    } else {
        self.selectedButton = nil;
        if (aButton.isSelected) {
            [self.textView becomeFirstResponder];
            isEditing = YES;
        }
    }
    if (aButton.selected) {
        self.selectedButton = aButton;
    }
    
    return isEditing;
}

//audio
- (void)audioButtonAction:(UIButton *)aButton
{
    if([self _buttonAction:aButton]) {
        return;
    }

    if (aButton.selected) {
        if (self.recordAudioView) {
            self.currentMoreView = self.recordAudioView;
            [self addSubview:self.recordAudioView];
            [self.recordAudioView Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
            }];
            [self _remakeButtonsViewConstraints];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidShowToolbarAction)]) {
                [self.delegate inputBarDidShowToolbarAction];
            }
        }
    }
}

//emotion
- (void)emoticonButtonAction:(UIButton *)aButton
{
    if([self _buttonAction:aButton]) {
        return;
    }
    if (aButton.selected) {
        if (self.moreEmoticonView) {
            self.currentMoreView = self.moreEmoticonView;
            [self emoticonChangeWithText];
            [self addSubview:self.moreEmoticonView];
            [self.moreEmoticonView Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
                make.height.Ease_equalTo(self.moreEmoticonView.viewHeight);
            }];
            [self _remakeButtonsViewConstraints];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidShowToolbarAction)]) {
                [self.delegate inputBarDidShowToolbarAction];
            }
        }
    }
}

//extend
- (void)moreButtonAction:(UIButton *)aButton
{
    if([self _buttonAction:aButton]) {
        //return;
    }
    
    if (self.viewModel.extendMenuViewModel.extendViewStyle == EasePopupView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectExtFuncPopupView)]) {
            [self.delegate didSelectExtFuncPopupView];
        }
        return;
    }
    if (aButton.selected){
        if(self.extendMenuView) {
            self.currentMoreView = self.extendMenuView;
            [self addSubview:self.extendMenuView];
            [self.extendMenuView Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
                make.height.Ease_equalTo(@200);
            }];
            [self _remakeButtonsViewConstraints];
            if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarDidShowToolbarAction)]) {
                [self.delegate inputBarDidShowToolbarAction];
            }
        }
    }
}

@end

@implementation EaseInputMenu (Private)

#pragma mark - Private

- (void)clearInputViewText
{
    self.textView.text = @"";
    if (self.moreEmoticonView) {
        [self emoticonChangeWithText];
    }
    [self _updatetextViewHeight];
}

- (void)inputViewAppendText:(NSString *)aText
{
    if ([aText length] > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, aText];
        [self _updatetextViewHeight];
    }
    if (self.moreEmoticonView) {
        [self emoticonChangeWithText];
    }
}

- (BOOL)deleteTailText
{
    if ([self.textView.text length] > 0) {
        NSRange range = [self.textView.text rangeOfComposedCharacterSequenceAtIndex:self.textView.text.length-1];
        self.textView.text = [self.textView.text substringToIndex:range.location];
    }
    [self _updatetextViewHeight];
    if ([self.textView.text length] > 0) {
        return YES;
    }
    return NO;
}

- (void)clearMoreViewAndSelectedButton
{
    if (self.currentMoreView) {
        [self.currentMoreView removeFromSuperview];
        self.currentMoreView = nil;
        [self _remakeButtonsViewConstraints];
    }
    
    if (self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = nil;
    }
}

@end
