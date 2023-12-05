//
//  EaseInputMenu.h
//  EaseChat
//
//  Updated by zhangchong on 2020/06/05.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseInputMenuEmoticonView.h"
#import "EaseInputMenuRecordAudioView.h"
#import "EaseExtendMenuView.h"
#import "EaseChatViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EaseInputMenuDelegate;
@interface EaseInputMenu : UIView

@property (nonatomic, copy) NSString *text;

@property (nonatomic, weak) id<EaseInputMenuDelegate> delegate;
@property (nonatomic, strong) EaseInputMenuRecordAudioView *recordAudioView;
@property (nonatomic, strong) EaseInputMenuEmoticonView *moreEmoticonView;
@property (nonatomic, strong) EaseExtendMenuView *extendMenuView;
@property (nonatomic, strong) AgoraChatMessage *quoteMessage;

- (instancetype)initWithViewModel:(EaseChatViewModel *)viewModel;

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)raiseKeyboard;

@end


@protocol EaseInputMenuDelegate <NSObject>

@optional

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)textViewDidChangeSelection:(UITextView *)textView;

- (void)inputViewDidChange:(UITextView *)textView;

- (void)inputBarDidShowToolbarAction;

- (void)inputBarSendMsgAction:(NSString *)text;

- (void)didSelectExtFuncPopupView;

- (NSString *)inputMenuQuoteMessageShowContent:(AgoraChatMessage *)message;

@end

NS_ASSUME_NONNULL_END
