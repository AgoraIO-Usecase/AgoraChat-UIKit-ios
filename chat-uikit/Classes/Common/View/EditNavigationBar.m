//
//  EditNavigationBar.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import "EditNavigationBar.h"

@interface EditNavigationBar ()

@property (nonatomic) UIImageView *avatar;

@property (nonatomic) UILabel *nickName;

@property (nonatomic) UIButton *cancel;

@property (nonatomic) void(^cancelBlock)(void);

@end

@implementation EditNavigationBar

- (instancetype)initWithFrame:(CGRect)frame cancel:(void (^)(void))cancel {
    self = [super initWithFrame:frame];
    if (self) {
        self.cancelBlock = cancel;
        [self addSubview:self.avatar];
        [self addSubview:self.nickName];
        [self addSubview:self.cancel];
    }
    return self;
}


- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(12, self.frame.size.height-40, 40, 40)];
    }
    return _avatar;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame)+12, self.frame.size.height-34, 200, 40)];
        _nickName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _nickName.textColor = [UIColor darkTextColor];
    }
    return _nickName;
}

- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}
- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


@end
