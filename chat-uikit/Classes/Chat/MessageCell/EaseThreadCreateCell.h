//
//  EaseThreadCreateCell.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/11.
//

#import <UIKit/UIKit.h>
#import "EaseMessageModel.h"
#import "EaseChatMessageBubbleView.h"
#import "EaseChatViewModel.h"


typedef NS_ENUM(NSUInteger, EMThreadHeaderType) {
    EMThreadHeaderTypeCreate,
    EMThreadHeaderTypeEdit,
    EMThreadHeaderTypeDisplay,
    EMThreadHeaderTypeDisplayNoMessage,
};

@protocol EaseThreadCreateCellDelegate;

@interface EaseThreadCreateCell : UITableViewCell

@property (nonatomic, strong) UITextField *threadNameField;

@property (nonatomic, weak) id<EaseThreadCreateCellDelegate> delegate;

@property (nonatomic, strong, readonly) EaseChatMessageBubbleView *bubbleView;

@property (nonatomic) AgoraChatMessageDirection direction;

@property (nonatomic, strong) EaseMessageModel *model;

@property (nonatomic, strong) EaseMessageModel *quoteModel;

+ (NSString *)cellIdentifierType:(AgoraChatMessageType)aType;

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType
                        displayType:(EMThreadHeaderType)type
                    viewModel:(EaseChatViewModel*)viewModel;

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType
                        displayType:(EMThreadHeaderType)type
                    viewModel:(EaseChatViewModel*)viewModel model:(EaseMessageModel *)model;

- (void)changeThreadName:(NSString *)text;

@end


@protocol EaseThreadCreateCellDelegate <NSObject>

@optional

- (void)messageCellDidSelected:(EaseThreadCreateCell *)aCell;

- (void)avatarDidSelected:(EaseMessageModel *)model;

- (void)textFieldEndText:(NSString *)text;

- (void)textFieldShouldReturn:(NSString *)text;

@end
