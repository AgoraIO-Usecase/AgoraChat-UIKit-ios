//
//  EMGroupChatViewController.m
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EMGroupChatViewController.h"
#import "EaseMessageModel.h"
#import "AgoraChatConversation+EaseUI.h"
#import "EaseAlertController.h"
#import "EaseAlertView.h"
#import "EaseTextView.h"
#import "EaseMessageCell.h"
#import "EaseChatViewController+EaseUI.h"
#import "EaseThreadListViewController.h"

@interface EMGroupChatViewController () <AgoraChatGroupManagerDelegate,AgoraChatThreadNotifyDelegate>

@property (nonatomic, strong) AgoraChatGroup *group;

@end

@implementation EMGroupChatViewController

- (instancetype)initGroupChatViewControllerWithCoversationid:(NSString *)conversationId
                                               chatViewModel:(EaseChatViewModel *)viewModel
{
    self.group = [AgoraChatGroup groupWithId:conversationId];
    return [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeGroupChat
                          chatViewModel:(EaseChatViewModel *)viewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AgoraChatClient sharedClient].threadManager addNotifyDelegate:self delegateQueue:nil];
    [[AgoraChatClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient].groupManager removeDelegate:self];
    [[AgoraChatClient sharedClient].threadManager removeNotifyDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)threadsList {
//    [super threadsList];
    EaseThreadListViewController *VC = [[EaseThreadListViewController alloc] initWithGroup:self.group chatViewModel:self.viewModel];
    [self.navigationController pushViewController:VC animated:YES];
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

//Received the group message read receipt
- (void)groupMessageDidRead:(AgoraChatMessage *)aMessage groupAcks:(NSArray *)aGroupAcks
{
    EaseMessageModel *msgModel;
    AgoraChatGroupMessageAck *msgAck = aGroupAcks[0];
    for (int i=0; i<[self.dataArray count]; i++) {
        if([self.dataArray[i] isKindOfClass:[EaseMessageModel class]]){
            msgModel = (EaseMessageModel *)self.dataArray[i];
        }else{
            continue;
        }
        if([msgModel.message.messageId isEqualToString:msgAck.messageId]){
            [self.dataArray setObject:msgModel atIndexedSubscript:i];
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself refreshTableView:YES];
            });
            break;
        }
    }
}

- (void)messagesDidRecall:(NSArray *)aMessages {
    [aMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AgoraChatMessage *msg = (AgoraChatMessage *)obj;
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


#pragma mark - EMGroupManagerDelegate

- (void)userDidJoinGroup:(AgoraChatGroup *)aGroup
                    user:(NSString *)aUsername
{
}


- (void)threadNotifyChange:(AgoraChatThreadEvent *)evnet {
    if (evnet) {
        if (evnet.threadName && evnet.from) {
            if ([evnet.threadOperation isEqualToString:@"create"]) {
                id<EaseUserProfile> userThreadData = [self.delegate userProfile:evnet.from];
                NSString *threadNotify = [NSString stringWithFormat:@"%@ started a thread:%@\nSee all threads",userThreadData.showName ? userThreadData.showName:evnet.from,evnet.threadName];
                [self.dataArray addObject:threadNotify];
                [self refreshTableView:YES];
            } else if ([evnet.threadOperation isEqualToString:@"update"]) {
                AgoraChatMessage *message = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:evnet.messageId];
                message.msgOverView.threadName = evnet.threadName;
                NSInteger index = [self.dataArray indexOfObject:message];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([evnet.threadOperation isEqualToString:@"update_msg"] || [evnet.threadOperation isEqualToString:@"recall_msg"]) {
                AgoraChatMessage *message = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:evnet.messageId];
                message.msgOverView = evnet;
                NSInteger index = [self.dataArray indexOfObject:message];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else if ([evnet.threadOperation isEqualToString:@"delete"]) {
                [self.tableView reloadData];
            }
        }
    }
}

@end
