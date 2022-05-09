//
//  EaseInputMenuFaceContainerView.h
//  chat-uikit
//
//  Created by liu001 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EaseInputMenuStripopView;
@protocol EaseInputMenuFaceContainerViewDelegate <NSObject>
- (void)showGiphyViewController;
- (void)selectedStikerWithUrlString:(NSString *)urlString fileType:(NSString *)fileType;

@end

@class EaseInputMenuEmoticonView;
@interface EaseInputMenuFaceContainerView : UIView
@property (nonatomic, strong) EaseInputMenuEmoticonView *moreEmoticonView;
@property (nonatomic, strong) EaseInputMenuStripopView *stripopView;
@property (nonatomic, assign, readonly) CGFloat viewHeight;
@property (nonatomic, assign) id<EaseInputMenuFaceContainerViewDelegate> delegate;

- (instancetype)initWithViewHeight:(CGFloat)viewHeight;
- (void)resetContainerView;

@end

NS_ASSUME_NONNULL_END
