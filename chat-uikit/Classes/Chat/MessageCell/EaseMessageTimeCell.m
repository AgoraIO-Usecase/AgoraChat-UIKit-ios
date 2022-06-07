//
//  EaseMessageTimeCell.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/20.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseMessageTimeCell.h"
#import "Easeonry.h"
#import "UIColor+EaseUI.h"

@implementation EaseMessageTimeCell

- (instancetype)initWithViewModel:(EaseChatViewModel *)viewModel remindType:(EaseChatWeakRemind)remidType
{
    NSString *identifier = (remidType == EaseChatWeakRemindMsgTime) ? @"EaseMessageTimeCell" : @"AgoraChatMessageSystemHint";
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _timeLabel = [[UILabel alloc] init];
        if (remidType == EaseChatWeakRemindMsgTime) {
            _timeLabel.textColor = viewModel.msgTimeItemFontColor;
            _timeLabel.backgroundColor = viewModel.msgTimeItemBgColor;
        } else {
            _timeLabel.textColor = [UIColor colorWithHexString:@"#ADADAD"];;
            _timeLabel.backgroundColor = [UIColor clearColor];
        }
        _timeLabel.font = viewModel.msgTimeItemFont;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.numberOfLines = 0;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(5);
            make.bottom.right.equalTo(self.contentView).offset(-5);
        }];
    }
    
    return self;
}

- (NSAttributedString *)cellAttributeText:(NSString *)string {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(0, string.length)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightSemibold],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#154DFE"]} range:NSMakeRange(string.length-15, 15)];
    return attribute;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
