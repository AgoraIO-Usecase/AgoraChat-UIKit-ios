//
//  EaseMessageCell.h
//  EaseChat
//
//  Created by XieYajie on 2019/1/25.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMessageModel.h"
#import "EaseChatMessageBubbleView.h"
#import "EaseChatViewModel.h"

#define avatarLonger 28
#define componentSpacing 8

NS_ASSUME_NONNULL_BEGIN

@protocol EaseMessageCellDelegate;
@interface EaseMessageCell : UITableViewCell

@property (nonatomic, weak) id<EaseMessageCellDelegate> delegate;

@property (nonatomic, strong, readonly) EaseChatMessageBubbleView *bubbleView;

@property (nonatomic) AgoraChatMessageDirection direction;

@property (nonatomic, strong) EaseMessageModel *model;

+ (NSString *)cellIdentifierWithDirection:(AgoraChatMessageDirection)aDirection
                                     type:(AgoraChatMessageType)aType;

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                    chatType:(AgoraChatType)aChatType
                  messageType:(AgoraChatMessageType)aMessageType
                    viewModel:(EaseChatViewModel*)viewModel;

@end


@protocol EaseMessageCellDelegate <NSObject>

@optional
- (void)messageCellDidSelected:(EaseMessageCell *)aCell;
- (void)messageCellDidLongPress:(UITableViewCell *)aCell cgPoint:(CGPoint)point;
- (void)messageCellDidResend:(EaseMessageModel *)aModel;
- (void)messageReadReceiptDetil:(EaseMessageCell *)aCell;

- (void)avatarDidSelected:(EaseMessageModel *)model;
- (void)avatarDidLongPress:(EaseMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
