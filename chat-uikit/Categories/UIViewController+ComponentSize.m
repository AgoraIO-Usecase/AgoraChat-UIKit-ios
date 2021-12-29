//
//  UIViewController+ComponentSize.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/25.
//

#import "UIViewController+ComponentSize.h"

@implementation UIViewController (ComponentSize)

- (void)keyBoardWillShow:(NSNotification *)note animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished, CGRect keyBoardBounds))completion
{
    // Obtaining User information
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // Get keyboard height
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // Get keyboard animation time
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animations completion:^(BOOL finished) {
            if (completion) {
                completion(finished, keyBoardBounds);
            }
        }];
    } else {
        animations();
    }
}

- (void)keyBoardWillHide:(NSNotification *)note animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion
{
    // Obtaining User information
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // Get keyboard animation time
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animations completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        animations();
    }
}

//Bang height
- (CGFloat)bangScreenSize {
     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
         return 0;
     }
     CGSize size = [UIScreen mainScreen].bounds.size;
     NSInteger notchValue = size.width / size.height * 100;
     if (216 == notchValue || 46 == notchValue) {
         return 34;
     }
     return 0;
}

@end
