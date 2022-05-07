//
//  AgoraChatThreadListViewController.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/13.
//

#import <UIKit/UIKit.h>
#import "EaseThreadCell.h"
#import "EaseMessageModel.h"
#import "EaseChatViewModel.h"
@protocol EaseThreadListProtocol <NSObject>
@optional
- (UITableViewCell *)agoraChatThreadList:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)agoraChatThreadList:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)agoraChatThreadList:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end


@interface EaseThreadListViewController : UIViewController

@property (nonatomic, strong) UITableView *threadList;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@property (nonatomic, strong) AgoraChatGroup *group;

@property (nonatomic, weak) id <EaseThreadListProtocol> delegate;

- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry;

- (instancetype)initWithGroup:(AgoraChatGroup *)group chatViewModel:(EaseChatViewModel *)viewModel;

@end
