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

@interface EMGroupChatViewController () <AgoraChatGroupManagerDelegate>

@property (nonatomic, strong) AgoraChatGroup *group;

@end

@implementation EMGroupChatViewController

- (instancetype)initGroupChatViewControllerWithCoversationid:(NSString *)conversationId
                                               chatViewModel:(EaseChatViewModel *)viewModel
{
    return [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeGroupChat
                          chatViewModel:(EaseChatViewModel *)viewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AgoraChatClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)dealloc
{
    [[AgoraChatClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - EMGroupManagerDelegate

- (void)userDidJoinGroup:(AgoraChatGroup *)aGroup
                    user:(NSString *)aUsername
{
}

@end
