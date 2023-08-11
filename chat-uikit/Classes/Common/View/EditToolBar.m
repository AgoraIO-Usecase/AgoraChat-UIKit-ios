//
//  EditToolBar.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import "EditToolBar.h"
#import "UIImage+EaseUI.h"

@interface EditToolBar ()

@property (nonatomic) void(^operationClosure)(EditBarOperationType type);

@property (nonatomic) UIButton *delete;

@property (nonatomic) UIButton *forward;

@end

@implementation EditToolBar

- (instancetype)initWithFrame:(CGRect)frame operationClosure:(void(^)(EditBarOperationType))operationClosure {
    self = [super initWithFrame:frame];
    if (self) {
        self.operationClosure = operationClosure;
        [self addSubview:[self delete]];
        [self addSubview:[self forward]];
    }
    return self;
}

- (UIButton *)delete {
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        _delete.frame = CGRectMake(12, 8, 36, 36);
        _delete.tag = 10;
        [_delete setImage:[UIImage easeUIImageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_delete addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete;
}

- (UIButton *)forward {
    if (!_forward) {
        _forward = [UIButton buttonWithType:UIButtonTypeCustom];
        _forward.frame = CGRectMake(CGRectGetWidth(self.frame)-48, 8, 36, 36);
        _forward.tag = 11;
        [_forward setImage:[UIImage easeUIImageNamed:@"edit_forward"] forState:UIControlStateNormal];
        [_forward addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forward;
}


- (void)senderAction:(UIButton *)sender {
    if (self.operationClosure) {
        self.operationClosure(sender.tag-10);
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)hiddenWithOperation:(EditBarOperationType)type {
    [self viewWithTag:10+type].hidden = YES;
}

@end
