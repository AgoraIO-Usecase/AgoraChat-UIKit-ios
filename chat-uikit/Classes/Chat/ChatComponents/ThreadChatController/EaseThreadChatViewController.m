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
#import "UIViewController+HUD.h"
@interface EaseThreadChatViewController ()<AgoraChatThreadManagerDelegate,EaseThreadChatHeaderDelegate,AgoraChatMultiDevicesDelegate>

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, strong) AgoraChatMessage *message;

@property (nonatomic, strong) NSString *parentId;

@end

@implementation EaseThreadChatViewController

- (instancetype)initThreadChatViewControllerWithCoversationid:(NSString *)conversationId chatViewModel:(EaseChatViewModel *)viewModel parentMessageId:(NSString * __nullable)parentMessageId model:(EaseMessageModel *)model {
    _messageId = parentMessageId;
    self = [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeGroupChat
                                            chatViewModel:(EaseChatViewModel *)viewModel isChatThread:YES parentMessageId:parentMessageId];
    if (self) {
        if (model) {
            self.model = model;
        }
        [self getThread];
    }
    return self;
}

- (void)getThread {
    [AgoraChatClient.sharedClient.threadManager getChatThreadFromSever:self.currentConversation.conversationId completion:^(AgoraChatThread * _Nonnull thread, AgoraChatError * _Nonnull aError) {
        if (!aError) {
            [self createHeaderWithThread:thread];
        } else {
            [self showHint:aError.errorDescription];
        }
    }];
}

- (void)createHeaderWithThread:(AgoraChatThread *)thread {
    self.owner = thread.owner;
    if (self.delegate && [self.delegate respondsToSelector:@selector(threadChatHeader)]) {
        self.tableView.tableHeaderView = [self.delegate threadChatHeader];
        return;
    }
    self.parentId = thread.parentId;
    EaseMessageModel *model;
    if (self.messageId.length) {
        self.model.thread = thread;
        model = self.model;
    } else {
        model = [EaseMessageModel new];
        model.thread = thread;
        model.direction = AgoraChatMessageDirectionReceive;
    }
    model.isPlaying = NO;
    EaseThreadChatHeader *header = [[EaseThreadChatHeader alloc] initWithMessageType:self.model.type displayType:self.messageId.length ?EMThreadHeaderTypeDisplay:EMThreadHeaderTypeDisplayNoMessage viewModel:self.viewModel model:model];
    header.delegate = self;
    self.tableView.tableHeaderView = header;
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
    if (aCell.model.message.body.type != AgoraChatMessageBodyTypeCombine) {
        //Message event policy classification
        NSString *msgId = aCell.model.message.ext[@"msgQuote"][@"msgID"];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                EaseMessageModel *model = (EaseMessageModel *)obj;
                if ([model.message.messageId isEqualToString:msgId]) {
                    aCell.quoteModel = model;
                    *stop = YES;
                }
            }
        }];
        AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:aCell.model.type];
        eventStrategy.chatController = self;
        [eventStrategy messageCellEventOperation:aCell];
    } else {
        [self performSelector:@selector(lookupCombineMessage:) withObject:aCell.model.message];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AgoraChatClient sharedClient].threadManager addDelegate:self delegateQueue:nil];
    [AgoraChatClient.sharedClient addMultiDevicesDelegate:self delegateQueue:nil];
}

- (AgoraChatMessage *)message {
    if (!_message) {
        _message = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:self.messageId];
    }
    return _message;
}

- (AgoraChatGroup *)group {
    if (!_group) {
        if (self.parentId) {
            _group = [AgoraChatGroup groupWithId:self.parentId];
        }
    }
    return _group;
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient].threadManager removeDelegate:self];
    [AgoraChatClient.sharedClient removeMultiDevicesDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)isAdmin {
    if (!_isAdmin) {
        _isAdmin = @"0";
        if (!self.group) {
            return _isAdmin;
        }
        NSMutableArray *admins = [NSMutableArray arrayWithArray:self.group.adminList];
        [admins addObject:self.group.owner];
        for (NSString *admin in admins) {
            if ([[[AgoraChatClient.sharedClient currentUsername] lowercaseString] isEqualToString:[admin lowercaseString]]) {
                _isAdmin = @"1";
                break;
            }
        }
    }
    return _isAdmin;
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



- (void)messagesInfoDidRecall:(NSArray<AgoraChatRecallMessageInfo *> *)aRecallMessagesInfo {
    [aRecallMessagesInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AgoraChatMessage *msg = ((AgoraChatRecallMessageInfo *)obj).recallMessage;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                EaseMessageModel *model = (EaseMessageModel *)obj;
                if ([model.message.messageId isEqualToString:msg.messageId]) {
                    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:@"The other party retracted a message"];
                    NSString *to = [[AgoraChatClient sharedClient] currentUsername];
                    NSString *from = self.currentConversation.conversationId;
                    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:model.message.conversationId from:msg.from to:to body:body ext:@{MSG_EXT_RECALL:@(YES)}];
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

- (void)onChatThreadUpdate:(AgoraChatThreadEvent *)event {
    if (![event.chatThread.threadId isEqualToString:self.currentConversation.conversationId]) {
        return;
    }
    if (event.chatThread.lastMessage == nil) {
        NSString *threadName = event.chatThread.threadName;
        if (!threadName) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(threadNameChange:)]) {
            [self.delegate threadNameChange:threadName];
        }
        [((EaseThreadChatHeader *)self.tableView.tableHeaderView) setThreadName:threadName];
    }
}

- (void)onChatThreadDestroy:(AgoraChatThreadEvent *)event {
    if (![event.chatThread.threadId isEqualToString:self.currentConversation.conversationId]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(popThreadChat)]) {
        [self.delegate popThreadChat];
        return;
    }
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

- (void)onUserKickOutOfChatThread:(AgoraChatThreadEvent *)event {
    if (![event.chatThread.threadId isEqualToString:self.currentConversation.conversationId]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(popThreadChat)]) {
        [self.delegate popThreadChat];
        return;
    }
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

- (void)multiDevicesThreadEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent threadId:(NSString *)aThreadId ext:(id)aExt {
    if (![aThreadId isEqualToString:self.currentConversation.conversationId]) {
        return;
    }
    switch (aEvent) {
        case AgoraChatMultiDevicesEventChatThreadLeave:
            if (self.delegate && [self.delegate respondsToSelector:@selector(popThreadChat)]) {
                [self.delegate popThreadChat];
                return;
            }
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
            break;
        case AgoraChatMultiDevicesEventChatThreadUpdate:
            //MARK: - threadNotify 已经刷新过了。这里刷新会重复刷新
            break;
        default:
            break;
    }
    
}


@end
