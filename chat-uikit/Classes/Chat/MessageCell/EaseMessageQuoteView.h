//
//  EaseMessageQuoteView.h
//  EaseIMKit
//
//  Created by 冯钊 on 2023/4/26.
//

#import <UIKit/UIKit.h>

@class AgoraChatMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol EaseMessageQuoteViewDelegate <NSObject>
@optional
- (NSAttributedString *)quoteViewShowContent:(AgoraChatMessage *)message;

@end

@interface EaseMessageQuoteView : UIView

@property (nonatomic, weak) id<EaseMessageQuoteViewDelegate> delegate;

@property (nonatomic, copy) AgoraChatMessage *message;

@end

NS_ASSUME_NONNULL_END
