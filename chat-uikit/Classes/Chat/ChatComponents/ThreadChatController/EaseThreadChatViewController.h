//
//  AgoraThreadChatViewController.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/19.
//

#import "EaseChatViewController.h"

@interface EaseThreadChatViewController : EaseChatViewController

@property (nonatomic,strong) EaseMessageModel *model;

@property (nonatomic, strong) AgoraChatGroup *group;

@property (nonatomic) NSString *owner;

@property (nonatomic, strong) NSString *isAdmin;//admin 1 unadmin 0

- (instancetype)initThreadChatViewControllerWithCoversationid:(NSString *)conversationId chatViewModel:(EaseChatViewModel *)viewModel parentMessageId:(NSString *)parentMessageId model:(EaseMessageModel *)model;

@end

