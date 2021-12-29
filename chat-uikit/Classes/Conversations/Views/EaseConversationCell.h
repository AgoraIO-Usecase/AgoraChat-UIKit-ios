//
//  EaseConversationCell.h
//  EaseChatKit
//
//  Created by XieYajie on 2019/1/8.
//  Update © 2020 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseConversationViewModel.h"
#import "EaseConversationModel.h"

@class EaseBadgeView;
@interface EaseConversationCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *avatarView;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *detailLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIImageView *noDisturbView;
@property (nonatomic, strong, readonly) UIImageView *topView;
@property (nonatomic, strong, readonly) EaseBadgeView *badgeLabel;
@property (nonatomic, strong) EaseConversationModel *model;

+ (EaseConversationCell *)tableView:(UITableView *)tableView identifier:(NSString *)cellIdentifier;

- (instancetype)initWithConversationsViewModel:(EaseConversationViewModel*)viewModel
                                    identifier:(NSString *)identifier;

@end
