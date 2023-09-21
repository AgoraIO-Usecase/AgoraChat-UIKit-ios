//
//  EMSingleChatViewController.m
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EMSingleChatViewController.h"
#import "EaseInputMenu.h"
#import "EaseMessageModel.h"
#import "EaseChatViewController+EaseUI.h"

#define TypingTimerCountNum 10

@interface EMSingleChatViewController () <EaseInputMenuDelegate>
{
    long long _previousChangedTimeStamp;
}
@property (nonatomic, strong) NSTimer *receiveTypingTimer;
@property (nonatomic, assign) NSInteger receiveTypingCountDownNum;
@property (nonatomic, strong) dispatch_queue_t msgQueue;
@property (nonatomic) BOOL editingStatusVisible;
@end

@implementation EMSingleChatViewController

- (instancetype)initSingleChatViewControllerWithCoversationid:(NSString *)conversationId
                                                chatViewModel:(EaseChatViewModel *)viewModel
{
    self = [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeChat
                          chatViewModel:(EaseChatViewModel *)viewModel];
    if (self) {
        _receiveTypingCountDownNum = 0;
        _previousChangedTimeStamp = 0;
        _editingStatusVisible = NO;
        _msgQueue = dispatch_queue_create("singlemessage.com", NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [self stopReceiveTypingTimer];
}

- (void)setEditingStatusVisible:(BOOL)editingStatusVisible
{
    _editingStatusVisible = editingStatusVisible;
}

#pragma mark - EMChatManagerDelegate

//　收到已读回执
- (void)messagesDidRead:(NSArray *)aMessages
{
    __weak typeof(self) weakself = self;
    dispatch_async(self.msgQueue, ^{
        NSString *conId = weakself.currentConversation.conversationId;
        __block BOOL isReladView = NO;
        for (AgoraChatMessage *message in aMessages) {
            if (![conId isEqualToString:message.conversationId]){
                continue;
            }
            
            [weakself.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EaseMessageModel class]]) {
                    EaseMessageModel *model = (EaseMessageModel *)obj;
                    if ([model.message.messageId isEqualToString:message.messageId]) {
                        model.message.isReadAcked = YES;
                        isReladView = YES;
                        *stop = YES;
                    }
                }
            }];
        }
        
        if (isReladView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }
    });
}

//收到消息送达回执
- (void)messagesDidDeliver:(NSArray *)aMessages
{
    __weak typeof(self) weakself = self;
    dispatch_async(self.msgQueue, ^{
        NSString *conId = weakself.currentConversation.conversationId;
        __block BOOL isReladView = NO;
        for (AgoraChatMessage *message in aMessages) {
            if (![conId isEqualToString:message.conversationId]){
                continue;
            }
            
            [weakself.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EaseMessageModel class]]) {
                    EaseMessageModel *model = (EaseMessageModel *)obj;
                    if ([model.message.messageId isEqualToString:message.messageId]) {
                        model.message.isDeliverAcked = YES;
                        isReladView = YES;
                        *stop = YES;
                    }
                }
            }];
        }
        
        if (isReladView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }
    });
}

//CMD message received
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    if (!self.editingStatusVisible)
        return;
    NSString *conId = self.currentConversation.conversationId;
    for (AgoraChatMessage *message in aCmdMessages) {
        if (![conId isEqualToString:message.conversationId]) {
            continue;
        }
        AgoraChatCmdMessageBody *body = (AgoraChatCmdMessageBody *)message.body;
        if ([body.action isEqualToString:MSG_TYPING_BEGIN]) {
            if (_receiveTypingCountDownNum == 0) {
                [self startReceiveTypingTimer];
            }else {
                _receiveTypingCountDownNum = TypingTimerCountNum;
            }
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
                    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:msg.conversationId from:msg.from to:to body:body ext:@{MSG_EXT_RECALL:@(YES)}];
                    message.chatType = (AgoraChatType)self.currentConversation.type;
                    message.isRead = YES;
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

#pragma mark - EaseInputMenuDelegate

- (void)inputViewDidChange:(UITextView *)aInputView
{
    if (self.currentConversation.type == AgoraChatConversationTypeChat) {
        long long currentTimestamp = [self getCurrentTimestamp];
        if ((currentTimestamp - _previousChangedTimeStamp) > 5 && _editingStatusVisible) {
            [self _sendBeginTyping];
            _previousChangedTimeStamp = currentTimestamp;
        }
    }
}

- (long long)getCurrentTimestamp
{
    return (long long)[[NSDate date] timeIntervalSince1970];
}

//Typing
- (void)_sendBeginTyping
{
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    NSString *to = self.currentConversation.conversationId;
    AgoraChatCmdMessageBody *body = [[AgoraChatCmdMessageBody alloc] initWithAction:MSG_TYPING_BEGIN];
    body.isDeliverOnlineOnly = YES;
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:to from:from to:to body:body ext:nil];
    message.chatType = AgoraChatTypeChat;
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}

#pragma mark - Action

- (void)sendReadReceipt:(AgoraChatMessage *)msg
{
    if ([self _isNeedSendReadAckForMessage:msg isMarkRead:NO]) {
        [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
    }
}

- (BOOL)_isNeedSendReadAckForMessage:(AgoraChatMessage *)aMessage
                          isMarkRead:(BOOL)aIsMarkRead
{
    if (aMessage.direction == AgoraChatMessageDirectionSend || aMessage.isReadAcked || aMessage.chatType != AgoraChatTypeChat)
        return NO;
    AgoraChatMessageBody *body = aMessage.body;
    if (!aIsMarkRead && (body.type == AgoraChatMessageBodyTypeFile || body.type == AgoraChatMessageBodyTypeVoice || body.type == AgoraChatMessageBodyTypeImage))
        return NO;
    if (body.type == AgoraChatMessageTypeText && [((AgoraChatTextMessageBody *)body).text isEqualToString:EaseCOMMUNICATE_CALLED_MISSEDCALL] && aMessage.direction == AgoraChatMessageDirectionReceive)
        return NO;
        
    return YES;
}

#pragma - mark Timer

//The receiving party is timing the input status
- (void)startReceiveCountDown
{
    if (_receiveTypingCountDownNum == 0) {
        [self stopReceiveTypingTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(peerEndTyping)]) {
            [self.delegate peerEndTyping];
        }
        return;
    }
    _receiveTypingCountDownNum--;
}

- (void)startReceiveTypingTimer {
    [self stopReceiveTypingTimer];
    _receiveTypingCountDownNum = TypingTimerCountNum;
    _receiveTypingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startReceiveCountDown) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:_receiveTypingTimer forMode:UITrackingRunLoopMode];
    [_receiveTypingTimer fire];
    if (self.delegate && [self.delegate respondsToSelector:@selector(peerTyping)]) {
        [self.delegate peerTyping];
    }
    
}
- (void)stopReceiveTypingTimer {
    _receiveTypingCountDownNum = 0;
    if (_receiveTypingTimer) {
        [_receiveTypingTimer invalidate];
        _receiveTypingTimer = nil;
    }
}

@end
