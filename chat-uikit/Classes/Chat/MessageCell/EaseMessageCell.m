//
//  EaseMessageCell.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/25.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseMessageCell.h"

#import "EaseMessageStatusView.h"

#import "EMMsgTextBubbleView.h"
#import "EMMsgImageBubbleView.h"
#import "EMMsgAudioBubbleView.h"
#import "EMMsgVideoBubbleView.h"
#import "EMMsgLocationBubbleView.h"
#import "EMMsgFileBubbleView.h"
#import "EMMsgExtGifBubbleView.h"
#import "MessageCombineBubbleView.h"
#import "UIImageView+EaseWebCache.h"
#import "EaseMessageCell+Category.h"
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))
#import "EMAudioPlayerUtil.h"
#import "EMMaskHighlightViewDelegate.h"
#import "EMMessageReactionView.h"
//#import "AgoraChatURLPreviewBubbleView.h"
#import "MessageQuoteView.h"

@interface EaseMessageCell() <EMMaskHighlightViewDelegate>

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) EaseMessageStatusView *statusView;

@property (nonatomic, strong) UIButton *readReceiptBtn;

@property (nonatomic, strong) EMMessageReactionView *reactionView;

@property (nonatomic, strong) MessageQuoteView *quoteView;

@property (nonatomic, strong) UIView *quoteContainer;

@property (nonatomic, assign) AgoraChatType chatType;

@property (nonatomic, strong) UILabel *editState;

@property (nonatomic, strong) UIImageView *checkBox;

@end

@implementation EaseMessageCell

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             chatType:(AgoraChatType)aChatType
                           messageType:(AgoraChatMessageType)aMessageType
                            viewModel:(EaseChatViewModel*)viewModel

{
    NSString *identifier = [self.class cellIdentifierWithDirection:aDirection type:aMessageType];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        _direction = aDirection;
        _viewModel = viewModel;
        _chatType = aChatType;
        if (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left) {
            _direction = AgoraChatMessageDirectionReceive;
        }
        [self _setupViewsWithType:aMessageType chatType:aChatType];
    }
    [self.bubbleView setupBubbleBackgroundImage];
    return self;
}

#pragma mark - Class Methods

+ (NSString *)cellIdentifierWithDirection:(AgoraChatMessageDirection)aDirection
                                     type:(AgoraChatMessageType)aType
{
    NSString *identifier = @"EMMsgCellDirectionSend";
    if (aDirection == AgoraChatMessageDirectionReceive) {
        identifier = @"EMMsgCellDirectionRecv";
    }
    
    if (aType == AgoraChatMessageTypeText || aType == AgoraChatMessageTypeExtCall ||
        aType ==  AgoraChatMessageTypeExtURLPreview) {
        identifier = [NSString stringWithFormat:@"%@Text", identifier];
    } else if (aType == AgoraChatMessageTypeImage) {
        identifier = [NSString stringWithFormat:@"%@Image", identifier];
    } else if (aType == AgoraChatMessageTypeVoice) {
        identifier = [NSString stringWithFormat:@"%@Voice", identifier];
    } else if (aType == AgoraChatMessageTypeVideo) {
        identifier = [NSString stringWithFormat:@"%@Video", identifier];
    } else if (aType == AgoraChatMessageTypeLocation) {
        identifier = [NSString stringWithFormat:@"%@Location", identifier];
    } else if (aType == AgoraChatMessageTypeFile) {
        identifier = [NSString stringWithFormat:@"%@File", identifier];
    } else if (aType == AgoraChatMessageTypeExtGif) {
        identifier = [NSString stringWithFormat:@"%@ExtGif", identifier];
    } else if (aType == AgoraChatMessageTypeCustom) {
        identifier = [NSString stringWithFormat:@"%@Custom", identifier];
    } else if (aType == AgoraChatMessageTypeExtURLPreview) {
        identifier = [NSString stringWithFormat:@"%@URLPreview", identifier];
    } else if (aType == AgoraChatMessageBodyTypeCombine) {
        identifier = [NSString stringWithFormat:@"%@Combine", identifier];
    }
    return identifier;
}

#pragma mark - Subviews

- (void)_setupViewsWithType:(AgoraChatMessageType)aType chatType:(AgoraChatType)chatType
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    _avatarView = [[UIImageView alloc] init];
    _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarView.backgroundColor = [UIColor clearColor];
    _avatarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarDidSelect:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(avatarLongPressAction:)];
    [_avatarView addGestureRecognizer:tap];
    [_avatarView addGestureRecognizer:longPress];
    if (_viewModel.avatarStyle == RoundedCorner) {
        _avatarView.layer.cornerRadius = _viewModel.avatarCornerRadius;
    }
    if (_viewModel.avatarStyle == Circular) {
        _avatarView.layer.cornerRadius = avatarLonger / 2;
    }
    if (_viewModel.avatarStyle != Rectangular) {
        _avatarView.clipsToBounds = _avatarView.clipsToBounds = YES;;
    }
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:@"PingFang SC" size:10.0];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _bubbleView = [self getBubbleViewWithType:aType];
    if (_bubbleView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
        [_bubbleView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewLongPressAction:)];
        [_bubbleView addGestureRecognizer:longPress];
    }
    _bubbleView.userInteractionEnabled = YES;
    _bubbleView.clipsToBounds = YES;
    [self.contentView addSubview:self.checkBox];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.quoteView];
    [self.contentView addSubview:self.bubbleView];

    
    self.bubbleView.maxBubbleWidth = [self maxBubbleViewWidth];
    
    __weak typeof(self)weakSelf = self;
    _reactionView = [[EMMessageReactionView alloc] init];
    _reactionView.direction = _direction;
    _reactionView.onClick = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(messageCellDidClickReactionView:)]) {
            [weakSelf.delegate messageCellDidClickReactionView:weakSelf.model];
        }
    };
    [self.contentView addSubview:self.reactionView];
    [self.contentView addSubview:self.editState];
    self.checkBox.hidden = YES;
    [self.checkBox Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.width.height.Ease_equalTo(28);
        make.bottom.equalTo(self.bubbleView);
        make.left.equalTo(self.contentView).offset(5);
    }];
    if (self.direction == AgoraChatMessageDirectionReceive) {
        if (_viewModel.displayReceivedAvatar) {
            [_avatarView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
                if (self.model.editMode) {
                    make.left.equalTo(self.checkBox.ease_right).offset(5);
                } else {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                }
                make.width.height.equalTo(@(avatarLonger));
            }];
        }
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        if (_viewModel.displayReceiverName) {
            [_nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(componentSpacing);
                if (_viewModel.displayReceivedAvatar) {
                    make.left.equalTo(self.avatarView.ease_right).offset(2 * componentSpacing);
                } else {
                    if (!self.model.editMode) {
                        make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                    } else {
                        make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                    }
                }
                make.right.equalTo(self.contentView).offset(-componentSpacing);
            }];
        }
        [_quoteView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (_viewModel.displayReceiverName) {
                make.top.equalTo(self.nameLabel.ease_bottom).offset(componentSpacing / 2);
            } else {
                make.top.equalTo(self.contentView).offset(componentSpacing / 2);
            }
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
            } else {
                if (!self.model.editMode) {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                }
            }
            make.width.lessThanOrEqualTo(@(EMScreenWidth*0.75-24));
            make.height.Ease_equalTo(self.model.quoteHeight);
        }];
        
        [_bubbleView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.quoteView.ease_bottom).offset(replySpace);
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
            } else {
                if (!self.model.editMode) {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                }
            }
            
            if (self.bubbleView.type == AgoraChatMessageTypeFile) {
                make.width.equalTo(@(self.bubbleView.maxBubbleWidth));
            } else {
                make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
            }
            
//            if (self.reactionView.reactionList.count > 0) {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing-18);
//            } else {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
//            }
        }];
        [_reactionView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(self.bubbleView);
            make.width.Ease_equalTo(200);
            make.top.equalTo(self.bubbleView.ease_bottom).offset(-componentSpacing);
            make.height.Ease_equalTo(self.reactionView.reactionList.count >= 0 ? 28:0);
        }];
        [self.editState Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (self.reactionView.reactionList.count > 0) {
                make.bottom.equalTo(self.contentView.ease_bottom).offset(-8);
            } else {
                make.bottom.equalTo(self.contentView.ease_bottom).offset(5);
            }
            make.left.equalTo(self.bubbleView.ease_left);
            make.height.equalTo(@20);
            make.width.equalTo(@40);
        }];
    } else {
        if (_viewModel.displaySentAvatar) {
            [_avatarView Ease_makeConstraints:^(EaseConstraintMaker *make) {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
                make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
                make.width.height.equalTo(@(avatarLonger));
            }];
        }
        
        _nameLabel.textAlignment = NSTextAlignmentRight;
        if (_viewModel.displaySentName) {
            [_nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(componentSpacing/2);
                if (_viewModel.displaySentAvatar) {
                    make.right.equalTo(self.avatarView.ease_left).offset(-2 * componentSpacing);
                } else {
                    make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
                }
                make.left.equalTo(self.contentView).offset(componentSpacing);
            }];
        }
        [_quoteView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (_viewModel.displayReceiverName) {
                make.top.equalTo(self.nameLabel.ease_bottom).offset(componentSpacing / 2);
            } else {
                make.top.equalTo(self.contentView).offset(componentSpacing/2);
            }
            make.width.lessThanOrEqualTo(@(EMScreenWidth*0.75-24));
            if (_viewModel.displaySentAvatar) {
                make.right.equalTo(self.avatarView.ease_left).offset(-componentSpacing);
            } else {
                make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
            }
            make.height.Ease_equalTo(self.model.quoteHeight);
        }];
        [_bubbleView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.quoteView.ease_bottom).offset(replySpace);
            
            if (_viewModel.displaySentAvatar) {
                make.right.equalTo(self.avatarView.ease_left).offset(-componentSpacing);
            } else {
                make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
            }
            
            if (self.bubbleView.type == AgoraChatMessageTypeFile) {
                make.width.equalTo(@(self.bubbleView.maxBubbleWidth));
            } else {
                make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
            }
//            if (self.reactionView.reactionList.count > 0) {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing-18);
//            } else {
//                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
//            }
        }];
        
        [_reactionView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.right.equalTo(self.bubbleView);
            make.width.Ease_equalTo(200);
            make.top.equalTo(self.bubbleView.ease_bottom).offset(-componentSpacing);
            make.height.Ease_equalTo(self.reactionView.reactionList.count >= 0 ? 28:0);
        }];
        
        [self.editState Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (self.reactionView.reactionList.count > 0) {
                make.bottom.equalTo(self.contentView.ease_bottom).offset(-8);
            } else {
                make.bottom.equalTo(self.contentView.ease_bottom).offset(5);
            }
            make.right.equalTo(self.bubbleView.ease_right);
            make.height.equalTo(@20);
            make.width.equalTo(@40);
        }];
    }

    _statusView = [[EaseMessageStatusView alloc] init];
    [self.contentView addSubview:_statusView];
    if (self.direction == AgoraChatMessageDirectionSend || (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left)) {
        [_statusView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.bubbleView);
            if (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left) {
                make.left.equalTo(self.bubbleView.ease_right).offset(componentSpacing);
            } else {
                make.right.equalTo(self.bubbleView.ease_left).offset(-componentSpacing);
            }
            make.width.height.equalTo(@20);
        }];
        __weak typeof(self) weakself = self;
        [_statusView setResendCompletion:^{
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(messageCellDidResend:)]) {
                [weakself.delegate messageCellDidResend:weakself.model];
            }
        }];
    } else {
        _statusView.clipsToBounds = YES;
        _statusView.layer.cornerRadius = 4;
        [_statusView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.bubbleView).offset(-8);
            make.left.equalTo(self.bubbleView.ease_right).offset(8);
            make.width.height.equalTo(@8);
        }];
    }
    
    [self setCellIsReadReceipt];
}



- (void)getBubbleWidth:(EaseMessageModel *)model {
    if (model.message.chatThread) {
        self.bubbleView.maxBubbleWidth = KEMThreadBubbleWidth + 24;
    } else {
        CGFloat bubbleViewWidth = self.contentView.bounds.size.width - 4 * componentSpacing;
        if (_viewModel.displayReceivedAvatar) {
            bubbleViewWidth -= (avatarLonger + componentSpacing);
        }
        if (_viewModel.displaySentAvatar) {
            bubbleViewWidth -= (avatarLonger + componentSpacing);
        };
        self.bubbleView.maxBubbleWidth = bubbleViewWidth;
    }
}

- (void)threadBubbleAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toThreadChat:channelId:)]) {
        [self.delegate toThreadChat:self.model];
    }
}

- (CGFloat)maxBubbleViewWidth
{
    CGFloat bubbleViewWidth = self.contentView.bounds.size.width - 4 * componentSpacing;
    if (_viewModel.displayReceivedAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    }
    if (_viewModel.displaySentAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    };
    
    return bubbleViewWidth * 0.8;
}

- (void)setCellIsReadReceipt{
    _readReceiptBtn = [[UIButton alloc]init];
    _readReceiptBtn.layer.cornerRadius = 5;
    _readReceiptBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _readReceiptBtn.backgroundColor = [UIColor lightGrayColor];
    [_readReceiptBtn.titleLabel setTextColor:[UIColor whiteColor]];
    _readReceiptBtn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
    [_readReceiptBtn addTarget:self action:@selector(readReceiptDetilAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_readReceiptBtn];
    if(self.direction == AgoraChatMessageDirectionSend) {
        [_readReceiptBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(self.bubbleView.ease_bottom).offset(2);
            make.right.equalTo(self.bubbleView.ease_right);
            make.width.equalTo(@130);
            make.height.equalTo(@15);
        }];
    }
}

- (UILabel *)editState {
    if (!_editState) {
        _editState = [[UILabel alloc]init];
        _editState.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _editState.textColor = [UIColor grayColor];
        _editState.backgroundColor = [UIColor clearColor];
        _editState.textAlignment = 0;
    }
    return _editState;
}

- (UIImageView *)checkBox {
    if (!_checkBox) {
        _checkBox = [[UIImageView alloc] init];
        self.checkBox.image = [UIImage easeUIImageNamed:@"multiple_select"];
    }
    return _checkBox;
}

- (EaseChatMessageBubbleView *)getBubbleViewWithType:(AgoraChatMessageType)aType
{
    EaseChatMessageBubbleView *bubbleView = [EaseChatMessageBubbleView new];
    switch (aType) {
        case AgoraChatMessageTypeText:
        case AgoraChatMessageTypeExtCall:
        case AgoraChatMessageTypeExtURLPreview:
            bubbleView = [[EMMsgTextBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeImage:
            bubbleView = [[EMMsgImageBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeVoice:
            bubbleView = [[EMMsgAudioBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeVideo:
            bubbleView = [[EMMsgVideoBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeLocation:
            bubbleView = [[EMMsgLocationBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeFile:
            bubbleView = [[EMMsgFileBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeExtGif:
            bubbleView = [[EMMsgExtGifBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeCustom:
            bubbleView = [[EaseChatMessageBubbleView alloc] initWithDirection:self.direction type:aType
                viewModel:_viewModel];
            break;
        case AgoraChatMessageTypeCombine:
            bubbleView = [[MessageCombineBubbleView alloc] initWithDirection:self.direction type:aType
                viewModel:_viewModel];
            break;
        default:
            break;
    }
    
    return bubbleView;
}


#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    _model = model;
    model.thread = nil;
    if (model.direction == AgoraChatMessageDirectionSend) {
        [self.statusView setSenderStatus:model.message.status isReadAcked:model.message.chatType == AgoraChatTypeChat ? model.message.isReadAcked : NO isDeliverAcked:model.message.chatType == AgoraChatTypeChat ? model.message.isDeliverAcked : NO ];
    } else {
        if (model.type == AgoraChatMessageBodyTypeVoice) {
            if (model.message.isChatThreadMessage == YES) {
                NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EMListenHashMap"] mutableCopy];
                model.message.isListened = [dic[model.message.messageId] boolValue];
            }
            self.statusView.hidden = model.message.isListened;
        }
    }
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(showName)] && model.userDataProfile.showName) {
        self.nameLabel.text = model.userDataProfile.showName;
    } else {
        self.nameLabel.text = model.message.from;
    }
    
    BOOL isCustomAvatar = NO;
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(defaultAvatar)]) {
        if (model.userDataProfile.defaultAvatar) {
            _avatarView.image = model.userDataProfile.defaultAvatar;
            isCustomAvatar = YES;
        }
    }
    if (_model.userDataProfile && [_model.userDataProfile respondsToSelector:@selector(avatarURL)]) {
        if ([_model.userDataProfile.avatarURL length] > 0) {
            [_avatarView Ease_setImageWithURL:[NSURL URLWithString:_model.userDataProfile.avatarURL]
                               placeholderImage:[UIImage easeUIImageNamed:@"default_avatar"]];
            isCustomAvatar = YES;
        }
    }
    if (!isCustomAvatar) {
        _avatarView.image = [UIImage easeUIImageNamed:@"default_avatar"];
    }
    if (model.message.isNeedGroupAck) {
        self.readReceiptBtn.hidden = NO;
        [self.readReceiptBtn setTitle:[NSString stringWithFormat:@"Read receipt, read user（%d）",_model.message.groupAckCount] forState:UIControlStateNormal];
    } else {
        self.readReceiptBtn.hidden = YES;
    }
    
    
    if (model.message.body.type == AgoraChatMessageBodyTypeText && self.model.quoteContent.length ) {
        NSDictionary *quoteInfo = model.message.ext[@"msgQuote"];
        self.quoteView.content.attributedText = model.quoteContent;
        self.quoteView.hidden = NO;
    } else {
        self.quoteView.content.attributedText = nil;
        self.quoteView.hidden = YES;
    }
    
    self.bubbleView.model = model;
    _reactionView.reactionList = model.message.reactionList;
    if (model.message.body.operatorId && ![model.message.body.operatorId isEqualToString:@""]) {
        if (model.editSymbol != nil && !IsStringEmpty(model.editSymbol.string)) {
            self.editState.attributedText = model.editSymbol;
        } else {
            self.editState.attributedText = [[NSAttributedString alloc] initWithString:@"Edited" attributes:@{
                NSForegroundColorAttributeName: [UIColor grayColor],
                NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]
            }];
        }
    } else {
        self.editState.attributedText = nil;
    }
    NSString *imageName = @"multiple_normal";
    if (model.selected) {
        imageName = @"multiple_select";
    }
    self.checkBox.image = [UIImage easeUIImageNamed:imageName];
    [self updateLayout];
    if (self.direction == AgoraChatMessageDirectionReceive) {
        self.avatarView.hidden = !self.viewModel.displayReceivedAvatar;
    } else {
        self.avatarView.hidden = !self.viewModel.displaySentAvatar;
    }
    
//    self.editState.hidden = [_model.message.body isKindOfClass:[AgoraChatTextMessageBody class]]&&((AgoraChatTextMessageBody *)_model.message.body).targetLanguages.count > 0;
}

- (void)showHighlight
{
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contentView.backgroundColor = [UIColor whiteColor];
    });
}

- (void)updateLayout
{
    NSDictionary *quoteInfo = self.model.message.ext[@"msgQuote"];
    self.reactionView.hidden = self.reactionView.reactionList.count <= 0;
    if (self.direction == AgoraChatMessageDirectionReceive) {
        [_avatarView Ease_updateConstraints:^(EaseConstraintMaker *make) {
            if (self.model.editMode) {
                make.left.equalTo(self.contentView).offset(40);
            } else {
                make.left.equalTo(self.contentView).offset(2 * componentSpacing);
            }
        }];
        [_nameLabel Ease_updateConstraints:^(EaseConstraintMaker *make) {
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(2 * componentSpacing);
            } else {
                if (!self.model.editMode) {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                }
            }
        }];
        [_quoteView Ease_updateConstraints:^(EaseConstraintMaker *make) {
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
            } else {
                if (!self.model.editMode) {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                }
            }
        }];
        [_bubbleView Ease_updateConstraints:^(EaseConstraintMaker *make) {
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
            } else {
                if (!self.model.editMode) {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.checkBox.ease_right).offset(2 * componentSpacing);
                }
            }
        }];
    }
    [self.quoteView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(self.model.quoteHeight);
    }];
    [self.bubbleView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.ease_bottom).offset(quoteInfo != nil ? self.model.quoteHeight+replySpace: componentSpacing);
    }];
    [self.avatarView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.bubbleView);
    }];
    [self.reactionView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(self.reactionView.reactionList.count >= 0 ? 28:0);
        if (self.reactionView.reactionList.count > 0) {
            make.top.equalTo(self.bubbleView.ease_bottom).offset(-componentSpacing);
        } else {
            make.top.equalTo(self.bubbleView.ease_bottom);
        }
    }];
    
    [self.editState Ease_updateConstraints:^(EaseConstraintMaker *make) {
        if (self.reactionView.reactionList.count > 0) {
            if ([_model.message.body isKindOfClass:[AgoraChatTextMessageBody class]] && ((AgoraChatTextMessageBody *)_model.message.body).targetLanguages.count > 0) {
                make.top.equalTo(self.bubbleView.ease_bottom).offset(25 + 14);
            } else {
                make.top.equalTo(self.bubbleView.ease_bottom).offset(5 + 14);
            }
        } else {
            if ([_model.message.body isKindOfClass:[AgoraChatTextMessageBody class]] && ((AgoraChatTextMessageBody *)_model.message.body).targetLanguages.count > 0) {
                make.top.equalTo(self.bubbleView.ease_bottom).offset(25);
            } else {
                make.top.equalTo(self.bubbleView.ease_bottom).offset(5);
            }
        }
    }];
    
    self.checkBox.hidden = !self.model.editMode;
}

- (MessageQuoteView *)quoteView
{
    if (!_quoteView) {
        _quoteView = [[MessageQuoteView alloc] init];
        _quoteView.userInteractionEnabled = YES;
        _quoteView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
        _quoteView.layer.cornerRadius = 12;
        [_quoteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onQuoteViewTap)]];
        [_quoteView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onQuoteViewLongPress:)]];
    }
    return _quoteView;
}

#pragma mark - Action

- (void)readReceiptDetilAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageReadReceiptDetil:)]) {
        [self.delegate messageReadReceiptDetil:self];
    }
}

//Avatar click
- (void)avatarDidSelect:(UITapGestureRecognizer *)aTap
{
    if (aTap.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidSelected:)]) {
            [self.delegate avatarDidSelected:_model];
        }
    }
}

//Avatar longPress
- (void)avatarLongPressAction:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidLongPress:)]) {
            [self.delegate avatarDidLongPress:self.model];
        }
    }
}

//Bubble view click
- (void)bubbleViewTapAction:(UITapGestureRecognizer *)aTap
{
    UIView *view = [self.bubbleView viewWithTag:777];
    CGPoint point = [aTap locationInView:self.contentView];
    if (view != nil && view.hidden == NO) {
        if (point.y > view.frame.origin.y) {
            if (aTap.state == UIGestureRecognizerStateEnded) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(toThreadChat:)]) {
                    [self.delegate toThreadChat:self.model];
                }
            }
        } else {
            if (aTap.state == UIGestureRecognizerStateEnded) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidSelected:)]) {
                    [self.delegate messageCellDidSelected:self];
                }
            }
        }
    } else {
        if (aTap.state == UIGestureRecognizerStateEnded) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidSelected:)]) {
                [self.delegate messageCellDidSelected:self];
            }
        }
    }
}

//Bubble view longPress
- (void)bubbleViewLongPressAction:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        if (self.model.type == AgoraChatMessageTypeText) {
            //EMMsgTextBubbleView *textBubbleView = (EMMsgTextBubbleView*)self.bubbleView;
            //textBubbleView.textLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:206/255.0 blue:243/255.0 alpha:1.0];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidLongPress:cgPoint:)]) {
            [self.delegate messageCellDidLongPress:self cgPoint:CGPointZero];
        }
    }
    //[aLongPress release];
}

- (NSArray<UIView *> *)maskHighlight {
    return @[_bubbleView, _reactionView, _avatarView];
}

//#pragma mark - EMMsgURLPreviewBubbleViewDelegate
//- (void)URLPreviewBubbleViewNeedLayout:(AgoraChatURLPreviewBubbleView *)view
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(messageCellNeedReload:)]) {
//        [_delegate messageCellNeedReload:self];
//    }
//}

#pragma mark - EaseMessageQuoteView
- (void)onQuoteViewTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidClickQuote:)]) {
        [_delegate messageCellDidClickQuote:self];
    }
}

- (void)onQuoteViewLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidLongPressQuote:)]) {
            [_delegate messageCellDidLongPressQuote:self];
        }
    }
}

@end

@implementation EaseMessageCell (Category)

- (void)setStatusHidden:(BOOL)isHidden
{
    self.statusView.hidden = isHidden;
}

@end
