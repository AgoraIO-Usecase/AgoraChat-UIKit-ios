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
#import "EaseInputQuoteView.h"
#import "EaseDefines.h"
#import "AgoraChatMessage+EaseUIExt.h"
#import "EaseEmojiHelper.h"

#define kTextViewMinHeight 36
#define kTextViewMaxHeight 80
#define kIconwidth 36
#define kModuleMargin 4
#define kTopMargin 8


@interface EaseInputMenu()<UITextViewDelegate, EaseInputQuoteViewDelegate>

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) EaseTextView *textView;
@property (nonatomic, strong) NSMutableArray<EaseExtendMenuModel*> *attachmentModelArray;

@property (nonatomic) CGFloat version;

@property (nonatomic) CGFloat previousTextViewContentHeight;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *currentMoreView;
@property (nonatomic, strong) UIButton *conversationToolBarBtn;//更多
@property (nonatomic, strong) UIButton *emojiButton;//表情
@property (nonatomic, strong) UIButton *audioButton;//语音
@property (nonatomic, strong) UIView *bottomLine;//下划线
//@property (nonatomic, strong) UIButton *audioDescBtn;
@property (nonatomic, strong) EaseChatViewModel *viewModel;
@property (nonatomic) UILabel *replyTo;
@property (nonatomic, strong) UIView *quoteView;
@property (nonatomic, strong) UILabel *quoteLabel;
@property (nonatomic, strong) UIButton *quoteDeleteButton;
@property (nonatomic, strong) UIImageView *quoteImageView;
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

- (void)_setupSubviews
{
    self.backgroundColor = _viewModel.chatViewBgColor;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.alpha = 0.8;
    [self addSubview:effectView];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    line.alpha = 0.1;
    [self addSubview:line];
    [line Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    _quoteView = [[UIView alloc] init];
    _quoteView.hidden = YES;
    [self addSubview:_quoteView];
    _quoteView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
    [_quoteView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(line);
        make.height.equalTo(@0);
    }];
    
    _quoteDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quoteDeleteButton setBackgroundImage:[UIImage easeUIImageNamed:@"quote_delete"] forState:UIControlStateNormal];
    [_quoteDeleteButton addTarget:self action:@selector(deleteQuoteAction) forControlEvents:UIControlEventTouchUpInside];
    [_quoteView addSubview:_quoteDeleteButton];
    [_quoteDeleteButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.Ease_equalTo(12);
        make.top.equalTo(self).offset(8);
        make.size.Ease_equalTo(13);
    }];
    _replyTo = [[UILabel alloc] init];
    [_quoteView addSubview:_replyTo];
    [_replyTo Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.quoteDeleteButton.ease_right).offset(4);
        make.top.equalTo(self).offset(6);
        make.right.equalTo(self).offset(-12);
        make.height.Ease_equalTo(18);
    }];
    _quoteLabel = [[UILabel alloc] init];
    _quoteLabel.numberOfLines = 0;
    _quoteLabel.font = [UIFont systemFontOfSize:15];
    _quoteLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [_quoteView addSubview:_quoteLabel];
    [_quoteLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(_quoteDeleteButton);
        make.top.equalTo(self.replyTo).offset(4);
        make.bottom.equalTo(@-8);
        make.right.equalTo(@(-kIconwidth-12));
        make.height.lessThanOrEqualTo(@16);
    }];
    
    _quoteImageView = [[UIImageView alloc] init];
    _quoteImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _quoteImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_quoteView addSubview:_quoteImageView];
//    _quoteImageView.hidden = YES;
    [_quoteImageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.width.height.Ease_equalTo(24);
        make.centerY.equalTo(self.quoteView);
        make.right.equalTo(self).offset(-12);
    }];
    
    self.audioButton = [[UIButton alloc] init];
    [_audioButton setBackgroundImage:[UIImage easeUIImageNamed:@"audio-unSelected"] forState:UIControlStateNormal];
    [_audioButton setBackgroundImage:[UIImage easeUIImageNamed:@"character"] forState:UIControlStateSelected];
    [_audioButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.audioButton];
//    [_audioButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.top.equalTo(_quoteView.ease_bottom).offset(10);
//        make.left.equalTo(self).offset(16);
//        make.width.Ease_equalTo(@16);
//        make.height.Ease_equalTo(kIconwidth);
//    }];
    [_audioButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.quoteView.ease_bottom).offset(5);
//        make.bottom.equalTo(self.inputView).offset(-kTopMargin);
        make.left.equalTo(self).offset(12);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    self.conversationToolBarBtn = [[UIButton alloc] init];
    [_conversationToolBarBtn setBackgroundImage:[UIImage easeUIImageNamed:@"attachment"] forState:UIControlStateNormal];
    [_conversationToolBarBtn setBackgroundImage:[UIImage easeUIImageNamed:@"attachment"] forState:UIControlStateSelected];
    [_conversationToolBarBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_conversationToolBarBtn];
    [_conversationToolBarBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(_quoteView.ease_bottom).offset(5);
        make.right.equalTo(self).offset(-16);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    
    self.emojiButton = [[UIButton alloc] init];
    [_emojiButton setBackgroundImage:[UIImage easeUIImageNamed:@"emoji"] forState:UIControlStateNormal];
    [_emojiButton setBackgroundImage:[UIImage easeUIImageNamed:@"character"] forState:UIControlStateSelected];
    [_emojiButton addTarget:self action:@selector(emoticonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emojiButton];
    [_emojiButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(_quoteView.ease_bottom).offset(5);
        make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        make.width.height.Ease_equalTo(kIconwidth);
    }];
    

    [self addSubview:self.textView];
    [self.textView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(_quoteView.ease_bottom).offset(5);
        make.height.Ease_equalTo(kTextViewMinHeight);
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleAll) {
            make.left.equalTo(self.audioButton.ease_right).offset(kModuleMargin);
            make.right.equalTo(self.emojiButton.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoAudio) {
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self.emojiButton.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoEmoji) {
            make.left.equalTo(self.audioButton.ease_right).offset(kModuleMargin);
            make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleNoAudioAndEmoji) {
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self.conversationToolBarBtn.ease_left).offset(-kModuleMargin);
        }
        if (_viewModel.inputMenuStyle == EaseInputMenuStyleOnlyText) {
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-16);
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
    _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    _bottomLine.alpha = 0.1;
    [self addSubview:self.bottomLine];
    [_bottomLine Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.textView.ease_bottom).offset(5);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self).offset(-EaseVIEWBOTTOMMARGIN);
    }];
    self.currentMoreView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
}

- (void)deleteQuoteAction {
    self.quoteMessage = nil;
}

- (void)raiseKeyboard {
    [self.textView becomeFirstResponder];
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

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
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
    self.text = textView.text;
    [self _updatetextViewHeight];
    if (self.moreEmoticonView) {
        [self emoticonChangeWithText];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self.textView];
    }
}

#pragma mark - Private

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

#pragma mark - Public

- (void)clearInputViewText
{
    self.textView.text = @"";
    if (self.moreEmoticonView) {
        [self emoticonChangeWithText];
    }
    [self _updatetextViewHeight];
    self.quoteMessage = nil;
}

- (void)inputViewAppendText:(NSString *)aText
{
    if ([aText length] > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, aText];
        self.text = self.textView.text;
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
        self.text = self.textView.text;
    }
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
    if (!self.audioButton.isSelected) {
        [self.audioButton Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.width.Ease_equalTo(kIconwidth);
        }];
    } else {
        [self.audioButton Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.width.Ease_equalTo(kIconwidth);
        }];
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
    if (!self.audioButton.isSelected) {
        [self.audioButton Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.width.Ease_equalTo(kIconwidth);
        }];
    } else {
        [self.audioButton Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.width.Ease_equalTo(kIconwidth);
        }];
    }
    
    return isEditing;
}

//语音
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

//表情
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

//更多
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

- (void)setQuoteMessage:(AgoraChatMessage *)quoteMessage
{
    _quoteMessage = quoteMessage;
    if (!quoteMessage) {
        self.quoteLabel.text = nil;
        self.quoteView.hidden = YES;
        [self.quoteView Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    } else {
        NSString *nickname;
        nickname = quoteMessage.from;
        NSString *content = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(inputMenuQuoteMessageShowContent:)]) {
            content = [_delegate inputMenuQuoteMessageShowContent:quoteMessage];
        }
        if (!content) {
            content = quoteMessage.easeUI_quoteShowText;
        }
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:@"Reply to " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor blackColor]}];
        [attributeText appendAttributedString:[[NSAttributedString alloc] initWithString:nickname attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightSemibold],NSForegroundColorAttributeName:[UIColor blackColor]}]];
        self.replyTo.attributedText = attributeText;
        self.quoteLabel.text = [NSString stringWithFormat:@"%@", [EaseEmojiHelper convertEmoji:content]];
        self.quoteView.hidden = NO;
        CGFloat contentHeight = [self.quoteLabel sizeThatFits:CGSizeMake(EMScreenWidth*0.75-24, 999)].height;
        [self.quoteView Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.height.equalTo(@(contentHeight+40));
        }];
    }
    [self quoteImageIcon];
}

- (void)quoteImageIcon {
    __block UIImage *image;
    if (self.quoteMessage.chatThread) {
        image = [UIImage easeUIImageNamed:@"groupThread"];
        self.quoteImageView.image = image;
    } else {
        switch (self.quoteMessage.body.type) {
            case AgoraChatMessageBodyTypeImage:
                {
                    if ([((AgoraChatImageMessageBody *)self.quoteMessage.body).thumbnailLocalPath length] > 0) {
                        image = [[UIImage imageWithContentsOfFile:((AgoraChatImageMessageBody *)self.quoteMessage.body).thumbnailLocalPath] Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill];
                    }
                    if (!image) {
                        if (((AgoraChatImageMessageBody *)self.quoteMessage.body).thumbnailRemotePath.length) {
                            NSURL *imageURL = [NSURL URLWithString:((AgoraChatImageMessageBody *)self.quoteMessage.body).thumbnailRemotePath];
                            __weak typeof(self) weakSelf = self;
                            [EaseWebImageManager.sharedManager loadImageWithURL:imageURL options:nil progress:nil completed:^(UIImage * _Nullable remoteImage, NSData * _Nullable data, NSError * _Nullable error, EaseImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                if (error == nil && image != nil) {
                                    image = [remoteImage Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill];
                                } else {
                                    image = [[UIImage easeUIImageNamed:@"msg_img_broken"] Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill];
                                }
                                weakSelf.quoteImageView.image = image;
                            }];
                        }
                    } else {
                        self.quoteImageView.image = image;
                    }
                }
                break;
            case AgoraChatMessageBodyTypeVideo:
                {
                    if ([((AgoraChatVideoMessageBody *)self.quoteMessage.body).thumbnailLocalPath length] > 0) {
                        image = [[UIImage imageWithContentsOfFile:((AgoraChatVideoMessageBody *)self.quoteMessage.body).thumbnailLocalPath] Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill];
                        if (image) {
                            image = [self combineImage:image coverImage:[UIImage easeUIImageNamed:@"video_cover"]];
                        }
                    }
                    if (!image) {
                        if (((AgoraChatVideoMessageBody *)self.quoteMessage.body).thumbnailRemotePath.length) {
                            NSURL *imageURL = [NSURL URLWithString:((AgoraChatVideoMessageBody *)self.quoteMessage.body).thumbnailRemotePath];
                            __weak typeof(self) weakSelf = self;
                            [EaseWebImageManager.sharedManager loadImageWithURL:imageURL options:nil progress:nil completed:^(UIImage * _Nullable remoteImage, NSData * _Nullable data, NSError * _Nullable error, EaseImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                if (error == nil && remoteImage != nil) {
                                    image = [self combineImage:[remoteImage Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill] coverImage:[UIImage easeUIImageNamed:@"video_cover"]];
                                } else {
                                    image = [self combineImage:[[UIImage easeUIImageNamed:@"msg_img_broken"] Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill] coverImage:[UIImage easeUIImageNamed:@"video_cover"]];
                                }
                                weakSelf.quoteImageView.image = image;
                            }];
                        } else {
                            image = [[UIImage easeUIImageNamed:@"msg_img_broken"] Ease_resizedImageWithSize:CGSizeMake(80, 80) scaleMode:EaseImageScaleModeAspectFill];
                            self.quoteImageView.image = image;
                        }
                    } else {
                        self.quoteImageView.image = image;
                    }
                }
                break;
            case AgoraChatMessageBodyTypeFile:
            {
                image = [UIImage easeUIImageNamed:@"quote_file"];
                self.quoteImageView.image = image;
            }
                break;
            case AgoraChatMessageBodyTypeCombine:
                {
                    image = [UIImage easeUIImageNamed:@"quote_combine"];
                    self.quoteImageView.image = image;
                }
                break;
            case AgoraChatMessageBodyTypeVoice:
                {
                    image = [UIImage easeUIImageNamed:@"quote_voice"];
                    self.quoteImageView.image = image;
                }
                break;
                
            default:
                self.quoteImageView.hidden = YES;
                image = nil;
                break;
        }
    }
}

- (UIImage *)combineImage:(UIImage *)image coverImage:(UIImage *)coverImage {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [coverImage drawInRect:CGRectMake(image.size.width/2.0-coverImage.size.width/2.0, image.size.height/2.0-coverImage.size.height/2.0, coverImage.size.width, coverImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (EaseTextView *)textView {
    if (_textView == nil) {
        _textView = [[EaseTextView alloc] init];
        _textView.delegate = self;
        [_textView setTextColor:[UIColor blackColor]];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textAlignment = NSTextAlignmentLeft;
        
        _textView.textContainerInset = UIEdgeInsetsMake(9, 13, 9, 21);
        _textView.returnKeyType = UIReturnKeySend;
        _textView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _textView.layer.cornerRadius = 17.5;
        _textView.tag = 123;
    }
    return _textView;
}


@end
