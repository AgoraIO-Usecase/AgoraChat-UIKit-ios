/************************************************************
 *  * AgoraChat CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 AgoraChat Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of AgoraChat Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from AgoraChat Inc.
 */

#import "UIViewController+HUD.h"

#import "EaseProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (EaseProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(EaseProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    EaseProgressHUD *HUD = [[EaseProgressHUD alloc] initWithView:view];
    HUD.label.text = hint;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint
{
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    EaseProgressHUD *hud = [EaseProgressHUD showHUDAddedTo:win animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = EaseProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0;
    hud.bezelView.style = EaseProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.layer.cornerRadius = 10;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.margin = 15.f;
    CGPoint offset = hud.offset;
    offset.y = 200;
    hud.offset = offset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    EaseProgressHUD *hud = [EaseProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = EaseProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    CGPoint offset = hud.offset;
    offset.y = 180 + yOffset;
    hud.offset = offset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

+ (UIViewController *)currentViewController {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow* window in scene.windows) {
                    if(window.isKeyWindow) {
                        UIViewController* vc =  window.rootViewController;
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            return ((UINavigationController*)vc).visibleViewController;
                        } else if ([vc isKindOfClass:[UITabBarController class]]) {
                            UIViewController* selectVC = ((UITabBarController*)vc).selectedViewController;
                            if ([selectVC isKindOfClass:[UINavigationController class]]) {
                                return ((UINavigationController*)selectVC).visibleViewController;
                            } else {
                                return selectVC;
                            }
                        } else {
                            return vc;
                        }
                    }
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return nil;
}
@end
