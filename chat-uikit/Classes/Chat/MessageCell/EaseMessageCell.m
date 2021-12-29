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
#import "UIImageView+EaseWebCache.h"
#import "EaseMessageCell+Category.h"

@interface EaseMessageCell()

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) EaseMessageStatusView *statusView;

@property (nonatomic, strong) UIButton *readReceiptBtn;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@end

@implementation EaseMessageCell

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             chatType:(AgoraChatType)aChatType
                           messageType:(AgoraChatMessageType)aMessageType
                            viewModel:(EaseChatViewModel*)viewModel

{
    NSString *identifier = [EaseMessageCell cellIdentifierWithDirection:aDirection type:aMessageType];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        _direction = aDirection;
        _viewModel = viewModel;
        if (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left) {
            _direction = AgoraChatMessageDirectionReceive;
        }
        [self _setupViewsWithType:aMessageType chatType:aChatType];
    }
    [self.bubbleView setupBubbleBackgroundImage];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Class Methods

+ (NSString *)cellIdentifierWithDirection:(AgoraChatMessageDirection)aDirection
                                     type:(AgoraChatMessageType)aType
{
    NSString *identifier = @"EMMsgCellDirectionSend";
    if (aDirection == AgoraChatMessageDirectionReceive) {
        identifier = @"EMMsgCellDirectionRecv";
    }
    
    if (aType == AgoraChatMessageTypeText || aType == AgoraChatMessageTypeExtCall) {
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
    
    _bubbleView = [self _getBubbleViewWithType:aType];
    _bubbleView.userInteractionEnabled = YES;
    _bubbleView.clipsToBounds = YES;
    
    [self.contentView addSubview:_avatarView];
    [self.contentView addSubview:_bubbleView];
    [self.contentView addSubview:_nameLabel];
    
    CGFloat width = self.bounds.size.width;
    CGFloat bubbleViewWidth = self.contentView.bounds.size.width - 4 * componentSpacing;
    if (_viewModel.displayReceivedAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    }
    if (_viewModel.displaySentAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    };
    
    self.bubbleView.maxBubbleWidth = bubbleViewWidth * 0.8;
    
    if (self.direction == AgoraChatMessageDirectionReceive) {
        if (_viewModel.displayReceivedAvatar) {
            [_avatarView Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
                make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                make.width.height.equalTo(@(avatarLonger));
            }];
        }
        
        [_bubbleView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (!_viewModel.displayReceiverName) {
                make.top.equalTo(self.contentView).offset(componentSpacing);
            }
            make.bottom.equalTo(self.contentView).offset(-componentSpacing);
            if (_viewModel.displayReceivedAvatar) {
                make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
            } else {
                make.left.equalTo(self.contentView).offset(2 * componentSpacing);
            }
            
            if (aType == AgoraChatMessageTypeFile) {
                make.width.equalTo(@(self.bubbleView.maxBubbleWidth));
            } else {
                make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
            }
        }];

        _nameLabel.textAlignment = NSTextAlignmentLeft;
        if (_viewModel.displayReceiverName) {
            [_nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(componentSpacing);
                make.bottom.equalTo(self.bubbleView.ease_top).offset(-componentSpacing / 2);
                if (_viewModel.displayReceivedAvatar) {
                    make.left.equalTo(self.avatarView.ease_right).offset(2 * componentSpacing);
                } else {
                    make.left.equalTo(self.contentView).offset(2 * componentSpacing);
                }
                make.right.equalTo(self.contentView).offset(-componentSpacing);
            }];
        }
    } else {
        if (_viewModel.displaySentAvatar) {
            [_avatarView Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-componentSpacing);
                make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
                make.width.height.equalTo(@(avatarLonger));
            }];
        }
        
        [_bubbleView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            if (!_viewModel.displaySentName) {
                make.top.equalTo(self.contentView).offset(componentSpacing);
            }
            make.bottom.equalTo(self.contentView).offset(-componentSpacing);
            if (_viewModel.displaySentAvatar) {
                make.right.equalTo(self.avatarView.ease_left).offset(-componentSpacing);
            } else {
                make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
            }
            
            if (aType == AgoraChatMessageTypeFile) {
                make.width.equalTo(@(self.bubbleView.maxBubbleWidth));
            } else {
                make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
            }
        }];
        
        _nameLabel.textAlignment = NSTextAlignmentRight;
        if (_viewModel.displaySentName) {
            [_nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(componentSpacing);
                make.bottom.equalTo(self.bubbleView.ease_top).offset(-componentSpacing / 2);
                if (_viewModel.displaySentAvatar) {
                    make.right.equalTo(self.avatarView.ease_left).offset(-2 * componentSpacing);
                } else {
                    make.right.equalTo(self.contentView).offset(-2 * componentSpacing);
                }
                make.left.equalTo(self.contentView).offset(componentSpacing);
            }];
        }
    }

    _statusView = [[EaseMessageStatusView alloc] init];
    [self.contentView addSubview:_statusView];
    if (self.direction == AgoraChatMessageDirectionSend || (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left)) {
        [_statusView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.bubbleView).offset(-8);
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
        _statusView.backgroundColor = [UIColor redColor];
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

- (EaseChatMessageBubbleView *)_getBubbleViewWithType:(AgoraChatMessageType)aType
{
    EaseChatMessageBubbleView *bubbleView = nil;
    switch (aType) {
        case AgoraChatMessageTypeText:
        case AgoraChatMessageTypeExtCall:
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
        default:
            break;
    }
    if (bubbleView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
        [bubbleView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewLongPressAction:)];
        [bubbleView addGestureRecognizer:longPress];
    }
    
    return bubbleView;
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    _model = model;
    self.bubbleView.model = model;
    if (model.direction == AgoraChatMessageDirectionSend) {
        [self.statusView setSenderStatus:model.message.status isReadAcked:model.message.chatType == AgoraChatTypeChat ? model.message.isReadAcked : NO isDeliverAcked:model.message.chatType == AgoraChatTypeChat ? model.message.isDeliverAcked : NO ];
    } else {
        if (model.type == AgoraChatMessageBodyTypeVoice) {
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
                               placeholderImage:[UIImage easeUIImageNamed:@"defaultAvatar"]];
            isCustomAvatar = YES;
        }
    }
    if (!isCustomAvatar) {
        _avatarView.image = [UIImage easeUIImageNamed:@"defaultAvatar"];
    }
    if (model.message.isNeedGroupAck) {
        self.readReceiptBtn.hidden = NO;
        [self.readReceiptBtn setTitle:[NSString stringWithFormat:@"Read receipt, read user（%d）",_model.message.groupAckCount] forState:UIControlStateNormal];
    } else {
        self.readReceiptBtn.hidden = YES;
    }
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
    if (aTap.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidSelected:)]) {
            [self.delegate messageCellDidSelected:self];
        }
    }
}

//Bubble view longPress
- (void)bubbleViewLongPressAction:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        if (self.model.type == AgoraChatMessageTypeText) {
            EMMsgTextBubbleView *textBubbleView = (EMMsgTextBubbleView*)self.bubbleView;
            //textBubbleView.textLabel.backgroundColor = [UIColor colorWithRed:156/255.0 green:206/255.0 blue:243/255.0 alpha:1.0];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellDidLongPress:cgPoint:)]) {
            [self.delegate messageCellDidLongPress:self cgPoint:CGPointZero];
        }
    }
    //[aLongPress release];
}

@end

@implementation EaseMessageCell (Category)
- (void)setStatusHidden:(BOOL)isHidden
{
    self.statusView.hidden = isHidden;
}

@end
