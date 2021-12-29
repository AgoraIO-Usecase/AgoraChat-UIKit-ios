//
//  HorizontalLayout.h
//  EaseIM
//
//  Created by zhangchong on 2020/5/7.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HorizontalLayout : UICollectionViewFlowLayout

/** Horizontal item num */
@property (nonatomic,assign) NSInteger rowCount;
/** Vertical item数量 */
@property (nonatomic,assign) NSInteger columCount;
/** item total */
@property (nonatomic,assign) NSInteger itemCountSum;

- (instancetype)initWithOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset;

@end

NS_ASSUME_NONNULL_END
