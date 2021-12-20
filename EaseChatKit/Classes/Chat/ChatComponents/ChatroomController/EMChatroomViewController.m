//
//  EMChatroomViewController.m
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EMChatroomViewController.h"
#import "EaseAlertController.h"
#import "EaseAlertView.h"
#import "UIViewController+HUD.h"
#import "EaseChatViewController+EaseUI.h"

@interface EMChatroomViewController ()

@end

@implementation EMChatroomViewController

- (instancetype)initChatRoomViewControllerWithCoversationid:(NSString *)conversationId
                                              chatViewModel:(EaseChatViewModel *)viewModel
{
    return [super initChatViewControllerWithCoversationid:conversationId
                       conversationType:AgoraChatConversationTypeChatRoom
                          chatViewModel:(EaseChatViewModel *)viewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _joinChatroom];
}

#pragma mark - Private

- (void)_joinChatroom
{
    __weak typeof(self) weakself = self;
    [self showHudInView:self.view hint:@"join chatroom..."];
    [[AgoraChatClient sharedClient].roomManager joinChatroom:self.currentConversation.conversationId completion:^(AgoraChatroom *aChatroom, AgoraChatError *aError) {
        [weakself hideHud];
        if (aError) {
            [EaseAlertController showErrorAlert:@"join chatroom fail."];
        }
    }];
}

@end
