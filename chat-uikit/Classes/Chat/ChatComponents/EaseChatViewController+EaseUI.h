//
//  EaseChatViewController+EaseUI.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/12/2.
//  Copyright © 2020 djp. All rights reserved.
//

#import "EaseChatViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatViewController (EaseUI)
- (instancetype)initChatViewControllerWithCoversationid:(NSString *)conversationId
                                        conversationType:(AgoraChatConversationType)conType
                                            chatViewModel:(EaseChatViewModel *)viewModel;

- (instancetype)initChatViewControllerWithCoversationid:(NSString *)conversationId
                                        conversationType:(AgoraChatConversationType)conType
                                            chatViewModel:(EaseChatViewModel *)viewModel isChatThread:(BOOL)isChatThread parentMessageId:(NSString *)parentMessageId;
@end

NS_ASSUME_NONNULL_END
