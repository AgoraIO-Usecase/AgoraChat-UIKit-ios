//
//  MessageCombineBubbleView.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/28.
//

#import "MessageCombineBubbleView.h"
#import "EMMsgThreadPreviewBubble.h"
#import "EaseHeaders.h"
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))

@interface MessageCombineBubbleView ()
{
    EaseChatViewModel *_viewModel;
}
@property (nonatomic, strong) EMMsgThreadPreviewBubble *threadBubble;
@end

@implementation MessageCombineBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel *)viewModel
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
        [self _setupSubviews];
        self.threadBubble = [[EMMsgThreadPreviewBubble alloc] initWithDirection:aDirection type:aType viewModel:viewModel];
        if (aDirection == AgoraChatMessageDirectionSend) {
            self.title.textColor = [UIColor whiteColor];
            self.summary.textColor= [UIColor lightTextColor];
        } else {
            self.title.textColor = [UIColor darkTextColor];
            self.summary.textColor= [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        }
        self.threadBubble.tag = 777;
        [self addSubview:self.threadBubble];
        self.threadBubble.layer.cornerRadius = 8;
        self.threadBubble.clipsToBounds = YES;
        self.threadBubble.hidden = YES;
    }
    
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _title;
}

- (UILabel *)summary {
    if (!_summary) {
        _summary = [[UILabel alloc] init];
        _summary.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        _summary.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _summary.numberOfLines = 0;
    }
    return _summary;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self setupBubbleBackgroundImage];
    [self addSubview:self.title];
    [self addSubview:self.summary];
    [self.title Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self).offset(7);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.Ease_equalTo(20);
    }];
    [self.summary Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.title.ease_bottom).offset(5);
        make.left.equalTo(self.title);
        make.right.equalTo(self.title);
        make.height.lessThanOrEqualTo(@65);
    }];
}

- (void)setModel:(EaseMessageModel *)model {
    [super setModel:model];
    if (model.isHeader == NO) {
        if (model.message.chatThread) {
            self.threadBubble.model = model;
            self.threadBubble.hidden = !model.message.chatThread;
        }else {
            self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            self.threadBubble.hidden = YES;
        }
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        self.threadBubble.hidden = YES;
    }
    AgoraChatMessageType type = model.type;
    
    if (type == AgoraChatMessageTypeCombine) {
        AgoraChatCombineMessageBody *body = (AgoraChatCombineMessageBody *)model.message.body;
        CGFloat summaryHeight = [self summaryHeight:body.summary]+10;
        
        CGFloat height = 40;
        if (summaryHeight < 60) {
            height += summaryHeight;
        } else {
            height = 100;
        }
        if (!model.isHeader) {
            if (model.message.chatThread) {
                self.maxBubbleWidth = KEMThreadBubbleWidth+24;
            }
            if (model.message.chatThread) {
                height += (4+12+KEMThreadBubbleWidth*0.4);
            }
        }
        CGRect rect = CGRectMake(0, 0, self.maxBubbleWidth, height);
        [self setCornerRadius:rect];
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self setupBubbleBackgroundImage];
        [self updateThreadLayout:rect model:model];
        
        self.title.text = IsStringEmpty(body.title) ? @"A Chat History":body.title;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 1.2;
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:IsStringEmpty(body.summary) ? @"A Chat History Summary":body.summary attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSParagraphStyleAttributeName:paragraphStyle}];
        self.summary.attributedText = text;
    }
}

- (CGFloat)summaryHeight:(NSString *)summary {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:summary attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSParagraphStyleAttributeName:paragraphStyle}];
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.attributedText = text;
    return ceilf([label sizeThatFits:CGSizeMake(self.maxBubbleWidth-24, 60)].height);
}

- (void)updateThreadLayout:(CGRect)rect model:(EaseMessageModel *)model{
    [self Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.width.Ease_equalTo(rect.size.width);
        make.height.Ease_equalTo(rect.size.height);
    }];
    if (model.isHeader == NO && model.message.chatThread) {
        [_threadBubble Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-12);
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4);
            make.width.Ease_equalTo(KEMThreadBubbleWidth);
        }];
    } else {
        [_threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {
           
        }];
    }
    
}

@end
