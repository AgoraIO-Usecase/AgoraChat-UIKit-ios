//
//  AgoraChatThreadListNavgation.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/14.
//

#import "AgoraChatThreadListNavgation.h"
#import "EaseDefines.h"
#import "UIColor+EaseUI.h"
@interface AgoraChatThreadListNavgation ()

@property (nonatomic, strong) UIButton *back;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation AgoraChatThreadListNavgation

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
    }
    return self;
}

- (UIButton *)back {
    if (!_back) {
        _back = [[UIButton alloc] initWithFrame:CGRectMake(12, kIsBangsScreen ? 52:29, 28, 28)];
        _back.contentMode = UIViewContentModeScaleAspectFill;
        [_back setImage:[UIImage imageNamed:@"thread_back"] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}

- (void)backAction {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.back.frame)+8, kIsBangsScreen ? 48:25, EMScreenWidth - 56 - CGRectGetMaxX(self.back.frame)-8, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#0D0D0D"];
        _titleLabel.text = @"All Threads";
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.back.frame)+8, CGRectGetMaxY(self.titleLabel.frame)+2, EMScreenWidth - 56 - CGRectGetMaxX(self.back.frame)-8, 15)];
        _detailLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _detailLabel;
}

- (void)setDetail:(NSString *)detail {
    self.detail = detail;
    self.detailLabel.text = detail;
}

@end
