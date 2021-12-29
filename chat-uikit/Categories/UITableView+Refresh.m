//
//  UITableView+Refresh.m
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/6.
//

#import "UITableView+Refresh.h"
#import "UIImage+EaseUI.h"

@implementation UITableView (Refresh)

- (void)enableRefresh:(NSString *)title color:(UIColor *)tintColor {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = tintColor;
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:title];
    self.refreshControl = refreshControl;
}

- (void)disableRefresh {
    self.refreshControl = nil;
}

- (BOOL)isRefreshing {
    return [self.refreshControl isRefreshing];
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

@end
