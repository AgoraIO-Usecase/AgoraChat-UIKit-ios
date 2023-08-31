//
//  MessageQuoteView.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/20.
//

#import "MessageQuoteView.h"
#import "Easeonry.h"

@implementation MessageQuoteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:[self content]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self content]];
    }
    return self;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.textAlignment = 1;
        _content.numberOfLines = 2;
        _content.lineBreakMode = UILineBreakModeTailTruncation;
    }
    return _content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.content Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.edges.Ease_equalTo(UIEdgeInsetsMake(4, 12, 6, 12));
    }];
}





@end
