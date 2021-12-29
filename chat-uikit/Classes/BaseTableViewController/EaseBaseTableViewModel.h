//
//  EaseBaseTableViewModel.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/11.
//

#import <UIKit/UIKit.h>
#import "EaseChatEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseBaseTableViewModel : NSObject

// Whether to refresh by pull-down
@property (nonatomic) BOOL canRefresh;

// TableView bg view
@property (nonatomic, strong) UIView *bgView;

// UITableViewCell bg color
@property (nonatomic, strong) UIColor *cellBgColor;

// UITableViewCell cocation of the dividing line
@property (nonatomic) UIEdgeInsets cellSeparatorInset;

// UITableViewCell color of the dividing line
@property (nonatomic, strong) UIColor *cellSeparatorColor;
@end

NS_ASSUME_NONNULL_END
