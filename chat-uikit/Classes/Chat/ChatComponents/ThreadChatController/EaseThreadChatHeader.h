//
//  EaseThreadChatHeader.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/30.
//

#import <UIKit/UIKit.h>
#import "EaseChatViewModel.h"
#import "EaseMessageModel.h"
#import "EaseThreadCreateCell.h"

@protocol EaseThreadChatHeaderDelegate <NSObject>

- (void)headerMessageDidSelected:(EaseThreadCreateCell *)aCell;

- (void)headerAvatarClick:(EaseMessageModel *)model;

@end

@interface EaseThreadChatHeader : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *threadName;

@property (nonatomic, weak) id <EaseThreadChatHeaderDelegate>delegate;

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType displayType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel model:(EaseMessageModel *)model;

@end


