//
//  EaseInputQuoteView.m
//  chat-uikit
//
//  Created by 冯钊 on 2023/6/5.
//

#import "EaseInputQuoteView.h"
#import <AgoraChat/AgoraChat.h>
#import "Masonry.h"
#import "UIImage+EaseUI.h"

@interface EaseInputQuoteView()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation EaseInputQuoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage easeUIImageNamed:@"quote_delete"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.text = @"Replying to";
        _replyLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _replyLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self addSubview:_replyLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self addSubview:_messageLabel];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@12);
            make.size.equalTo(@18);
        }];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cancelButton);
            make.top.equalTo(_cancelButton.mas_bottom).offset(4);
            make.height.equalTo(@16);
            make.right.equalTo(_nameLabel);
        }];
        [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cancelButton.mas_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
        }];
    }
    return self;
}

- (void)setMessage:(AgoraChatMessage *)message
{
    if (message.body.type == AgoraChatMessageBodyTypeText) {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_replyLabel.mas_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
            make.right.equalTo(@-12);
        }];
        [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    } else {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_replyLabel.mas_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
            make.right.equalTo(@-60);
        }];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(self);
            make.size.equalTo(@36);
        }];
    }
    _nameLabel.text = message.from;
    if (_delegate && [_delegate respondsToSelector:@selector(quoteMessage:showContent:)]) {
        NSString *text = [_delegate quoteMessage:self showContent:message];
        if (text.length > 0) {
            _messageLabel.text = text;
        } else {
            _messageLabel.text = [self messagePreviewText:message];
        }
    } else {
        _messageLabel.text = [self messagePreviewText:message];
    }
}

- (void)cancelAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(quoteViewDidClickCancel:)]) {
        [_delegate quoteViewDidClickCancel:self];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (NSString *)messagePreviewText:(AgoraChatMessage *)message
{
    switch (message.body.type) {
        case AgoraChatMessageBodyTypeText:
            return ((AgoraChatTextMessageBody *)message.body).text;
        case AgoraChatMessageBodyTypeImage:
            return @"Image";
        case AgoraChatMessageBodyTypeVideo:
            return @"Video";
        case AgoraChatMessageBodyTypeVoice:
            return [NSString stringWithFormat:@"Audio:%d”", ((AgoraChatVoiceMessageBody *)message.body).duration];
        case AgoraChatMessageBodyTypeFile:
            return [NSString stringWithFormat:@"Attachment:%@", ((AgoraChatFileMessageBody *)message.body).displayName];
        default:
            return @"unknow message";
    }
}

@end
