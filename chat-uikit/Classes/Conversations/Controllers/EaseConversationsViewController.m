//
//  EaseConversationsViewController.m
//  EaseChatKit
//
//  Created by dujiepeng on 2020/10/29.
//

#import "EaseConversationsViewController.h"
#import "EaseHeaders.h"
#import "AgoraChatConversation+EaseUI.h"
#import "UIImage+EaseUI.h"
#import "AgoraChatMessage+RemindMe.h"
#import "UITableView+Refresh.h"

static NSString *cellIdentifier = @"EaseConversationCell";

@interface EaseConversationsViewController ()
{
    dispatch_queue_t _loadDataQueue;
}
@property (nonatomic, strong) UIView *blankPerchView;
@property (nonatomic, strong) EaseConversationViewModel *viewModel;

@end

@implementation EaseConversationsViewController

- (instancetype)initWithModel:(EaseConversationViewModel *)aModel{
    if (self = [super initWithModel:aModel]) {
        _viewModel = aModel;
        _loadDataQueue = dispatch_queue_create("com.easemob.easeui.conversations.queue", 0);
        [[AgoraChatClient sharedClient] addDelegate:self delegateQueue:nil];
        [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTabView)
                                                 name:CONVERSATIONLIST_UPDATE object:nil];
    
    __weak typeof(self) weakSelf = self;
    [[AgoraChatClient sharedClient].pushManager getPushNotificationOptionsFromServerWithCompletion:^(AgoraChatPushOptions * _Nonnull aOptions, AgoraChatError * _Nonnull aError) {
        if (!aError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endRefresh];
            });
        }
    }];
//    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    iv.backgroundColor = [UIColor orangeColor];
//    iv.contentMode = UIViewContentModeScaleAspectFit;
//    iv.image = [self combineImage:[UIImage easeUIImageNamed:@"chatroom_unread_bg"] coverImage:[UIImage easeUIImageNamed:@"quote_voice"]];
//    [self.view addSubview:iv];
}

- (NSString*)refreshTitle
{
    return @"Refreshing conversation list";
}

//- (UIImage *)combineImage:(UIImage *)image coverImage:(UIImage *)coverImage {
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    [coverImage drawInRect:CGRectMake(image.size.width/2.0-18, image.size.height/2.0-18, 36, 36)];
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return resultingImage;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endRefresh];
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient] removeDelegate:self];
    [[AgoraChatClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry
{
    if (!userProfileAry || userProfileAry.count == 0) return;
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakself.dataAry || weakself.dataAry.count == 0) return;

        for (int index = 0; index < weakself.dataAry.count; index++) {
            EaseConversationModel *model = [weakself.dataAry objectAtIndex:index];
            for (id<EaseUserProfile> matchingProfile in userProfileAry) {
                if ([model.easeId isEqualToString:matchingProfile.easeId]) {
                    model.userProfile = matchingProfile;
                    break;
                }
            }
        }
        
        [weakself endRefresh];
        [weakself _updateBackView];
    });
}

- (void)resetConversationVCWithViewModel:(EaseConversationViewModel *)viewModel
{
    _viewModel = viewModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - AgoraChatClientDelegate

- (void)autoLoginDidCompleteWithError:(AgoraChatError *)aError
{
    [self _loadAllConversationsFromDB];
    [[AgoraChatClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:200 pageSize:0 completion:^(NSArray *aList, AgoraChatError *aError) {
        NSArray *ary = [[AgoraChatClient sharedClient].groupManager getJoinedGroups];
        [self _loadAllConversationsFromDB];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EaseConversationCell *cell = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeTableView:cellForRowAtIndexPath:)]) {
        cell = [self.delegate easeTableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        cell = [EaseConversationCell tableView:tableView identifier:cellIdentifier];
    }
    
    if (!cell) {
        cell = [[EaseConversationCell alloc]initWithConversationsViewModel:_viewModel identifier:cellIdentifier];
    }
    if (indexPath.row >= self.dataAry.count || self.dataAry.count <= 0) {
        return cell;
    }
    EaseConversationModel *model = self.dataAry[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - Table view delegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos)
{
    EaseConversationModel *model = [self.dataAry objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakself = self;
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                               title:@"Delete"
                                                                             handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                        {
        [weakself _deleteConversation:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"FF14CC"];
    
    UIContextualAction *topAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                            title:!model.isTop ? @"Pin" : @"Unpin"
                                                                          handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                     {
        AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversation:model.easeId
                                                                                     type:model.type
                                                                         createIfNotExist:YES];
        [conversation setTop:!model.isTop];
        [weakself refreshTabView];
    }];
    topAction.backgroundColor = [UIColor colorWithHexString:@"005FFF"];
    
    NSArray *swipeActions = @[deleteAction, topAction];
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeTableView:trailingSwipeActionsForRowAtIndexPath:actions:)]) {
        swipeActions = [self.delegate easeTableView:tableView trailingSwipeActionsForRowAtIndexPath:indexPath actions:swipeActions];
    }
    
    if (swipeActions == nil) {
        return nil;
    }
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:swipeActions];
    actions.performsFirstActionWithFullSwipe = NO;
    return actions;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeTableView:willBeginEditingRowAtIndexPath:)]) {
        [self.delegate easeTableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeTableView:didEndEditingRowAtIndexPath:)]) {
        [self.delegate easeTableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

/*
- (void)makeSwipeButton:(UITableView *)tableView
{
    UIView *swipeView = [[UIView alloc]init];
    if (@available(iOS 13.0, *))
    {
        for (UIView *subview in tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")] )
            {
                NSArray *subviewArray=subview.subviews;
                for (UIView *sub_subview in subviewArray)
                {
                    if ([sub_subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
                    {
                        swipeView = sub_subview;
                    }
                }
            }
        }
    } else if (@available(iOS 11.0, *)) {
        for (UIView *subview in tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] )
            {
                swipeView = subview;
            }
        }
    }
    
    NSArray *subViews = swipeView.subviews;
    for (UIView *subView in subViews) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, subView.frame.size.width, subView.frame.size.height)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage easeUIImageNamed:@"alert_error"]];
        [view addSubview:imageView];
        [imageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.centerX.equalTo(view.ease_centerX);
            make.bottom.equalTo(view.ease_centerY);
            make.height.width.equalTo(@30);
        }];
        
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.text = @"stick";
        titleLable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLable];
        [titleLable Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.ease_centerY);
            make.height.equalTo(@30);
        }];
        view.backgroundColor = [UIColor colorWithHexString:@"CB7D32"];
        view.userInteractionEnabled = NO;
        
        [swipeView insertSubview:view aboveSubview:subView];
    }
}
*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataAry.count || self.dataAry.count <= 0) {
        return;
    }
    EaseConversationModel *model = [self.dataAry objectAtIndex:indexPath.row];
    if (!model.isTop) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(easeTableView:didSelectRowAtIndexPath:)]) {
        return [self.delegate easeTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - AgoraChatChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages {
    [self _loadAllConversationsFromDB];
}

- (void)messagesDidReceive:(NSArray *)aMessages
{
    if (aMessages && [aMessages count]) {
        AgoraChatMessage *msg = aMessages[0];
        if ([msg remindMe]) {
            AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:msg.conversationId type:AgoraChatConversationTypeGroupChat createIfNotExist:NO];
            NSDictionary* ext = msg.ext;
            BOOL atALL = NO;
            if (ext && [ext objectForKey:@"em_at_list"]) {
                id atList = [ext objectForKey:@"em_at_list"];
                if ([atList isKindOfClass:[NSString class]]) {
                    if ([atList isEqualToString:@"ALL"]) {
                        atALL = YES;
                    }
                }
            }
            if (atALL) {
                [conversation setRemindAll];
            } else
                [conversation setRemindMe:msg.messageId];
        }
    }
    [self _loadAllConversationsFromDB];
}

- (void)onConversationRead:(NSString *)from to:(NSString *)to
{
    [self _loadAllConversationsFromDB];
}

- (void)messagesDidRead:(NSArray *)aMessages
{
    [self refreshTable];
}

#pragma mark - UIMenuController

- (void)_deleteConversation:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    NSInteger row = indexPath.row;
    EaseConversationModel *model = [self.dataAry objectAtIndex:row];
    [[AgoraChatClient sharedClient].chatManager deleteConversation:model.easeId
                                           isDeleteMessages:YES
                                                 completion:^(NSString *aConversationId, AgoraChatError *aError) {
        if (!aError) {
            if (row >= 0 && row <= self.dataAry.count - 1 && self.dataAry.count > 0) {
                [weakSelf.dataAry removeObjectAtIndex:row];
                [weakSelf.tableView reloadData];
                [weakSelf _updateBackView];
            }
//            [weakSelf refreshTabView];

        }
    }];
}

- (void)_loadAllConversationsFromDB
{
    __weak typeof(self) weakSelf = self;
    if (!_loadDataQueue) return;
    dispatch_async(_loadDataQueue, ^{
        NSMutableArray<id<EaseUserProfile>> *totals = [NSMutableArray<id<EaseUserProfile>> array];
        
        NSArray *conversations = [AgoraChatClient.sharedClient.chatManager getAllConversations];
        
        NSMutableArray *convs = [NSMutableArray array];
        NSMutableArray *topConvs = [NSMutableArray array];
        
        for (AgoraChatConversation *conv in conversations) {
            if (!conv.latestMessage) {
                /*[AgoraChatClient.sharedClient.chatManager deleteConversation:conv.conversationId
                                                     isDeleteMessages:NO
                                                           completion:nil];*/
                continue;
            }
            
            if (conv.type == AgoraChatConversationTypeChatRoom && !weakSelf.viewModel.displayChatroom) {
                continue;
            }

            EaseConversationModel *item = [[EaseConversationModel alloc] initWithConversation:conv];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(easeUserProfileAtConversationId:conversationType:)]) {
                item.userProfile = [weakSelf.delegate easeUserProfileAtConversationId:conv.conversationId conversationType:conv.type];
            }
            
            if (item.isTop) {
                [topConvs addObject:item];
            }else {
                [convs addObject:item];
            }
        }
        
        NSArray *normalConvList = [convs sortedArrayUsingComparator:
                                   ^NSComparisonResult(EaseConversationModel *obj1, EaseConversationModel *obj2)
                                   {
            if (obj1.lastestUpdateTime > obj2.lastestUpdateTime) {
                return(NSComparisonResult)NSOrderedAscending;
            }else {
                return(NSComparisonResult)NSOrderedDescending;
            }
        }];
        
        NSArray *topConvList = [topConvs sortedArrayUsingComparator:
                                ^NSComparisonResult(EaseConversationModel *obj1, EaseConversationModel *obj2)
                                {
            if (obj1.lastestUpdateTime > obj2.lastestUpdateTime) {
                return(NSComparisonResult)NSOrderedAscending;
            }else {
                return(NSComparisonResult)NSOrderedDescending;
            }
        }];
        
        [totals addObjectsFromArray:topConvList];
        [totals addObjectsFromArray:normalConvList];
        
        weakSelf.dataAry = (NSMutableArray *)totals;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf endRefresh];
            [weakSelf _updateBackView];
        });
    });
}

- (void)refreshTabView
{
    [self _loadAllConversationsFromDB];
}

- (void)_updateBackView {
    if (self.dataAry.count == 0) {
        [self.tableView.backgroundView setHidden:NO];
    }else {
        [self.tableView.backgroundView setHidden:YES];
    }
}

@end
