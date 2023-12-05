//
//  EaseInputQuoteView.m
//  chat-uikit
//
//  Created by 冯钊 on 2023/6/5.
//

#import "EaseInputQuoteView.h"
#import <AgoraChat/AgoraChat.h>
#import "Easeonry.h"
#import "UIImage+EaseUI.h"
#import "EaseWebImageDownloader.h"
#import "EaseEmojiHelper.h"

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
        
        
        [self addSubview:self.imageView];
        [self.imageView Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self).offset(8);
            make.width.height.Ease_equalTo(36);
        }];
        
        [_cancelButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.top.equalTo(@8);
            make.left.equalTo(@12);
            make.size.equalTo(@18);
        }];
        [_messageLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(_cancelButton);
            make.top.equalTo(_cancelButton.ease_bottom).offset(4);
            make.height.equalTo(@16);
            make.right.equalTo(_nameLabel);
        }];
        [_replyLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(_cancelButton.ease_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
        }];
    }
    return self;
}

- (void)setMessage:(AgoraChatMessage *)message
{
    if (message.body.type == AgoraChatMessageBodyTypeText) {
        [_nameLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(_replyLabel.ease_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
            make.right.equalTo(@-12);
        }];
//        [_imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {}];
    } else {
        [_nameLabel Ease_remakeConstraints:^(EaseConstraintMaker *make) {
            make.left.equalTo(_replyLabel.ease_right).offset(4);
            make.top.bottom.equalTo(_cancelButton);
            make.right.equalTo(@-60);
        }];
//        [self.imageView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
//            make.right.equalTo(@-12);
//            make.centerY.equalTo(self);
//            make.size.equalTo(@36);
//        }];
    }
    
    _nameLabel.text = message.from;
    if (_delegate && [_delegate respondsToSelector:@selector(quoteMessage:showContent:)]) {
        NSString *text = [_delegate quoteMessage:self showContent:message];
        if (text.length > 0) {
            _messageLabel.text = [EaseEmojiHelper convertEmoji:text];
        } else {
            _messageLabel.text = [self messagePreviewText:message];
        }
    } else {
        _messageLabel.text = [self messagePreviewText:message];
    }
    __block UIImage *image = [UIImage easeUIImageNamed:@"msg_img_broken"];
    if (message.chatThread) {
        image = [UIImage easeUIImageNamed:@"groupThread"];
    } else {
        switch (message.body.type) {
            case AgoraChatMessageBodyTypeImage:
                {
                    if ([((AgoraChatImageMessageBody *)message.body).localPath length] > 0) {
                        image = [UIImage imageWithContentsOfFile:((AgoraChatImageMessageBody *)message.body).localPath];
                    }
                    if (!image) {
                        if (((AgoraChatImageMessageBody *)message.body).thumbnailRemotePath.length) {
                            NSURL *imageURL = [NSURL URLWithString:((AgoraChatImageMessageBody *)message.body).thumbnailRemotePath];
                            __weak typeof(self) weakSelf = self;
                            [EaseWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL options:@[] progress:nil completed:^(UIImage * _Nullable img, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                if (error == nil && img != nil) {
                                    image = img;
                                } else {
                                    image = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    weakSelf.imageView.image = image;
                                });
                            }];
                        }
                        
                    }
                }
                break;
            case AgoraChatMessageBodyTypeVideo:
                {
                    if ([((AgoraChatVideoMessageBody *)message.body).localPath length] > 0) {
                        image = [UIImage imageWithContentsOfFile:((AgoraChatVideoMessageBody *)message.body).thumbnailLocalPath];
                        if (image) {
                            image = [self combineImage:image coverImage:[UIImage easeUIImageNamed:@"video_cover"]];
                        }
                    }
                    if (!image) {
                        if (((AgoraChatVideoMessageBody *)message.body).thumbnailRemotePath.length) {
                            NSURL *imageURL = [NSURL URLWithString:((AgoraChatVideoMessageBody *)message.body).thumbnailRemotePath];
                            __weak typeof(self) weakSelf = self;
                            [EaseWebImageDownloader.sharedDownloader downloadImageWithURL:imageURL options:@[] progress:nil completed:^(UIImage * _Nullable img, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                            if (error == nil && img != nil) {
                                                                image = img;
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    weakSelf.imageView.image = [weakSelf combineImage:image coverImage:[UIImage easeUIImageNamed:@"video_cover"]];
                                                                });
                                                            }

                            }];
                        } else {
                            image = [UIImage easeUIImageNamed:@"msg_img_broken"];
                        }
                    }
                }
                break;
            case AgoraChatMessageBodyTypeFile:
            {
                image = [UIImage easeUIImageNamed:@"quote_file"];
            }
                break;
            case AgoraChatMessageBodyTypeCombine:
                {
                    image = [UIImage easeUIImageNamed:@"quote_combine"];
                }
                break;
            case AgoraChatMessageBodyTypeVoice:
                {
                    image = [UIImage easeUIImageNamed:@"quote_voice"];
                }
                break;
                
            default:
                image = nil;
                break;
        }
    }
    _imageView.image = image;
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
        _imageView.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    return _imageView;
}

- (NSString *)messagePreviewText:(AgoraChatMessage *)message
{
    if (message.chatThread && message.chatThread.threadName.length) {
        return [NSString stringWithFormat:@"Thread:%@", message.chatThread.threadName];
    } else {
        switch (message.body.type) {
            case AgoraChatMessageBodyTypeText:
                return [EaseEmojiHelper convertEmoji:((AgoraChatTextMessageBody *)message.body).text];
            case AgoraChatMessageBodyTypeImage:
                return @"Image";
            case AgoraChatMessageBodyTypeVideo:
                return @"Video";
            case AgoraChatMessageBodyTypeVoice:
                return [NSString stringWithFormat:@"Audio:%d”", ((AgoraChatVoiceMessageBody *)message.body).duration];
            case AgoraChatMessageBodyTypeCombine:
                return [NSString stringWithFormat:@"Chat History:%@", ((AgoraChatCombineMessageBody *)message.body).title];
            case AgoraChatMessageBodyTypeFile:
                return [NSString stringWithFormat:@"Attachment:%@", ((AgoraChatFileMessageBody *)message.body).displayName];
            default:
                return @"unknow message";
        }
    }
}

- (UIImage *)combineImage:(UIImage *)image coverImage:(UIImage *)coverImage {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [coverImage drawInRect:CGRectMake(image.size.width/2.0-75, image.size.height/2.0-100, 150, 200)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
