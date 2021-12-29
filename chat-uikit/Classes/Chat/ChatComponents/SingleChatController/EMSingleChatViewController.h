//
//  EMSingleChatViewController.h
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseChatViewController.h"
#import "EaseChatViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMSingleChatViewController : EaseChatViewController

- (instancetype)initSingleChatViewControllerWithCoversationid:(NSString *)conversationId
                                                chatViewModel:(EaseChatViewModel *)viewModel;

/*
- (void)sendCallEndMsg:(NSNotification*)noti;
*/
 
@end

NS_ASSUME_NONNULL_END
