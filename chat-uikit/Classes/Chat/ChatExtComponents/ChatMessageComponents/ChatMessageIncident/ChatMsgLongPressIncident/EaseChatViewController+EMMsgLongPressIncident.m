//
//  EaseChatViewController+EMMsgLongPressIncident.m
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EaseChatViewController+EMMsgLongPressIncident.h"
#import <objc/runtime.h>
#import "EMMsgTextBubbleView.h"
#import "EaseDateHelper.h"
#import "EaseHeaders.h"

typedef NS_ENUM(NSInteger, EaseLongPressExecute) {
    EaseLongPressExecuteCopy = 0,
    EaseLongPressExecuteForward,
    EaseLongPressExecuteDelete,
    EaseLongPressExecuteRecall,
};

static const void *longPressIndexPathKey = &longPressIndexPathKey;
static const void *recallViewKey = &recallViewKey;
@implementation EaseChatViewController (EMMsgLongPressIncident)

@dynamic longPressIndexPath;

- (void)resetCellLongPressStatus:(EaseMessageCell *)aCell
{
    if (aCell.model.type == AgoraChatMessageTypeText && [aCell.bubbleView isKindOfClass:EMMsgTextBubbleView.class]) {
        EMMsgTextBubbleView *textBubbleView = (EMMsgTextBubbleView*)aCell.bubbleView;
        textBubbleView.textLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)deleteLongPressAction:(void (^)(AgoraChatMessage *deleteMsg))aCompletionBlock
{
    if (self.longPressIndexPath == nil || self.longPressIndexPath.row < 0) {
        return;
    }
    __weak typeof(self) weakself = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Confirm delete？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EaseMessageModel *model = [weakself.dataArray objectAtIndex:weakself.longPressIndexPath.row];
        [weakself.currentConversation deleteMessageWithId:model.message.messageId error:nil];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:weakself.longPressIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:weakself.longPressIndexPath, nil];
        if (self.longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [weakself.dataArray objectAtIndex:(weakself.longPressIndexPath.row - 1)];
            if (weakself.longPressIndexPath.row + 1 < [weakself.dataArray count]) {
                nextMessage = [weakself.dataArray objectAtIndex:(weakself.longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:weakself.longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(weakself.longPressIndexPath.row - 1) inSection:0]];
            }
        }
        __block NSDictionary *notify;
        [[self.dataArray.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *msgId = [[obj allValues] firstObject];
                if ([msgId isEqualToString:model.message.messageId]) {
                    notify = obj;
                    *stop = YES;
                }
            }
        }];
        if (notify) {
            [weakself.dataArray removeObject:notify];
        }
        [weakself.dataArray removeObjectsAtIndexes:indexs];
        if ([weakself respondsToSelector:@selector(handleMessagesRemove:)])
            [weakself performSelector:@selector(handleMessagesRemove:) withObject:@[model.message.messageId]];
        [weakself.tableView reloadData];
        if ([weakself.dataArray count] == 0) {
            weakself.msgTimelTag = -1;
        }
        weakself.longPressIndexPath = nil;
        if (aCompletionBlock) {
            aCompletionBlock(model.message);
        }
    }];
    [clearAction setValue:[UIColor colorWithRed:245/255.0 green:52/255.0 blue:41/255.0 alpha:1.0] forKey:@"_titleTextColor"];
    [alertController addAction:clearAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (aCompletionBlock) {
            aCompletionBlock(nil);
        }
    }];
    [cancelAction  setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = 0;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)copyLongPressAction
{
    if (self.longPressIndexPath == nil || self.longPressIndexPath.row < 0) {
        return;
    }
    
    EaseMessageModel *model = [self.dataArray objectAtIndex:self.longPressIndexPath.row];
    AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)model.message.body;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = body.text;
    
    self.longPressIndexPath = nil;
    [self showHint:@"Replicated"];
}

- (void)recallLongPressAction
{
    if (self.longPressIndexPath == nil || self.longPressIndexPath.row < 0) {
        return;
    }
    [self showHudInView:self.view hint:@"recall message"];
    NSIndexPath *indexPath = self.longPressIndexPath;
    __weak typeof(self) weakself = self;
    EaseMessageModel *model = [self.dataArray objectAtIndex:self.longPressIndexPath.row];
    [[AgoraChatClient sharedClient].chatManager recallMessageWithMessageId:model.message.messageId completion:^(AgoraChatError *aError) {
        [weakself hideHud];
        if (aError) {
            [EaseAlertController showErrorAlert:aError.errorDescription];
        } else {
            AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:@"You recalled a message"];
            NSString *from = [[AgoraChatClient sharedClient] currentUsername];
            NSString *to = self.currentConversation.conversationId;
            AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:to from:from to:to body:body ext:@{MSG_EXT_RECALL:@(YES)}];
            message.chatType = (AgoraChatType)self.currentConversation.type;
            message.isRead = YES;
            message.timestamp = model.message.timestamp;
            message.localTime = model.message.localTime;
            [weakself.currentConversation insertMessage:message error:nil];
            __block NSDictionary *notify;
            [[self.dataArray.reverseObjectEnumerator allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSString *msgId = [[obj allValues] firstObject];
                    if ([msgId isEqualToString:model.message.messageId]) {
                        notify = obj;
                        *stop = YES;
                    }
                }
            }];
            EaseMessageModel *newModel = [[EaseMessageModel alloc] initWithAgoraChatMessage:message];
            [weakself.dataArray replaceObjectAtIndex:indexPath.row withObject:newModel];
            if (notify) {
                [self.dataArray removeObject:notify];
            }
            if ([weakself respondsToSelector:@selector(handleMessagesRemove:)])
                [weakself performSelector:@selector(handleMessagesRemove:) withObject:@[model.message.messageId]];
            [weakself refreshTableView:NO];
        }
    }];
    
    self.longPressIndexPath = nil;
}

#pragma mark - Transpond Message

- (void)_forwardMsgWithBody:(AgoraChatMessageBody *)aBody
                         to:(NSString *)aTo
                        ext:(NSDictionary *)aExt
                 completion:(void (^)(AgoraChatMessage *message))aCompletionBlock
{
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:aTo from:from to:aTo body:aBody ext:aExt];
    message.chatType = AgoraChatTypeChat;
    
    __weak typeof(self) weakself = self;
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        if (error) {
            [weakself.currentConversation deleteMessageWithId:message.messageId error:nil];
            [EaseAlertController showErrorAlert:@"Message forwarding failure"];
        } else {
            if (aCompletionBlock) {
                aCompletionBlock(message);
            }
            [EaseAlertController showSuccessAlert:@"Message forwarding success"];
            if ([aTo isEqualToString:weakself.currentConversation.conversationId]) {
                [weakself sendReadReceipt:message];
                [weakself.currentConversation markMessageAsReadWithId:message.messageId error:nil];
                NSArray *formated = [weakself formatMsgs:@[message]];
                [weakself.dataArray addObjectsFromArray:formated];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself refreshTableView:YES];
                });
            }
        }
    }];
}

#pragma mark - Data

- (NSArray *)formatMsgs:(NSArray<AgoraChatMessage *> *)aMessages
{
    NSMutableArray *formated = [[NSMutableArray alloc] init];

    for (int i = 0; i < [aMessages count]; i++) {
        AgoraChatMessage *msg = aMessages[i];
        if (msg.chatType == AgoraChatTypeChat && msg.isReadAcked && (msg.body.type == AgoraChatMessageBodyTypeText || msg.body.type == AgoraChatMessageBodyTypeLocation)) {
            [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
        }
        
        CGFloat interval = (self.msgTimelTag - msg.timestamp) / 1000;
        if (self.msgTimelTag < 0 || interval > 60 || interval < -60) {
            NSString *timeStr = [EaseDateHelper formattedTimeFromTimeInterval:msg.timestamp dateType:EaseDateTypeChat];
            [formated addObject:timeStr];
            self.msgTimelTag = msg.timestamp;
        }
        EaseMessageModel *model = nil;
        model = [[EaseMessageModel alloc] initWithAgoraChatMessage:msg];
        if (!model) {
            model = [[EaseMessageModel alloc]init];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:)]) {
            id<EaseUserProfile> userData = [self.delegate userProfile:msg.from];
            model.userDataProfile = userData;
        }

        [formated addObject:model];
    }
    
    return formated;
}

- (void)_forwardImageMsg:(AgoraChatMessage *)aMsg
                  toUser:(NSString *)aUsername
{
    AgoraChatImageMessageBody *newBody = nil;
    AgoraChatImageMessageBody *imgBody = (AgoraChatImageMessageBody *)aMsg.body;
    // 如果图片是己方发送，直接获取图片文件路径；若是对方发送，则需先查看原图（自动下载原图），再转发。
    if ([aMsg.from isEqualToString:AgoraChatClient.sharedClient.currentUsername]) {
        newBody = [[AgoraChatImageMessageBody alloc]initWithLocalPath:imgBody.localPath displayName:imgBody.displayName];
    } else {
        if (imgBody.downloadStatus != AgoraChatDownloadStatusSuccessed) {
            [EaseAlertController showErrorAlert:@"Please download the original image first"];
            return;
        }
        
        newBody = [[AgoraChatImageMessageBody alloc]initWithLocalPath:imgBody.localPath displayName:imgBody.displayName];
    }
    
    newBody.size = imgBody.size;
    __weak typeof(self) weakself = self;
    [weakself _forwardMsgWithBody:newBody to:aUsername ext:aMsg.ext completion:^(AgoraChatMessage *message) {
        
    }];
}

- (void)_forwardVideoMsg:(AgoraChatMessage *)aMsg
                  toUser:(NSString *)aUsername
{
    AgoraChatVideoMessageBody *oldBody = (AgoraChatVideoMessageBody *)aMsg.body;

    __weak typeof(self) weakself = self;
    void (^block)(AgoraChatMessage *aMessage) = ^(AgoraChatMessage *aMessage) {
        AgoraChatVideoMessageBody *newBody = [[AgoraChatVideoMessageBody alloc] initWithLocalPath:oldBody.localPath displayName:oldBody.displayName];
        newBody.thumbnailLocalPath = oldBody.thumbnailLocalPath;
        
        [weakself _forwardMsgWithBody:newBody to:aUsername ext:aMsg.ext completion:^(AgoraChatMessage *message) {
            [(AgoraChatVideoMessageBody *)message.body setLocalPath:[(AgoraChatVideoMessageBody *)aMessage.body localPath]];
            [[AgoraChatClient sharedClient].chatManager updateMessage:message completion:nil];
        }];
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:oldBody.localPath]) {
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:aMsg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (error) {
                [EaseAlertController showErrorAlert:@"Message forwarding failure"];
            } else {
                block(aMsg);
            }
        }];
    } else {
        block(aMsg);
    }
}

- (void)_transpondMsg:(EaseMessageModel *)aModel
               toUser:(NSString *)aUsername
{
    AgoraChatMessageBodyType type = aModel.message.body.type;
    if (type == AgoraChatMessageBodyTypeText || type == AgoraChatMessageBodyTypeLocation)
        [self _forwardMsgWithBody:aModel.message.body to:aUsername ext:aModel.message.ext completion:nil];
    if (type == AgoraChatMessageBodyTypeImage)
        [self _forwardImageMsg:aModel.message toUser:aUsername];
    if (type == AgoraChatMessageBodyTypeVideo)
        [self _forwardVideoMsg:aModel.message toUser:aUsername];
}

#pragma mark - getter & setter

- (NSIndexPath *)longPressIndexPath
{
    return objc_getAssociatedObject(self, longPressIndexPathKey);
}
- (void)setLongPressIndexPath:(NSIndexPath *)longPressIndexPath
{
    objc_setAssociatedObject(self, longPressIndexPathKey, longPressIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
