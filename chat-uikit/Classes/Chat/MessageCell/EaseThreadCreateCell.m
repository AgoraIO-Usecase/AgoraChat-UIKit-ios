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
#import "MessageCombineBubbleView.h"
@interface EaseThreadCreateCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *threadIcon;

@property (nonatomic, strong) UILabel *threadName;

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
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.displayType = type;
        self.viewModel = viewModel;
        self.messageType = aMessageType;
        _direction = AgoraChatMessageDirectionReceive;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (type == EMThreadHeaderTypeCreate) {
            [self.contentView addSubview:self.threadNameField];
            [self.contentView addSubview:self.divideLine];
            [self.contentView addSubview:self.alertMessage];
            [self.contentView addSubview:self.avatarView];
            [self.contentView addSubview:self.nameLabel];
            [self.contentView addSubview:self.timeLabel];
            [self.contentView addSubview:self.bubbleView];
            [self.contentView addSubview:self.fromMessage];
            self.threadNameField.hidden = NO;
        } else if (type == EMThreadHeaderTypeDisplay) {
            self.threadNameField.hidden = YES;
            [self.contentView addSubview:self.threadIcon];
            [self.contentView addSubview:self.threadName];
            [self.contentView addSubview:self.divideLine];
            [self.contentView addSubview:self.alertMessage];
            [self.contentView addSubview:self.avatarView];
            [self.contentView addSubview:self.nameLabel];
            [self.contentView addSubview:self.timeLabel];
            [self.contentView addSubview:self.bubbleView];
            [self.contentView addSubview:self.fromMessage];
        } else if (type == EMThreadHeaderTypeDisplayNoMessage) {
            self.threadNameField.hidden = YES;
            [self.contentView addSubview:self.threadIcon];
            [self.contentView addSubview:self.threadName];
            [self.contentView addSubview:self.alertMessage];
            [self.contentView addSubview:self.noMessage];
            [self.contentView addSubview:self.divideLine];
        }
        if (model) {
            self.model = model;
        }
        if (type == EMThreadHeaderTypeDisplayNoMessage) {
            [self noMessageUpdateLayout];
        } else {
            [self _setupViews];
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
        _threadNameField.tag = 678;
        _threadNameField.placeholder = @"Thread Name";
        _threadNameField.leftViewMode = UITextFieldViewModeAlways;
        _threadNameField.enabled = (self.displayType != EMThreadHeaderTypeDisplay);
        _threadNameField.returnKeyType = UIReturnKeyDone;
        [_threadNameField becomeFirstResponder];
        if (self.displayType != EMThreadHeaderTypeDisplay) {
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

- (UIImageView *)threadIcon {
    if (!_threadIcon) {
        _threadIcon = [[UIImageView alloc]init];
        _threadIcon.image = [UIImage easeUIImageNamed:@"groupThread"];
    }
    return _threadIcon;
}

- (UILabel *)threadName {
    if (!_threadName) {
        _threadName = [[UILabel alloc] init];
        _threadName.font = [UIFont boldSystemFontOfSize:18];
        _threadName.tag = 678;
        _threadName.numberOfLines = 0;
        _threadName.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _threadName;
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
        _alertMessage.text = (self.displayType == EMThreadHeaderTypeCreate ? @"Send a message to start a thread in this Group Chat.":@"Straded by ");
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
//        _nameLabel.backgroundColor = [UIColor orangeColor];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _nameLabel.textColor = [UIColor darkTextColor];
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
    if (self.displayType == EMThreadHeaderTypeCreate) {
        [self nameFieldLayout];
    } else {
        [self threadIconLayout];
        [self threadNameLayout];
    }
    [self sparaLayout];
    [self alertLayout];
    [self avatarLayout];
    [self nameLayout];
    [self timeLayout];
    [self bubbleLayout];
    [self fromLayout];
}

- (void)noMessageUpdateLayout {
//    [self Ease_makeConstraints:^(EaseConstraintMaker *make) {
//        make.height.Ease_equalTo(134);
//        make.width.Ease_equalTo(EMScreenWidth);
//    }];
    [self threadIconLayout];
    [self threadNameLayout];
    [self alertLayout];
    [self.noMessage Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(12);
        make.left.equalTo(self.contentView).offset(11);
        make.right.equalTo(self.contentView).offset(-17);
        make.height.Ease_equalTo(28);
        make.bottom.equalTo(self.contentView).offset(-38);
    }];
    [self.divideLine Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.noMessage.ease_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
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
    [self.threadNameField Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        if (self.displayType != EMThreadHeaderTypeDisplay) {
            make.height.Ease_equalTo(@(40));
        }
    }];
}

- (void)threadIconLayout {
    [self.threadIcon Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(16);
        make.width.height.Ease_equalTo(32);
    }];
}

- (void)threadNameLayout {
    [self.threadName Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.left.equalTo(self.contentView).offset(54);
        make.right.equalTo(self.contentView).offset(-16);
        if (self.bubbleView.ease_top) {
            make.bottom.equalTo(self.bubbleView.ease_top).offset(-68);
        }
    }];
}

- (void)sparaLayout {
    [self.divideLine Ease_makeConstraints:^(EaseConstraintMaker *make) {
        if (self.displayType == EMThreadHeaderTypeCreate) {
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
    [self.alertMessage Ease_makeConstraints:^(EaseConstraintMaker *make) {
        if (self.displayType == EMThreadHeaderTypeCreate) {
            make.top.equalTo(self.contentView).offset(66);
        } else {
            if (self.bubbleView.ease_top) {
                make.bottom.equalTo(self.bubbleView.ease_top).offset(-36);
            } else make.top.equalTo(self.threadName.ease_bottom).offset(12);
        }
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.Ease_equalTo(20);
    }];
}

- (void)avatarLayout {
    [self.avatarView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(11);
        make.width.height.equalTo(@(avatarLonger));
    }];
}

- (void)nameLayout {
    [self.nameLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(17);
        make.left.equalTo(self.avatarView.ease_right).offset(8);
        make.right.equalTo(self.contentView).offset(-((self.contentView.frame.size.width-73)/2.0+20));
        make.height.equalTo(@(15));
    }];
}

- (void)timeLayout {
    [self.timeLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.alertMessage.ease_bottom).offset(17);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.equalTo(@(15));
        make.left.equalTo(self.nameLabel.ease_right).offset(5);
    }];
}

- (void)bubbleLayout {
    [self.bubbleView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.ease_bottom).offset(4);
        make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
        make.bottom.equalTo(self.contentView).offset(-28);
        if (self.messageType == AgoraChatMessageTypeFile || self.messageType == AgoraChatMessageTypeCombine) {
            make.right.equalTo(@(-16));
        } else {
            self.bubbleView.maxBubbleWidth = EMScreenWidth - 48 - 32;
            make.width.lessThanOrEqualTo(@(self.bubbleView.maxBubbleWidth));
        }
    }];
}

- (void)fromLayout {
    [self.fromMessage Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.bubbleView.ease_bottom).offset(5);
        make.left.equalTo(self.avatarView.ease_right).offset(componentSpacing);
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
        case AgoraChatMessageTypeCombine:
            bubbleView = [[MessageCombineBubbleView alloc] initWithDirection:self.direction type:aType viewModel:_viewModel];
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

- (void)changeThreadName:(NSString *)text {
    CGSize size = CGSizeMake(EMScreenWidth - 70 ,CGFLOAT_MAX);
    CGFloat height = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:self.threadName.font forKey:NSFontAttributeName] context:nil].size.height;
    CGFloat oldHeight = [self.threadName.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObject:self.threadName.font forKey:NSFontAttributeName] context:nil].size.height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-oldHeight+height);
    [self.threadName Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.height.Ease_equalTo(height);
    }];
    self.threadName.text = text;
}

- (void)setModel:(EaseMessageModel *)model
{
    _model = model;
    self.nameLabel.textColor = [UIColor darkTextColor];
    self.noMessage.hidden = self.displayType != EMThreadHeaderTypeDisplayNoMessage;
    if (self.threadNameField.isHidden == YES) {
        CGSize size = CGSizeMake(EMScreenWidth - 70 ,CGFLOAT_MAX);
        CGFloat height = [model.thread.threadName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:18] forKey:NSFontAttributeName] context:nil].size.height;
        [self.threadName Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.height.Ease_equalTo(height);
        }];
        self.threadName.text = model.thread.threadName;
    } else {
        self.threadNameField.text = model.thread.threadName;
    }
    if (self.displayType == EMThreadHeaderTypeDisplay || self.displayType == EMThreadHeaderTypeDisplayNoMessage) {
        _alertMessage.text = [@"Start by " stringByAppendingString:model.thread.owner ? model.thread.owner:[AgoraChatClient.sharedClient currentUsername]];
    } else {
        _alertMessage.text = @"Send a message to start a thread in this Group Chat.";
    }
    if (model.message == nil) {
        return;
    }
    self.bubbleView.model = model;
    if (model.threadUserProfile && [model.threadUserProfile respondsToSelector:@selector(showName)] && model.threadUserProfile.showName) {
        self.nameLabel.text = model.threadUserProfile.showName;
        if (self.displayType == EMThreadHeaderTypeDisplay || self.displayType == EMThreadHeaderTypeDisplayNoMessage) {
            _alertMessage.text = [_alertMessage.text stringByAppendingString:model.threadUserProfile.showName];
        } else {
            _alertMessage.text = @"Send a message to start a thread in this Group Chat.";
        }
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
                               placeholderImage:[UIImage easeUIImageNamed:@"default_avatar"]];
            isCustomAvatar = YES;
        }
    }
    if (!isCustomAvatar) {
        _avatarView.image = [UIImage easeUIImageNamed:@"default_avatar"];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldEndText:)]) {
        [self.delegate textFieldEndText:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) return YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [self.delegate textFieldShouldReturn:textField.text];
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
