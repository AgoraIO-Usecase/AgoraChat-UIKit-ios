//
//  EaseBadgeView.h
//  
//
//  Created by dujiepeng on 2020/11/20.
//

#import <UIKit/UIKit.h>
#import "EaseChatEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseBadgeView : UIView
@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) int maxNum;
- (int)badgeNum;
- (void)setBagde:(int)badge badgeStyle:(EaseChatUnReadBadgeViewStyle)badgeViewStyle;
@end

NS_ASSUME_NONNULL_END
