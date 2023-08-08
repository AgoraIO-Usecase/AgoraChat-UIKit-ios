//
//  EMMsgImageBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "UIImageView+EaseWebCache.h"
#import "EMMsgImageBubbleView.h"
#import "EaseHeaders.h"
#import "EMMsgThreadPreviewBubble.h"
#define kEMMsgImageDefaultSize 120
#define kEMMsgImageMinWidth 50
#define kEMMsgImageMaxWidth 120
#define kEMMsgImageMaxHeight 260
#define KEMThreadBubbleWidth (EMScreenWidth*(3/5.0))

@interface EMMsgImageBubbleView ()

@property (nonatomic, strong) EMMsgThreadPreviewBubble *threadBubble;

@end

@implementation EMMsgImageBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel*)viewModel;
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self addSubview:self.photo];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.threadBubble = [[EMMsgThreadPreviewBubble alloc] initWithDirection:aDirection type:aType viewModel:viewModel];
        self.threadBubble.tag = 777;
        [self addSubview:self.threadBubble];
        self.threadBubble.layer.cornerRadius = 8;
        self.threadBubble.clipsToBounds = YES;
        self.threadBubble.hidden = YES;
    }
    
    return self;
}

- (UIImageView *)photo {
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.backgroundColor = [UIColor orangeColor];
        _photo.layer.cornerRadius = 5;
        _photo.clipsToBounds = YES;
    }
    return _photo;
}

#pragma mark - Private

- (CGSize)_getImageSize:(CGSize)aSize
{
    CGSize retSize = CGSizeZero;
    do {
        if (aSize.width == 0 || aSize.height == 0) {
            break;
        }
        NSInteger tmpWidth = aSize.width;
        if (aSize.width < kEMMsgImageMinWidth) {
            tmpWidth = kEMMsgImageMinWidth;
        }
        if (aSize.width > kEMMsgImageMaxWidth) {
            tmpWidth = kEMMsgImageMaxWidth;
        }
        
        NSInteger tmpHeight = tmpWidth / aSize.width * aSize.height;
        if (tmpHeight > kEMMsgImageMaxHeight) {
            tmpHeight = kEMMsgImageMaxHeight;
        }
        retSize = CGSizeMake(tmpWidth, tmpHeight);
        
    } while (0);
    
    return retSize;
}

- (void)setThumbnailImageWithLocalPath:(NSString *)aLocalPath
                            remotePath:(NSString *)aRemotePath
                          thumbImgSize:(CGSize)aThumbSize
                               imgSize:(CGSize)aSize
{
    UIImage *img = nil;
    if ([aLocalPath length] > 0) {
        img = [UIImage imageWithContentsOfFile:aLocalPath];
    }
    
    __weak typeof(self) weakself = self;
    void (^block)(CGSize aSize) = ^(CGSize aSize) {
        CGSize layoutSize = [weakself _getImageSize:aSize];
        CGFloat space = 0;
        if (weakself.model.message.chatThread && weakself.model.isHeader == NO) {
            space = 12*2;
        }
        if (weakself.model.message.chatThread) {
            if (weakself.model.isHeader == NO) {
                [weakself Ease_updateConstraints:^(EaseConstraintMaker *make) {
                    make.width.Ease_equalTo(KEMThreadBubbleWidth+space);
                    make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4+layoutSize.height+8+12*2);
                }];
                [weakself.photo Ease_updateConstraints:^(EaseConstraintMaker *make) {
                    make.left.equalTo(weakself).offset(12);
                    make.top.Ease_equalTo(12);
                    make.width.Ease_equalTo(layoutSize.width);
                    make.height.Ease_equalTo(layoutSize.height);
                }];
                [weakself.threadBubble Ease_makeConstraints:^(EaseConstraintMaker *make) {
                    make.top.equalTo(weakself.photo.ease_bottom).offset(8);
                    make.left.equalTo(weakself).offset(12);
                    make.right.equalTo(weakself).offset(-12);
                    make.height.Ease_equalTo(KEMThreadBubbleWidth*0.4);
                }];
            } else {
                [weakself Ease_updateConstraints:^(EaseConstraintMaker *make) {
                    make.width.Ease_equalTo(layoutSize.width);
                    make.height.Ease_equalTo(layoutSize.height);
                }];
                [weakself.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {

                }];
            }
            
            
        } else {
            [weakself Ease_updateConstraints:^(EaseConstraintMaker *make) {
                make.width.Ease_equalTo(layoutSize.width);
                make.height.Ease_equalTo(layoutSize.height);
            }];
            [weakself.threadBubble Ease_remakeConstraints:^(EaseConstraintMaker *make) {

            }];
        }
        CGRect rect;
        if (weakself.model.message.chatThread) {
            if (weakself.model.isHeader == NO) {
                rect = CGRectMake(0, 0, KEMThreadBubbleWidth+space, KEMThreadBubbleWidth*0.4+layoutSize.height+4+space);
            } else {
                rect = CGRectMake(0, 0, layoutSize.width+space, layoutSize.height+space);
            }
        } else {
            rect = CGRectMake(0, 0, layoutSize.width+space, layoutSize.height+space);
        }
        [weakself setCornerRadius:rect];
    };
    
    CGSize size = aThumbSize;
    if (aThumbSize.width == 0 || aThumbSize.height == 0) 
        size = aSize;
    if (size.width == 0 || size.height == 0)
        size = CGSizeMake(70, 70);
    
    if (img) {
        if (self.model.message.chatThread) {
            if (weakself.model.isHeader == NO) {
                [self setupBubbleBackgroundImage];
                self.photo.image = img;
            } else {
                self.image = img;
            }
        } else {
            self.image = img;
        }
        size = img.size;
        block(size);
    } else {
        block(size);
        BOOL isAutoDownloadThumbnail = ([AgoraChatClient sharedClient].options.autoDownloadThumbnail);
        if (isAutoDownloadThumbnail) {
            [self Ease_setImageWithURL:[NSURL URLWithString:aRemotePath] placeholderImage:[UIImage easeUIImageNamed:@"msg_img_broken"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, EaseImageCacheType cacheType, NSURL * _Nullable imageURL) {}];
        } else {
            self.image = [UIImage easeUIImageNamed:@"msg_img_broken"];
        }
    }
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    [super setModel:model];
    if (model.isHeader == NO) {
        if (model.message.chatThread) {
            self.threadBubble.model = model;
            self.threadBubble.hidden = !model.message.chatThread;
        }
        
    } else {
        self.threadBubble.hidden = YES;
    }
    AgoraChatMessageType type = model.type;
    self.threadBubble.hidden = !model.message.chatThread;
    if (model.thread && model.thread.threadId.length) {
        self.threadBubble.hidden = YES;
    }
    self.photo.hidden = !model.message.chatThread;
    if (type == AgoraChatMessageTypeImage) {
        AgoraChatImageMessageBody *body = (AgoraChatImageMessageBody *)model.message.body;
        NSString *imgPath = body.thumbnailLocalPath;
        if ([imgPath length] == 0 && model.direction == AgoraChatMessageDirectionSend) {
            imgPath = body.localPath;
        }
        [self setThumbnailImageWithLocalPath:imgPath remotePath:body.thumbnailRemotePath thumbImgSize:body.thumbnailSize imgSize:body.size];
    }
}

@end
