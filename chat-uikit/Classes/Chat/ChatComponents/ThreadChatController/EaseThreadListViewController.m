//
//  AgoraChatThreadListViewController.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/13.
//

#import "EaseThreadListViewController.h"
#import "EaseDefines.h"
#import "UITableView+Refresh.h"

#import "UIColor+EaseUI.h"
#import "EaseThreadChatViewController.h"
#import "UIViewController+HUD.h"

@interface EaseThreadListViewController ()<UITableViewDelegate,UITableViewDataSource,AgoraChatThreadManagerDelegate,AgoraChatMultiDevicesDelegate>

@property (nonatomic, strong) NSMutableDictionary *threadMessageMap;

@property (nonatomic) BOOL loadMoreFinished;

@property (nonatomic) AgoraChatCursorResult *cursor;

@property (nonatomic) NSLock *lock;


@property (nonatomic) BOOL isAdmin;

@end

@implementation EaseThreadListViewController

- (instancetype)initWithGroup:(AgoraChatGroup *)group chatViewModel:(EaseChatViewModel *)viewModel{
    if ([super init]) {
        self.group = group;
        self.viewModel = viewModel;
        self.threadMessageMap = [NSMutableDictionary dictionary];
        [self requestList];
    }
    return self;
}

- (BOOL)isAdmin {
    BOOL contain = NO;
    NSMutableArray *admins = [NSMutableArray arrayWithArray:self.group.adminList];
    [admins addObject:self.group.owner];
    for (NSString *admin in admins) {
        if ([[[AgoraChatClient.sharedClient currentUsername] lowercaseString] isEqualToString:[admin lowercaseString]]) {
            contain = YES;
        }
    }
    return contain;
}

- (void)requestList {
    if (self.cursor == nil) {
        [self.dataArray removeAllObjects];
    }
    self.loadMoreFinished = NO;
    if (self.isAdmin) {
        [[AgoraChatClient sharedClient].threadManager getChatThreadsFromServerWithParentId:self.group.groupId cursor:self.cursor ? self.cursor.cursor:@"" pageSize:20 completion:^(AgoraChatCursorResult *result, AgoraChatError *aError) {
            if (!aError) {
                self.loadMoreFinished = YES;
                self.cursor = result;
                [self.threadList endRefreshing];
                [self loadDataArray:result.list];
            }
        }];
    } else {
        [AgoraChatClient.sharedClient.threadManager getJoinedChatThreadsFromServerWithParentId:self.group.groupId cursor:self.cursor ? self.cursor.cursor:@"" pageSize:20 completion:^(AgoraChatCursorResult * _Nonnull result, AgoraChatError * _Nonnull aError) {
            if (!aError) {
                self.loadMoreFinished = YES;
                self.cursor = result;
                [self.threadList endRefreshing];
                [self loadDataArray:result.list];
            }
        }];
    }
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
    [[AgoraChatClient sharedClient].threadManager getLastMessageFromSeverWithChatThreads:ids completion:^(NSDictionary<NSString *,AgoraChatMessage *> * _Nonnull messageMap, AgoraChatError * _Nonnull aError) {
        if (!aError) {
            [self.threadMessageMap addEntriesFromDictionary:messageMap];
            [self mapMessage];
        }
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
    [[AgoraChatClient sharedClient].threadManager addDelegate:self delegateQueue:nil];
}

- (void)dealloc {
    _dataArray = nil;
    _group = nil;
    [[AgoraChatClient sharedClient].threadManager removeDelegate:self];
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
    if (self.dataArray.count - 1 == indexPath.row && self.loadMoreFinished == YES && self.cursor.list.count == 20) {
        [self requestList];
    }
}

- (void)pushThreadChat:(EaseThreadConversation *)conv{
    if (!conv.threadInfo.threadId.length) {
        [self showHint:@"conversationId is empty!"];
        return;
    }
    EaseMessageModel *model;
    AgoraChatMessage *message = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:conv.threadInfo.messageId];
    if (message.messageId.length) {
        model = [[EaseMessageModel alloc]initWithAgoraChatMessage:message];
        model.direction = message.direction;
        model.type = (AgoraChatMessageType)message.body.type;
        model.thread = conv.threadInfo;
    }
    [AgoraChatClient.sharedClient.threadManager joinChatThread:conv.threadInfo.threadId completion:^(AgoraChatThread *thread, AgoraChatError *aError) {
        if (!aError || aError.code == AgoraChatErrorUserAlreadyExist) {
            EaseThreadChatViewController *VC = [[EaseThreadChatViewController alloc] initThreadChatViewControllerWithCoversationid:conv.threadInfo.threadId chatViewModel:self.viewModel parentMessageId:message.messageId.length ? message.messageId:@"" model:message.messageId.length ? model:nil];
            VC.title = thread ? thread.threadName:conv.threadInfo.threadName;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
}


- (void)onChatThreadCreate:(AgoraChatThreadEvent *)event {
    if (event.chatThread.threadName && event.from && [self.group.groupId isEqualToString:event.chatThread.parentId]) {
        [self dropdownRefreshTableViewWithData];
    }
}

- (void)onChatThreadDestroy:(AgoraChatThreadEvent *)event {
    if (event.chatThread.threadName && event.from && [self.group.groupId isEqualToString:event.chatThread.parentId]) {
        [self dropdownRefreshTableViewWithData];
    }
}

#pragma mark - AgoraChatMultiDevicesDelegate
- (void)multiDevicesThreadEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent threadId:(NSString *)aThreadId ext:(id)aExt {
    //MARK: - 由于上面的代理已经通知处理过了，避免重复处理固此处没处理
}

@end
