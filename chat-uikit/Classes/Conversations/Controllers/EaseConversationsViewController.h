//
//  EaseConversationsViewController.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import "EasePublicHeaders.h"
#import "EaseBaseTableViewController.h"
#import "EaseConversationModel.h"
#import "EaseConversationViewModel.h"
#import "EaseConversationCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EaseConversationsViewControllerDelegate <EaseBaseViewControllerDelegate>

@optional

- (EaseConversationCell *)easeTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<UIContextualAction *> *)easeTableView:(UITableView *)tableView
           trailingSwipeActionsForRowAtIndexPath:(NSIndexPath *)indexPath
                                         actions:(NSArray<UIContextualAction *> *)actions  API_AVAILABLE(ios(11.0));

- (void)easeTableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)easeTableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)easeTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (id<EaseUserProfile>)easeUserProfileAtConversationId:(NSString *)conversationId
                                        conversationType:(AgoraChatConversationType)type;

@end

@interface EaseConversationsViewController : EaseBaseTableViewController
<
EaseBaseViewControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
AgoraChatManagerDelegate,
AgoraChatClientDelegate
>

@property (nonatomic, strong) NSMutableArray<EaseConversationModel *> *dataAry;
@property (nonatomic, weak) id <EaseConversationsViewControllerDelegate> delegate;
- (instancetype)initWithModel:(EaseConversationViewModel *)aModel;
//reset user profiles
- (void)resetUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry;
//reset viewmodel
- (void)resetConversationVCWithViewModel:(EaseConversationViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
