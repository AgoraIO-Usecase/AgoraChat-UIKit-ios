//
//  EMBottomMoreFunctionView.h
//  EaseIMKit
//
//  Created by 冯钊 on 2022/2/22.
//

#import <UIKit/UIKit.h>

@class EaseExtendMenuModel;

typedef NS_ENUM(NSUInteger, EMBottomMoreFunctionType) {
    EMBottomMoreFunctionTypeMessage,
    EMBottomMoreFunctionTypeChat,
};

NS_ASSUME_NONNULL_BEGIN

@interface EMBottomMoreFunctionView : UIView

+ (void)showMenuItems:(NSArray <EaseExtendMenuModel *>*)menuItems
          contentType:(EMBottomMoreFunctionType)type
            animation:(BOOL)animation
  didSelectedMenuItem:(void(^)(EaseExtendMenuModel *menuItem))didSelectedMenuItem
     didSelectedEmoji:(void(^)(NSString *emoji))didSelectedEmoji;

+ (void)showMenuItems:(NSArray <EaseExtendMenuModel *>*)menuItems
          contentType:(EMBottomMoreFunctionType)type
            animation:(BOOL)animation
            maskPaths:(nullable NSArray<UIBezierPath *> *)maskPaths
  didSelectedMenuItem:(void(^)(EaseExtendMenuModel *menuItem))didSelectedMenuItem
     didSelectedEmoji:(void(^)(NSString *emoji))didSelectedEmoji;

+ (void)hideWithAnimation:(BOOL)animation needClear:(BOOL)needClear;

@end

NS_ASSUME_NONNULL_END
