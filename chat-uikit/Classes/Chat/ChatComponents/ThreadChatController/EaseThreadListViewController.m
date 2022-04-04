//
//  AgoraChatThreadListViewController.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/13.
//

#import "EaseThreadListViewController.h"
#import "EaseDefines.h"
#import "UITableView+Refresh.h"

#import "AgoraChatThreadListNavgation.h"
#import "UIColor+EaseUI.h"
#import "EaseThreadChatViewController.h"
#import "UIViewController+HUD.h"

@interface EaseThreadListViewController ()<UITableViewDelegate,UITableViewDataSource,AgoraChatThreadNotifyDelegate>

@property (nonatomic, strong) AgoraChatThreadListNavgation *navBar;

@property (nonatomic, strong) AgoraChatGroup *group;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@property (nonatomic, strong) NSMutableDictionary *threadMessageMap;

@property (nonatomic) BOOL loadMoreFinished;

@property (nonatomic) AgoraChatCursorResult *cursor;

@property (nonatomic) NSLock *lock;

@end

@implementation EaseThreadListViewController

- (instancetype)initWithGroup:(AgoraChatGroup *)group chatViewModel:(EaseChatViewModel *)viewModel{
    if ([super init]) {
        self.group = group;
        __weak typeof(self) weakSelf = self;
        self.viewModel = viewModel;
        self.threadMessageMap = [NSMutableDictionary dictionary];
        [self requestList];
    }
    return self;
}

- (void)requestList {
    self.loadMoreFinished = NO;
    __weak typeof(self) weakSelf = self;
    [[AgoraChatClient sharedClient].threadManager getThreadsOfGroupFromServerWithGroupId:self.group.groupId joined:NO cursor:self.cursor ? self.cursor.cursor:@"" pageSize:20 completion:^(AgoraChatCursorResult *result, AgoraChatError *aError) {
        weakSelf.loadMoreFinished = YES;
        weakSelf.cursor = result;
        [weakSelf loadDataArray:result.list];
    }];
}

- (void)loadDataArray:(NSArray *)array {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    NSMutableArray *ids = [NSMutableArray array];
    for (AgoraChatThread *thread in array) {
        EaseThreadConversation *model = [EaseThreadConversation new];
        model.threadInfo = thread;
        [ids addObject:thread.threadId];
        [self.dataArray addObject:model];
    }
    [self.threadList reloadData];
    [[AgoraChatClient sharedClient].threadManager getMesssageFromSeverWithThreads:ids completion:^(NSDictionary<NSString *,AgoraChatMessage *> *messageMap, AgoraChatError *aError) {
        [self.threadMessageMap addEntriesFromDictionary:messageMap];
        [self mapMessage];
    }];
}

- (void)mapMessage {
    [self.lock lock];
    if (self.threadMessageMap.count > 0) {
        for (EaseThreadConversation *model in self.dataArray) {
            model.lastMessage = [self.threadMessageMap valueForKey:model.threadInfo.threadId];
        }
    }
    [self.lock unlock];
    [self.threadList reloadData];
}

- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry
{
    if (!userProfileAry || userProfileAry.count == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.dataArray || self.dataArray.count == 0) return;

        for (int index = 0; index < self.dataArray.count; index++) {
            id obj = [self.dataArray objectAtIndex:index];
            EaseThreadConversation *model = nil;
            if ([obj isKindOfClass:[EaseThreadConversation class]]) {
                model = (EaseThreadConversation *)obj;
                if (model.lastMessage != nil) {
                    for (id<EaseUserProfile> matchingProfile in userProfileAry) {
                        if ([model.lastMessage.from isEqualToString:matchingProfile.easeId]) {
                            model.userDataProfile = matchingProfile;
                            break;
                        }
                    }
                }
            }
        }
        
        if (self.threadList.isRefreshing) {
            [self.threadList endRefreshing];
        }
        [self.threadList reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.threadList];
    [[AgoraChatClient sharedClient].threadManager addNotifyDelegate:self delegateQueue:nil];
}

- (void)dealloc {
    _dataArray = nil;
    _group = nil;
    _navBar = nil;
    [[AgoraChatClient sharedClient].threadManager removeNotifyDelegate:self];
}

- (AgoraChatThreadListNavgation *)navBar {
    if (!_navBar) {
        _navBar = [[AgoraChatThreadListNavgation alloc]initWithFrame:CGRectMake(0, 0, EMScreenWidth, EMNavgationHeight)];
        _navBar.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        __weak typeof(self) weakSelf = self;
        [_navBar setBackBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _navBar;
}

- (UITableView *)threadList {
    if (!_threadList) {
        _threadList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, EMScreenWidth, EMScreenHeight - EMNavgationHeight) style:UITableViewStylePlain];
        _threadList.delegate = self;
        _threadList.dataSource = self;
        _threadList.tableFooterView = [UIView new];
        _threadList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _threadList.scrollsToTop = NO;
        [_threadList enableRefresh:@"drop down refresh" color:UIColor.systemGrayColor];
        [_threadList.refreshControl addTarget:self action:@selector(dropdownRefreshTableViewWithData) forControlEvents:UIControlEventValueChanged];
    }
    return _threadList;
}

- (void)dropdownRefreshTableViewWithData {
    //TODO: - refresh threadList
    self.cursor = nil;
    [self requestList];
    [self.threadList reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(agoraChatThreadList:heightForRowAtIndexPath:)]) {
        return [self.delegate agoraChatThreadList:tableView heightForRowAtIndexPath:indexPath];
    }
    return 60;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EaseThreadCell *cell;
    if (self.delegate && [self.delegate respondsToSelector:@selector(agoraChatThreadList:cellForRowAtIndexPath:)]) {
        cell = [self.delegate agoraChatThreadList:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AgoraChatThreadCell"];
    }
    if (!cell) {
        cell = [[EaseThreadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AgoraChatThreadCell"];
    }
    EaseThreadConversation *model = self.dataArray[indexPath.row];
    if (self.threadMessageMap != nil && self.threadMessageMap.count > 0) {
        model.lastMessage = [self.threadMessageMap valueForKey:model.threadInfo.threadId];
    }
    cell.model = model;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(agoraChatThreadList:didSelectRowAtIndexPath:)]) {
        [self.delegate agoraChatThreadList:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    [self pushThreadChat:self.dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count - 2 == indexPath.row && self.loadMoreFinished && self.cursor.list.count == 20) {
        [self requestList];
    }
}

- (void)pushThreadChat:(EaseThreadConversation *)conv{
    if (!conv.threadInfo.threadId.length) {
        [self showHint:@"conversationId is empty!"];
        return;
    }
    [AgoraChatClient.sharedClient.threadManager asyncJoinThread:conv.threadInfo.threadId completion:^( AgoraChatError *aError) {
        if (!aError) {
            EaseThreadChatViewController *VC = [[EaseThreadChatViewController alloc] initThreadChatViewControllerWithCoversationid:conv.threadInfo.threadId chatViewModel:self.viewModel parentMessageId:@"" model:nil];
            VC.title = conv.threadInfo.threadName;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
}


- (void)threadNotifyChange:(AgoraChatThreadEvent *)evnet {
    if (evnet) {
        if (evnet.threadName && evnet.from) {
            if ([evnet.threadOperation isEqualToString:@"create"] || [evnet.threadOperation isEqualToString:@"delete"]) {
                [self dropdownRefreshTableViewWithData];
            } else if ([evnet.threadOperation isEqualToString:@"update"]) {
                NSUInteger index;
                for (id obj in self.dataArray) {
                    if ([obj isKindOfClass:[EaseThreadConversation class]]) {
                        EaseThreadConversation *model = (EaseThreadConversation *)obj;
                        if ([model.lastMessage.messageId isEqualToString:evnet.messageId]) {
                            index = [self.dataArray indexOfObject:obj];
                            model.threadInfo.threadName = evnet.threadName;
                            break;
                        }
                    }
                }
                [self.threadList reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

@end
