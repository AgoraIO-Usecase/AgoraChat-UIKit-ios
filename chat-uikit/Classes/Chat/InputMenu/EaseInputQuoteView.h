//
//  EaseInputQuoteView.h
//  chat-uikit
//
//  Created by 冯钊 on 2023/6/5.
//

#import <UIKit/UIKit.h>

@class AgoraChatMessage, EaseInputQuoteView;

NS_ASSUME_NONNULL_BEGIN

@protocol EaseInputQuoteViewDelegate <NSObject>

- (void)quoteViewDidClickCancel:(EaseInputQuoteView *)quoteView;
- (nullable NSString *)quoteMessage:(EaseInputQuoteView *)quoteView showContent:(AgoraChatMessage *)message;

@end

@interface EaseInputQuoteView : UIView

@property (nonatomic, strong, nullable) AgoraChatMessage *message;
@property (nonatomic, weak) id<EaseInputQuoteViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
