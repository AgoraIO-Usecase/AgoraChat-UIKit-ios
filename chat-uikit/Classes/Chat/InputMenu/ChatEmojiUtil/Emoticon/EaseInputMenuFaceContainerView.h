//
//  EaseInputMenuFaceContainerView.h
//  chat-uikit
//
//  Created by liu001 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EaseInputMenuEmoticonView;
@interface EaseInputMenuFaceContainerView : UIView
@property (nonatomic, strong) EaseInputMenuEmoticonView *moreEmoticonView;
@property (nonatomic, assign, readonly) CGFloat viewHeight;

- (instancetype)initWithViewHeight:(CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
