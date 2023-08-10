//
//  ForwardContainer.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/27.
//

#import "ForwardContainer.h"

@implementation ForwardContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.content];
        self.numberOfLines = 0;
        self.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,(CGRectGetHeight(self.frame)-20)/2.0, 20, 20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)starAnimation:(NSArray <UIImage*>*)images {
    self.imageView.animationImages = images;
    [self.imageView startAnimating];
}

- (void)stopAnimation {
    self.imageView.animationImages = nil;
    [self.imageView stopAnimating];
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, CGRectGetMinY(self.imageView.frame), CGRectGetWidth(self.frame)-CGRectGetMaxX(self.imageView.frame)-16, 17)];
        _content.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _content.numberOfLines = 0;
    }
    return _content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    

}

- (void)updateContent:(NSString *)content image:(UIImage *)image {
    self.content.text = content;
    self.imageView.image = image;
    self.content.hidden = NO;
    self.imageView.hidden = NO;
    self.imageView.frame = CGRectMake(8,(CGRectGetHeight(self.frame)-20)/2.0, 20, 20);
    self.content.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+8, CGRectGetMinY(self.imageView.frame), CGRectGetWidth(self.frame)-CGRectGetMaxX(self.imageView.frame)-16, 17);
}

- (void)updateAttribute:(NSAttributedString *)string {
    self.imageView.frame = CGRectZero;
    self.content.frame = CGRectZero;
    self.imageView.image = nil;
    self.content.text = nil;
    self.content.hidden = YES;
    self.imageView.hidden = YES;
    self.attributedText = string;
}


@end
