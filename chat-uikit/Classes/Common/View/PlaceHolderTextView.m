//
//  PlaceHolderTextView.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.placeholderColor = [UIColor darkTextColor];
        self.font = [UIFont systemFontOfSize:14];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

//- (void)setFont:(UIFont *)font {
//    [self setNeedsDisplay];
//}
//
//- (void)setText:(NSString *)text {
//    [self setNeedsDisplay];
//}
//
//- (void)setAttributedText:(NSAttributedString *)attributedText {
//    [self setNeedsDisplay];
//}

- (void)drawRect:(CGRect)rect {
    if ([self hasText]) {
        return;
    }
    CGSize placeHolderSize = [self.placeholder boundingRectWithSize:CGSizeMake(self.frame.size.width - 10, self.frame.size.height - 16) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    CGRect placeHolderRect = CGRectMake(5, 8, placeHolderSize.width, placeHolderSize.height);
    [self.text drawInRect:placeHolderRect withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.placeholderColor}];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

@end
