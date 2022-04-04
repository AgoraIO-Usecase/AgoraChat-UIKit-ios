//
//  AgoraThreadChatViewController.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/19.
//

#import "EaseThreadChatViewController.h"
#import "EaseChatViewController+EaseUI.h"
#import "UIImage+EaseUI.h"
#import "UIColor+EaseUI.h"
#import "EMBottomMoreFunctionView.h"
#import "EaseThreadChatHeader.h"
#import "EMMsgTouchIncident.h"
@interface EaseThreadChatViewController ()<AgoraChatThreadManagerDelegate,EaseThreadChatHeaderDelegate>

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, strong) AgoraChatMessage *message;

@property (nonatomic, strong) AgoraChatGroup *group;

@property (nonatomic, strong) NSString *isAdmin;//admin 1 unadmin 0

@end

@implementation EaseThreadChatViewController

- (instancetype)initThreadChatViewControllerWithCoversationid:(NSString *)conversationId chatViewModel:(EaseChatViewModel *)viewModel parentMessageId:(NSString * __nullable)parentMessageId model:(EaseMessageModel *)model {
    _messageId = parentMessageId;
    self = [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeGroupChat
                                            chatViewModel:(EaseChatViewModel *)viewModel isThread:YES parentMessageId:parentMessageId];
    if (self) {
        if (model) {
            void (^requestBlock)(AgoraChatThread *thread, AgoraChatError *aError) = ^(AgoraChatThread *thread, AgoraChatError *aError){
                if (!aError) {
                    model.thread = thread;
                    EaseThreadChatHeader *header = [[EaseThreadChatHeader alloc] initWithMessageType:model.type displayType:EMThreadHeaderTypeDisplay viewModel:self.viewModel model:model];
                    header.delegate = self;
                    self.tableView.tableHeaderView = header;
                }
            };
            [self getThread:requestBlock];
        } else {
            [self getThread:nil];
        }
    }
    return self;
}

- (void)getThread:(void (^)(AgoraChatThread *thread, AgoraChatError *aError))block {
    if (_messageId.length) {
        [AgoraChatClient.sharedClient.threadManager getThreadDetail:self.currentConversation.conversationId completion:block];
    } else {
        [AgoraChatClient.sharedClient.threadManager getThreadDetail:self.currentConversation.conversationId completion:^(AgoraChatThread *thread, AgoraChatError *aError) {
            if (!aError) {
                EaseMessageModel *model = [EaseMessageModel new];
                model.thread = thread;
                model.direction = AgoraChatMessageDirectionReceive;
                EaseThreadChatHeader *header = [[EaseThreadChatHeader alloc] initWithMessageType:AgoraChatMessageTypeCmd displayType:EMThreadHeaderTypeDisplayNoMessage viewModel:self.viewModel model:model];
                header.delegate = self;
                self.tableView.tableHeaderView = header;
            }
        }];
    }
}

- (void)headerAvatarClick:(EaseMessageModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidSelected:)]) {
        [self.delegate avatarDidSelected:model.userDataProfile];
    }
}

- (void)headerMessageDidSelected:(EaseThreadCreateCell *)aCell {
    BOOL isCustom = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMessageItem:userProfile:)]) {
        isCustom = [self.delegate didSelectMessageItem:aCell.model.message userProfile:aCell.model.userDataProfile];
        if (!isCustom) return;
    }
    //Message event policy classification
    AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:aCell];
    eventStrategy.chatController = self;
    [eventStrategy messageCellEventOperation:aCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AgoraChatClient sharedClient].threadManager addListenerDelegate:self delegateQueue:nil];
}

- (AgoraChatMessage *)message {
    if (!_message) {
        _message = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:self.messageId];
    }
    return _message;
}

- (AgoraChatGroup *)group {
    if (!_group) {
        _group = [AgoraChatGroup groupWithId:self.message.to];
    }
    return _group;
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient].threadManager removeListenerDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)isAdmin {
    if (!_isAdmin) {
        _isAdmin = @"0";
        for (NSString *admin in self.group.adminList) {
            if ([[AgoraChatClient.sharedClient currentUsername] isEqualToString:admin]) {
                _isAdmin = @"1";
                break;
            }
        }
    }
    return _isAdmin;
}

- (void)showThreadOperationList {
   
    __weak typeof(self) weakself = self;
    NSMutableArray<EaseExtendMenuModel*> *extMenuArray = [[NSMutableArray<EaseExtendMenuModel*> alloc]init];
    EaseExtendMenuModel *threadMember = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"disbandThread"] funcDesc:@"Thread Members" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
    }];
    EaseExtendMenuModel *muteThread = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"disbandThread"] funcDesc:@"Thread Notifications" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
    }];
    EaseExtendMenuModel *editThread = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"disbandThread"] funcDesc:@"Edit Notifications" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
    }];
    EaseExtendMenuModel *leaveThread = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"disbandThread"] funcDesc:@"Leave Thread" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
    }];
    [extMenuArray addObjectsFromArray:@[threadMember,muteThread,editThread,leaveThread]];
    if ([_isAdmin isEqualToString:@"1"]) {
        EaseExtendMenuModel *disbandThread = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"disbandThread"] funcDesc:@"Disband Thread" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        }];
        disbandThread.funcDescColor = [UIColor colorWithHexString:@"#FF14CC"];
        [extMenuArray addObject:disbandThread];
    }
    
    [EMBottomMoreFunctionView showMenuItems:extMenuArray contentType:EMBottomMoreFunctionTypeChat animation:YES didSelectedMenuItem:^(EaseExtendMenuModel * _Nonnull menuItem) {
        menuItem.itemDidSelectedHandle(menuItem.funcDesc, YES);
        [EMBottomMoreFunctionView hideWithAnimation:YES needClear:NO];
    } didSelectedEmoji:^(NSString * _Nonnull emoji) {
        
    }];
}

#pragma mark - EaseMessageCellDelegate

//Read the receipt details
- (void)messageReadReceiptDetil:(EaseMessageCell *)aCell
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(groupMessageReadReceiptDetail:groupId:)]) {
//        [self.delegate groupMessageReadReceiptDetail:aCell.model.message groupId:self.currentConversation.conversationId];
//    }
}

#pragma mark - ACtion

- (void)sendReadReceipt:(AgoraChatMessage *)msg
{
    if (msg.isNeedGroupAck && !msg.isReadAcked) {
        [[AgoraChatClient sharedClient].chatManager sendGroupMessageReadAck:msg.messageId toGroup:msg.conversationId content:@"123" completion:^(AgoraChatError *error) {
            if (error) {
               
            }
        }];
    }
}

#pragma mark - EMChatManagerDelegate



- (void)messagesInfoDidRecall:(NSArray<EMRecallMessageInfo *> *)aRecallMessagesInfo {
    [aRecallMessagesInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AgoraChatMessage *msg = ((EMRecallMessageInfo *)obj).recallMessage;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                EaseMessageModel *model = (EaseMessageModel *)obj;
                if ([model.message.messageId isEqualToString:msg.messageId]) {
                    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:@"The other party retracted a message"];
                    NSString *to = [[AgoraChatClient sharedClient] currentUsername];
                    NSString *from = self.currentConversation.conversationId;
                    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:from from:from to:to body:body ext:@{MSG_EXT_RECALL:@(YES)}];
                    message.chatType = (AgoraChatType)self.currentConversation.type;
                    message.isRead = YES;
                    message.messageId = msg.messageId;
                    message.localTime = msg.localTime;
                    message.timestamp = msg.timestamp;
                    [self.currentConversation insertMessage:message error:nil];
                    EaseMessageModel *replaceModel = [[EaseMessageModel alloc]initWithAgoraChatMessage:message];
                    [self.dataArray replaceObjectAtIndex:idx withObject:replaceModel];
                }
            }
        }];
    }];
    [self.tableView reloadData];
}

#pragma mark - EMThreadManagerDelegate

- (void)onMemberJoined:(NSString *)parentId threadId:(NSString *)threadId userName:(NSString *)userName {
    
}

- (void)onMemberLeaved:(NSString *)parentId threadId:(NSString *)threadId userName:(NSString *)userName {
    
}

- (void)onThreadNameChanged:(NSString *)threadName threadId:(NSString *)threadId {
    
}

- (void)onThreadDestoryed:(NSString *)parentId threadId:(NSString *)threadId from:(NSString *)from operation:(NSString *)operation {
    
}


@end
