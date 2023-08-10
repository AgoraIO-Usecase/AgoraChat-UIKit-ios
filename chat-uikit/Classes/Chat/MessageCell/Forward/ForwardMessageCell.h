//
//  ForwardMessageCell.h
//  AgoraChatCallKit
//
//  Created by 朱继超 on 2023/7/27.
//

#import <UIKit/UIKit.h>
#import "ForwardContainer.h"
#import "ForwardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForwardMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) ForwardContainer *containerView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic) ForwardModel *model;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style messages:(NSArray <AgoraChatMessage *>*)messages;

- (void)startVoiceAnimation;

- (void)stopVoiceAnimation;

- (void)updateLayout;

@end

NS_ASSUME_NONNULL_END
