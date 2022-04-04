//
//  EaseThreadCreateCell.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/11.
//

#import "EaseThreadCreateCell.h"
#import "EMMsgTextBubbleView.h"
#import "EMMsgImageBubbleView.h"
#import "EMMsgAudioBubbleView.h"
#import "EMMsgVideoBubbleView.h"
#import "EMMsgLocationBubbleView.h"
#import "EMMsgFileBubbleView.h"
#import "EMMsgExtGifBubbleView.h"
#import "UIImageView+EaseWebCache.h"
#import "EaseMessageCell+Category.h"
#import "EMTimeConvertUtils.h"
@interface EaseThreadCreateCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *threadNameField;

@property (nonatomic, strong) UILabel *alertMessage;

@property (nonatomic, strong) UIView *divideLine;

@property (nonatomic, strong) EaseChatViewModel *viewModel;

@property (nonatomic, strong, readwrite) EaseChatMessageBubbleView *bubbleView;

@property (nonatomic, assign) AgoraChatMessageType messageType;

@property (nonatomic, assign) EMThreadHeaderType displayType;

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *fromMessage;

@property (nonatomic) UILabel *noMessage;

@end

@implementation EaseThreadCreateCell

- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType
                           displayType:(EMThreadHeaderType)type
                          viewModel:(EaseChatViewModel *)viewModel

{
    NSString *identifier = [EaseThreadCreateCell cellIdentifierType:aMessageType];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EaseThreadCreateCell"];
    if (self) {
        self.displayType = type;
        self.viewModel = viewModel;
        self.messageType = aMessageType;
        _direction = AgoraChatMessageDirectionReceive;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.threadNameField];
        [self.contentView addSubview:self.divideLine];
        [self.contentView addSubview:self.alertMessage];
        if (type == EMThreadHeaderTypeDisplay || type == EMThreadHeaderTypeCreate) {
            [self.contentView addSubview:self.avatarView];
            [self.contentView addSubview:self.nameLabel];
            [self.contentView addSubview:self.timeLabel];
            [self.contentView addSubview:self.bubbleView];
            [self.contentView addSubview:self.fromMessage];
            [self _setupViews];
        } else if (type == EMThreadHeaderTypeDisplayNoMessage) {
            [self.contentView addSubview:self.noMessage];
            [self noMessageUpdateLayout];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
        [self.avatarView addGestureRecognizer:tap];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
        [self.bubbleView addGestureRecognizer:tap1];
        
    }
    return self;
}


- (instancetype)initWithMessageType:(AgoraChatMessageType)aMessageType displayType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel model:(EaseMessageModel *)model {
    NSString *identifier = [EaseThreadCreateCell cellIdentifierType:aMessageType];
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EaseThreadCreateCell"];
    if (self) {
        self.displayType = type;
        self.viewModel = viewModel;
        self.messageType = aMessageType;
        self.model = model;
        _direction = AgoraChatMessageDirectionReceive;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.threadNameField];
        [self.contentView addSubview:self.divideLine];
        [self.contentView addSubview:self.alertMessage];
        if (type == EMThreadHeaderTypeDisplay || type == EMThreadHeaderTypeCreate) {
            [self.contentView addSubview:self.avatarView];
            [self.contentView addSubview:self.nameLabel];
            [self.contentView addSubview:self.timeLabel];
            [self.contentView addSubview:self.bubbleView];
            [self.contentView addSubview:self.fromMessage];
            [self _setupViews];
        } else if (type == EMThreadHeaderTypeDisplayNoMessage) {
            [self.contentView addSubview:self.noMessage];
            [self noMessageUpdateLayout];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
        [self.avatarView addGestureRecognizer:tap];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
        [self.bubbleView addGestureRecognizer:tap1];
        
    }
    return self;
}

#pragma mark - Class Methods

+ (NSString *)cellIdentifierType:(AgoraChatMessageType)aType
{
    NSString *identifier = @"EaseThreadCreateCellDirectionSend";
    
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


- (UITextField *)threadNameField {
    if (!_threadNameField) {
        _threadNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _threadNameField.font = [UIFont boldSystemFontOfSize:18];
        _threadNameField.leftView = [self leftView];
        _threadNameField.placeholder = @"Thread Name";
        _threadNameField.leftViewMode = UITextFieldViewModeAlways;
        _threadNameField.enabled = (self.displayType != EMThreadHeaderTypeDisplay);
        if (self.displayType == EMThreadHeaderTypeDisplay) {
            _threadNameField.rightView = [self rightView];
            _threadNameField.rightViewMode = UITextFieldViewModeAlways;
        } else {
            _threadNameField.delegate = self;
        }
    }
    return _threadNameField;
}

- (UIView *)leftView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    icon.image = [UIImage easeUIImageNamed:@"groupThread"];
    [view addSubview:icon];
    return view;
}

- (UIButton *)rightView {
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(0, 0, 30, 30);
    [view setBackgroundImage:[UIImage easeUIImageNamed:@"edit_gray"] forState:UIControlStateNormal];
    return view;
}

- (UIView *)divideLine {
    if (!_divideLine) {
        _divideLine = [[UIView alloc]initWithFrame:CGRectZero];
        _divideLine.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    }
    return _divideLine;
}

- (UILabel *)alertMessage {
    if (!_alertMessage) {
        _alertMessage = [[UILabel alloc] init];
        _alertMessage.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _alertMessage.text = (self.displayType == EMThreadHeaderTypeCreate ? @"Send a message to start a thread in this Group Chat.":@"Straded by Allen");
        _alertMessage.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    return _alertMessage;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.userInteractionEnabled = YES;
        _avatarView.multipleTouchEnabled = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (EaseChatMessageBubbleView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [self _getBubbleViewWithType:self.messageType];
        _bubbleView.unDrawCorner = YES;
        _bubbleView.userInteractionEnabled = YES;
    }
    return _bubbleView;
}

- (UILabel *)fromMessage {
    if (!_fromMessage) {
        _fromMessage = [[UILabel alloc] init];
        _fromMessage.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _fromMessage.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
        _fromMessage.textAlignment = NSTextAlignmentLeft;
        _fromMessage.text = @"Original message from Group Chat.";
    }
    return _fromMessage;
}

- (UILabel *)noMessage {
    if (!_noMessage) {
        _noMessage = [UILabel new];
        _noMessage.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _noMessage.textColor = [UIColor colorWithHexString:@"#999999"];
        _noMessage.text = @"Sorry, unable to load Original message.";
    }
    return _noMessage;
}

#pragma mark - Subviews

- (void)_setupViews {
    [self setMaxBubbleWidth];
    [self nameFieldLayout];
    [self sparaLayout];
    [self alertLayout];
    [self avatarLayout];
    [self nameLayout];
    [self timeLayout];
    [self bubbleLayout];
    [self fromLayout];
}

- (void)noMessageUpdateLayout {
    [self Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(134);
        make.width.Ease_equalTo(EMScreenWidth);
    }];
    [self nameFieldLayout];
    [self alertLayout];
    [_noMessage Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(15);
        make.left.equalTo(self).offset(11);
        make.right.equalTo(self).offset(-17);
        make.height.Ease_equalTo(28);
        make.bottom.equalTo(self).offset(-10);
    }];
    [_divideLine Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.Ease_equalTo(1);
    }];
}

- (void)setMaxBubbleWidth {
    CGFloat bubbleViewWidth = self.contentView.bounds.size.width - 4 * componentSpacing;
    if (_viewModel.displayReceivedAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    }
    if (_viewModel.displaySentAvatar) {
        bubbleViewWidth -= (avatarLonger + componentSpacing);
    };
    self.bubbleView.maxBubbleWidth = bubbleViewWidth * 0.8;
}

- (void)nameFieldLayout {
    [_threadNameField Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        if (self.displayType != EMThreadHeaderTypeDisplay) {
            make.height.Ease_equalTo(@(40));
        }
    }];
}

- (void)sparaLayout {
    [_divideLine Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        if (self.displayType == EMThreadHeaderTypeCreate || self.displayType == EMThreadHeaderTypeEdit) {
            make.top.equalTo(self.threadNameField.ease_bottom).offset(2);
            make.left.equalTo(self).offset(53);
            make.right.equalTo(self).offset(-16);
        } else {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.bottom.equalTo(self).offset(-1);
        }
        make.height.Ease_equalTo(1);
    }];
}

- (void)alertLayout {
    [_alertMessage Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(66);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.Ease_equalTo(20);
    }];
}

- (void)avatarLayout {
    [_avatarView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(11);
        make.width.height.equalTo(@(avatarLonger));
    }];
}

- (void)nameLayout {
    [_nameLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(17);
        make.left.equalTo(self.avatarView.ease_right).offset(8);
        make.right.equalTo(self.contentView).offset(-((self.contentView.frame.size.width-73)/2.0+20));
        make.height.equalTo(@(15));
    }];
}

- (void)timeLayout {
    [_timeLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(17);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.equalTo(@(15));
        make.left.equalTo(self.nameLabel.ease_right).offset(5);
    }];
}

- (void)bubbleLayout {
    if (self.messageType == AgoraChatMessageTypeFile) {
        self.bubbleView.maxBubbleWidth = self.bubbleView.maxBubbleWidth+50;
    }
    [_bubbleView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.ease_bottom).offset(4);
        make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
        if (self.messageType == AgoraChatMessageTypeFile) {
            make.width.equalTo(@(self.bubbleView.maxBubbleWidth));
        } else {
            make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
        }
    }];
}

- (void)fromLayout {
    [_fromMessage Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.bubbleView.ease_bottom).offset(5);
        make.left.equalTo(self.bubbleView);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.Ease_equalTo(15);
        make.bottom.equalTo(self.contentView).offset(-componentSpacing);
    }];
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
    
    return bubbleView;
}

- (void)setModel:(EaseMessageModel *)model
{
    _model = model;
    self.noMessage.hidden = model.message;
    self.threadNameField.text = model.thread.threadName;
    _alertMessage.text = [NSString stringWithFormat:@"Straded by %@",model.thread.owner];
    if (model.message == nil) {
        return;
    }
    self.bubbleView.model = model;
    if (model.userDataProfile && [model.userDataProfile respondsToSelector:@selector(showName)] && model.userDataProfile.showName) {
        self.nameLabel.text = model.userDataProfile.showName;
        _alertMessage.text = [NSString stringWithFormat:@"Straded by %@",model.userDataProfile.showName];
    } else {
        self.nameLabel.text = model.message.from;
    }
    _timeLabel.text = [EMTimeConvertUtils timestampConvertTime:model.message.timestamp formatter:@"YYYY-MM-dd HH:mm"];
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
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (CGRectContainsPoint(self.avatarView.frame, point)) {
//        return self.avatarView;
//    }
//    if (CGRectContainsPoint(self.bubbleView.frame, point)) {
//        return self.bubbleView;
//    }
//    if (CGRectContainsPoint(self.threadNameField.frame, point)) {
//        return self.threadNameField;
//    }
//    return self;
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndText:)]) {
        [self.delegate textFieldEndText:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndText:)]) {
        [self.delegate textFieldEndText:textField.text];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndText:)]) {
        [self.delegate textFieldEndText:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndText:)]) {
        [self.delegate textFieldEndText:textField.text];
    }
    return YES;
}

//Avatar click
- (void)avatarClick:(UITapGestureRecognizer *)aTap
{
    if (aTap.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidSelected:)]) {
            [self.delegate avatarDidSelected:self.model];
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

@end
