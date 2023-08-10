//
//  EditNavigationBar.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditNavigationBar : UIView

- (instancetype)initWithFrame:(CGRect)frame cancel:(void (^)(void))cancel;

@end

NS_ASSUME_NONNULL_END
