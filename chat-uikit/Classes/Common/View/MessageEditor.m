//
//  TextMessageEditor.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import "MessageEditor.h"
#import "EaseDefines.h"
#import "AgoraChatMessage+EaseUIExt.h"
#import "EaseEmojiHelper.h"

#define kTextViewMinHeight 80
#define kTextViewMaxHeight EMScreenHeight/3.0

@interface MessageEditor ()<UITextViewDelegate>

@property (nonatomic) void(^callback)(NSString *content);

@property (nonatomic) CGFloat keyboardHeight;

@property (nonatomic) CGFloat previousTextViewContentHeight;

@end

@implementation MessageEditor

- (instancetype)initWithFrame:(CGRect)frame message:(AgoraChatMessage *)message doneClosure:(void (^)(NSString *))doneClosure {
    if (self = [super initWithFrame:frame]) {
        self.callback = doneClosure;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.background];
        [self addSubview:self.container];
        
        [self.container addSubview:self.cancel];
        [self.container addSubview:self.title];
        [self.container addSubview:self.done];
        [self.container addSubview:self.textView];
        
        self.textView.placeholder = message.easeUI_quoteShowText;
        self.textView.placeholderColor = [UIColor darkGrayColor];
        if (message.body.type == AgoraChatMessageBodyTypeText) {
            NSString* text = [message.body valueForKey:@"text"];
            self.textView.text = [EaseEmojiHelper convertEmoji:text];
        }
        [self updateTextViewHeight];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (UIView *)background {
    if (!_background) {
        _background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _background.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _background;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, EMScreenHeight-154, EMScreenWidth, 154)];
        _container.backgroundColor = [UIColor whiteColor];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(12.0, 12.0)];
        [shapeLayer setPath:path.CGPath];
        _container.layer.mask = shapeLayer;
    }
    return _container;

}

- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancel.frame = CGRectMake(4, 8, 80, 28);
        _cancel.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        _cancel.tag = 11;
        [_cancel addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancel.frame)+5, 8, (EMScreenWidth-178), 28)];
        _title.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _title.textColor = [UIColor darkTextColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text = @"Message Edit";
    }
    return _title;
}

- (UIButton *)done {
    if (!_done) {
        _done = [UIButton buttonWithType:UIButtonTypeSystem];
        _done.frame = CGRectMake(EMScreenWidth-84, 8, 80, 28);
        [_done setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        _done.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_done setTitle:@"Done" forState:UIControlStateNormal];
        _done.tag = 12;
        [_done addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _done;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![touches.anyObject.view isEqual:self.container]) {
        [self endEditing:YES];
    }
}

- (PlaceHolderTextView *)textView {
    if (!_textView) {
        _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(8, 46, EMScreenWidth-16, 80)];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor darkTextColor];
        _textView.tintColor = [UIColor systemBlueColor];
        _textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor systemBlueColor]};
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
    }
    return _textView;

}

- (void)showWithVC:(UIViewController *)vc {
    [vc.view.window addSubview:self];
}

- (void)senderAction:(UIButton *)sender {
    [self endEditing:YES];
    if (sender.tag == 12) {
        if (self.callback) {
            NSString* tmp = [EaseEmojiHelper convertFromEmoji:self.textView.text];
            self.callback(tmp);
        }
    }
    [self removeFromSuperview];
}

- (CGFloat)heightForText:(NSString *)text {
    CGFloat height = 0;
    UILabel *label = [UILabel new];
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    height = ceilf([label sizeThatFits:CGSizeMake(EMScreenWidth-20, 999)].height+10);
    label = nil;
    return height;
}

- (CGFloat)textViewContentHeight
{
    return ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
}

- (void)updateTextViewHeight
{
    CGFloat height = [self textViewContentHeight];
    if (height < kTextViewMinHeight) {
        height = kTextViewMinHeight;
        self.previousTextViewContentHeight = height;
        return;
    }
    if (height > kTextViewMaxHeight) {
        height = kTextViewMaxHeight;
    }
    if (height == self.previousTextViewContentHeight) {
        return;
    }
    
    CGFloat div = fabs(height-self.previousTextViewContentHeight);
    self.previousTextViewContentHeight = height;
    [UIView animateWithDuration:0.25 animations:^{
        self.container.frame = CGRectMake(self.container.frame.origin.x, EMScreenHeight-self.keyboardHeight-46-height, self.container.frame.size.width, 46+height);
        self.textView.frame = CGRectMake(8, 46, EMScreenWidth-16, height);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 0) {
        self.done.enabled = YES;
    } else {
        self.done.enabled = NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateTextViewHeight];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    self.keyboardHeight = keyboardHeight;
    [UIView animateWithDuration:duration animations:^{
        self.container.frame = CGRectMake(self.container.frame.origin.x, EMScreenHeight-keyboardHeight-self.container.frame.size.height, self.container.frame.size.width, self.container.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.container.frame = CGRectMake(self.container.frame.origin.x, EMScreenHeight-self.container.frame.size.height, self.container.frame.size.width, self.container.frame.size.height);
    }];
}


@end
