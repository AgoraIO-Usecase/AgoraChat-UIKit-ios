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

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

+ (UIViewController *)currentViewController;

@end
