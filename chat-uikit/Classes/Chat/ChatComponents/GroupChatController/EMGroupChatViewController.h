//
//  EMGroupChatViewController.h
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseChatViewController.h"
#import "EaseChatViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMGroupChatViewController : EaseChatViewController

- (instancetype)initGroupChatViewControllerWithCoversationid:(NSString *)conversationId
                                               chatViewModel:(EaseChatViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
