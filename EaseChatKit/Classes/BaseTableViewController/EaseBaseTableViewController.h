//
//  EaseBaseTableViewController.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/6.
//

#import <UIKit/UIKit.h>
#import "EaseBaseTableViewModel.h"
#import "EaseUserProfile.h"

NS_ASSUME_NONNULL_BEGIN

@class EaseConversationCell;
@protocol EaseBaseViewControllerDelegate  <NSObject>

@end


@interface EaseBaseTableViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) __kindof EaseBaseTableViewModel *baseViewModel;

- (instancetype)initWithModel:(__kindof EaseBaseTableViewModel *)aModel;

// Actively refreshing the UI
- (void)refreshTable;

// Refresh data resources and UI
-(void)refreshTabView;

// End refresh
- (void)endRefresh;

@end

NS_ASSUME_NONNULL_END
