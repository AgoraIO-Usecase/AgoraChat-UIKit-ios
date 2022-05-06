//
//  EMBottomReactionDetailView.h
//  EaseIMKit
//
//  Created by 冯钊 on 2022/2/24.
//

#import <UIKit/UIKit.h>

@class AgoraChatMessage;

NS_ASSUME_NONNULL_BEGIN

@interface EMBottomReactionDetailView : UIView

+ (void)showMenuItems:(AgoraChatMessage *)message
            animation:(BOOL)animation
didRemoveSelfReaction:(void(^)(NSString *reaction))didRemoveSelfReaction;

+ (void)hideWithAnimation:(BOOL)animation needClear:(BOOL)needClear;

@end

NS_ASSUME_NONNULL_END
