//
//  EaseChatKitManager.m
//  EaseChatKit
//
//  Created by dujiepeng on 2020/10/29.
//

#import "EaseChatKitManager.h"
#import "EaseConversationsViewController.h"
#import "EaseChatKitManager+ExtFunction.h"
#import "EaseMulticastDelegate.h"
#import "EaseDefines.h"
   
bool gInit;
static EaseChatKitManager *EaseChatKit = nil;
static NSString *g_ChatKitVersion = @"3.8.7";

@interface EaseChatKitManager ()<AgoraChatMultiDevicesDelegate, AgoraChatContactManagerDelegate, AgoraChatGroupManagerDelegate, AgoraChatManagerDelegate>
@property (nonatomic, strong) EaseMulticastDelegate<EaseChatKitManagerDelegate> *delegates;
@property (nonatomic, strong) NSString *currentConversationId;
@property (nonatomic, assign) NSInteger currentUnreadCount;
@property (nonatomic, strong) dispatch_queue_t msgQueue;
@end

#define IMChatKitVersion @"3.8.7"

@implementation EaseChatKitManager
+ (BOOL)initWithAgoraChatOptions:(AgoraChatOptions *)options {
    if (!gInit) {
        [AgoraChatClient.sharedClient initializeSDKWithOptions:options];
        [self shareInstance];
        gInit = YES;
    }
    
    return gInit;
}

+ (EaseChatKitManager *)shared {
    return EaseChatKit;
}

+ (NSString *)EaseChatKitVersion {
    return IMChatKitVersion;
}

+ (EaseChatKitManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (EaseChatKit == nil) {
            EaseChatKit = [[EaseChatKitManager alloc] init];
        }
    });
    return EaseChatKit;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegates = (EaseMulticastDelegate<EaseChatKitManagerDelegate> *)[[EaseMulticastDelegate alloc] init];
        _currentConversationId = @"";
        _msgQueue = dispatch_queue_create("easemessage.com", NULL);
    }
    [[AgoraChatClient sharedClient] addMultiDevicesDelegate:self delegateQueue:nil];
    [[AgoraChatClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[AgoraChatClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    return self;
}

- (void)dealloc
{
    [self.delegates removeAllDelegates];
    [[AgoraChatClient sharedClient] removeMultiDevicesDelegate:self];
    [[AgoraChatClient sharedClient].contactManager removeDelegate:self];
    [[AgoraChatClient sharedClient].groupManager removeDelegate:self];
}

#pragma mark - Public

- (NSString *)version
{
    return g_ChatKitVersion;
}

- (void)addDelegate:(id<EaseChatKitManagerDelegate>)aDelegate
{
    [self.delegates addDelegate:aDelegate delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id<EaseChatKitManagerDelegate>)aDelegate
{
    [self.delegates removeDelegate:aDelegate];
}

#pragma mark - AgoraChatManageDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    [self _resetConversationsUnreadCount];
}
 
/*
#pragma mark - AgoraChatContactManagerDelegate

//收到好友请求
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage
{
    if ([aUsername length] == 0) {
        return;
    }
    [self structureSystemNotification:aUsername userName:aUsername reason:ContanctsRequestDidReceive];
}

//收到好友请求被同意/同意
- (void)friendshipDidAddByUser:(NSString *)aUsername
{
    [self notificationMsg:aUsername aUserName:aUsername conversationType:AgoraChatConversationTypeChat];
}

#pragma mark - AgoraChatGroupManagerDelegate

//群主同意用户A的入群申请后，用户A会接收到该回调
- (void)joinGroupRequestDidApprove:(AgoraChatGroup *)aGroup
{
    [self notificationMsg:aGroup.groupId aUserName:AgoraChatClient.sharedClient.currentUsername conversationType:AgoraChatConversationTypeGroupChat];
}

//有用户加入群组
- (void)userDidJoinGroup:(AgoraChatGroup *)aGroup
                    user:(NSString *)aUsername
{
    [self notificationMsg:aGroup.groupId aUserName:aUsername conversationType:AgoraChatConversationTypeGroupChat];
}

////收到群邀请
//- (void)groupInvitationDidReceive:(NSString *)aGroupId
//                          inviter:(NSString *)aInviter
//                          message:(NSString *)aMessage
//{
//    if ([aGroupId length] == 0 || [aInviter length] == 0) {
//        return;
//    }
//    [self structureSystemNotification:aGroupId userName:aInviter reason:GroupInvitationDidReceive];
//}
//
////收到加群申请
//- (void)joinGroupRequestDidReceive:(AgoraChatGroup *)aGroup
//                              user:(NSString *)aUsername
//                            reason:(NSString *)aReason
//{
//    if ([aGroup.groupId length] == 0 || [aUsername length] == 0) {
//        return;
//    }
//    [self structureSystemNotification:aGroup.groupId userName:aUsername reason:JoinGroupRequestDidReceive];
//}

#pragma mark - private

//系统通知构造为会话
- (void)structureSystemNotification:(NSString *)conversationId userName:(NSString*)userName reason:(EaseChatKitCallBackReason)reason
{
    if (![self isNeedsSystemNoti]) {
        return;
    }
    NSString *notificationStr = nil;
    NSString *notiType = nil;
    if (reason == ContanctsRequestDidReceive) {
        notificationStr = [NSString stringWithFormat:@"friend request from：%@",conversationId];
        notiType = SYSTEM_NOTI_TYPE_CONTANCTSREQUEST;
    }
    if (reason == GroupInvitationDidReceive) {
        notificationStr = [NSString stringWithFormat:@"Add group invitation from：%@",userName];
        notiType = SYSTEM_NOTI_TYPE_GROUPINVITATION;
    }
    if (reason == JoinGroupRequestDidReceive) {
        notificationStr = [NSString stringWithFormat:@"Join the group application from：%@",userName];
        notiType = SYSTEM_NOTI_TYPE_JOINGROUPREQUEST;
    }
    if (self.systemNotiDelegate && [self.systemNotiDelegate respondsToSelector:@selector(requestDidReceiveShowMessage:requestUser:reason:)]) {
        NSString *tempStr = [self.systemNotiDelegate requestDidReceiveShowMessage:conversationId requestUser:userName reason:reason];
        // 空字符串返回不做操作 / nil：默认操作 / 有自定义值其他长度值使用自定义值
        if (tempStr) {
            if ([tempStr isEqualToString:@""]) {
                return;
            } else if (tempStr.length > 0) {
                notificationStr = tempStr;
            }
        }
    }
    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc]initWithText:notificationStr];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:EaseSYSTEMNOTIFICATIONID from:userName to:AgoraChatClient.sharedClient.currentUsername body:body ext:nil];
    message.timestamp = [self getLatestMsgTimestamp];
    message.isRead = NO;
    message.chatType = AgoraChatTypeChat;
    message.direction = AgoraChatMessageDirectionReceive;
    AgoraChatConversation *notiConversation = [[AgoraChatClient sharedClient].chatManager getConversation:message.conversationId type:AgoraChatConversationTypeChat createIfNotExist:YES];
    NSDictionary *ext = nil;
    if (self.systemNotiDelegate && [self.systemNotiDelegate respondsToSelector:@selector(requestDidReceiveConversationExt:requestUser:reason:)]) {
        ext = [self.systemNotiDelegate requestDidReceiveConversationExt:conversationId requestUser:userName reason:reason];
    } else {
        ext = @{SYSTEM_NOTI_TYPE:notiType};
    }
    [notiConversation setExt:ext];
    [notiConversation insertMessage:message error:nil];
    [self _resetConversationsUnreadCount];
    //刷新会话列表
    [[NSNotificationCenter defaultCenter] postNotificationName:CONVERSATIONLIST_UPDATE object:nil];
}

//加好友，加群 成功通知
- (void)notificationMsg:(NSString *)itemId aUserName:(NSString *)aUserName conversationType:(AgoraChatConversationType)aType
{
    return;
    AgoraChatConversationType conversationType = aType;
    AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:itemId type:conversationType createIfNotExist:YES];
    AgoraChatTextMessageBody *body;
    NSString *to = itemId;
    AgoraChatMessage *message;
    if (conversationType == AgoraChatTypeChat) {
        body = [[AgoraChatTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"You and %@ have become friends, start chatting",aUserName]];
        message = [[AgoraChatMessage alloc] initWithConversationID:to from:AgoraChatClient.sharedClient.currentUsername to:to body:body ext:@{MSG_EXT_NEWNOTI:NOTI_EXT_ADDFRIEND}];
    } else if (conversationType == AgoraChatTypeGroupChat) {
        if ([aUserName isEqualToString:AgoraChatClient.sharedClient.currentUsername]) {
            body = [[AgoraChatTextMessageBody alloc] initWithText:@"You have joined the group, start speaking"];
        } else {
            body = [[AgoraChatTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"%@ joined the group chat",aUserName]];
        }
        message = [[AgoraChatMessage alloc] initWithConversationID:to from:aUserName to:to body:body ext:@{MSG_EXT_NEWNOTI:NOTI_EXT_ADDGROUP}];
    }
    message.chatType = (AgoraChatType)conversation.type;
    message.isRead = YES;
    [conversation insertMessage:message error:nil];
    //Refresh the conversation list
    [[NSNotificationCenter defaultCenter] postNotificationName:CONVERSATIONLIST_UPDATE object:nil];
}
*/

//Latest message time
- (long long)getLatestMsgTimestamp
{
    return [[NSDate new] timeIntervalSince1970] * 1000;
}

#pragma mark - AgoraChatMultiDevicesDelegate

- (void)multiDevicesContactEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent
                                  username:(NSString *)aTarget
                                       ext:(NSString *)aExt
{
    __weak typeof(self) weakself = self;
    if (aEvent == AgoraChatMultiDevicesEventContactAccept || aEvent == AgoraChatMultiDevicesEventContactDecline) {
        AgoraChatConversation *systemConversation = [AgoraChatClient.sharedClient.chatManager getConversation:EaseSYSTEMNOTIFICATIONID type:-1 createIfNotExist:NO];
        [systemConversation loadMessagesStartFromId:nil count:systemConversation.unreadMessagesCount searchDirection:AgoraChatMessageSearchDirectionUp completion:^(NSArray *aMessages, AgoraChatError *aError) {
            BOOL hasUnreadMsg = NO;
            for (AgoraChatMessage *message in aMessages) {
                if (message.isRead == NO && message.chatType == AgoraChatTypeChat) {
                    message.isRead = YES;
                    hasUnreadMsg = YES;
                }
            }
            if (hasUnreadMsg) {
                [weakself _resetConversationsUnreadCount];
            }
        }];
    }
}

- (void)multiDevicesGroupEventDidReceive:(AgoraChatMultiDevicesEvent)aEvent
                                 groupId:(NSString *)aGroupId
                                     ext:(id)aExt
{
    __weak typeof(self) weakself = self;
    if (aEvent == AgoraChatMultiDevicesEventGroupInviteDecline || aEvent == AgoraChatMultiDevicesEventGroupInviteAccept || aEvent == AgoraChatMultiDevicesEventGroupApplyAccept || aEvent == AgoraChatMultiDevicesEventGroupApplyDecline) {
        AgoraChatConversation *systemConversation = [AgoraChatClient.sharedClient.chatManager getConversation:EaseSYSTEMNOTIFICATIONID type:-1 createIfNotExist:NO];
        [systemConversation loadMessagesStartFromId:nil count:systemConversation.unreadMessagesCount searchDirection:AgoraChatMessageSearchDirectionUp completion:^(NSArray *aMessages, AgoraChatError *aError) {
            BOOL hasUnreadMsg = NO;
            for (AgoraChatMessage *message in aMessages) {
                if (message.isRead == NO && message.chatType == AgoraChatTypeGroupChat) {
                    message.isRead = YES;
                    hasUnreadMsg = YES;
                }
            }
            if (hasUnreadMsg) {
                [weakself _resetConversationsUnreadCount];
            }
        }];
    }
}

#pragma mark - 未读数变化

//Session flag read
- (void)markAllMessagesAsReadWithConversation:(AgoraChatConversation *)conversation
{
    if (conversation && conversation.unreadMessagesCount > 0) {
        [conversation markAllMessagesAsRead:nil];
        [self _resetConversationsUnreadCount];
    }
}

- (void)_resetConversationsUnreadCount
{
    NSInteger unreadCount = 0;
    NSArray *conversationList = [AgoraChatClient.sharedClient.chatManager getAllConversations];
    for (AgoraChatConversation *conversation in conversationList) {
        if (conversation.isChatThread == NO) {
            if ([conversation.conversationId isEqualToString:_currentConversationId]) {
                continue;
            }
            unreadCount += conversation.unreadMessagesCount;
        }
    }
    _currentUnreadCount = unreadCount;
    [self coversationsUnreadCountUpdate:unreadCount];
}

#pragma mark - multicast

//Session unread
- (void)coversationsUnreadCountUpdate:(NSInteger)unreadCount
{
    EaseMulticastDelegateEnumerator *multicastDelegates = [self.delegates delegateEnumerator];
    for (EaseMulticastDelegateNode *node in [multicastDelegates getDelegates]) {
        id<EaseChatKitManagerDelegate> delegate = (id<EaseChatKitManagerDelegate>)node.delegate;
        if ([delegate respondsToSelector:@selector(conversationsUnreadCountUpdate:)])
            [delegate conversationsUnreadCountUpdate:unreadCount];
    }
}
/*
#pragma mark - 系统通知

//是否需要系统通知
- (BOOL)isNeedsSystemNoti
{
    if (self.systemNotiDelegate && [self.systemNotiDelegate respondsToSelector:@selector(isNeedsSystemNotification)]) {
        return [self.systemNotiDelegate isNeedsSystemNotification];
    }
    return YES;
}

//收到请求返回展示信息
- (NSString*)requestDidReceiveShowMessage:(NSString *)conversationId requestUser:(NSString *)requestUser reason:(EaseChatKitCallBackReason)reason
{
    if (self.systemNotiDelegate && [self.systemNotiDelegate respondsToSelector:@selector(requestDidReceiveShowMessage:requestUser:reason:)]) {
        return [self.systemNotiDelegate requestDidReceiveShowMessage:conversationId requestUser:requestUser reason:reason];
    }
    return @"";
}

//收到请求返回扩展信息
- (NSDictionary *)requestDidReceiveConversationExt:(NSString *)conversationId requestUser:(NSString *)requestUser reason:(EaseChatKitCallBackReason)reason
{
    if (self.systemNotiDelegate && [self.systemNotiDelegate respondsToSelector:@selector(requestDidReceiveConversationExt:requestUser:reason:)]) {
        return [self.systemNotiDelegate requestDidReceiveConversationExt:conversationId requestUser:requestUser reason:reason];
    }
    return [[NSDictionary alloc]init];
}
*/
@end

@implementation EaseChatKitManager (currentUnreadCount)

- (void)setConversationId:(NSString *)conversationId
{
    _currentConversationId = conversationId;
}

@end
