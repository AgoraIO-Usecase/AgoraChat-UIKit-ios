//
//  AgoraThreadChatViewController.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/19.
//

#import "EaseChatViewController.h"

@interface EaseThreadChatViewController : EaseChatViewController

- (instancetype)initThreadChatViewControllerWithCoversationid:(NSString *)conversationId chatViewModel:(EaseChatViewModel *)viewModel parentMessageId:(NSString *)parentMessageId model:(EaseMessageModel *)model;

@end

