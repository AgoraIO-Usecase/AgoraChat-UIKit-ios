//
//  ForwardModel.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/26.
//

#import "ForwardModel.h"
#import "EaseUserUtils.h"
#import "EaseWebImageManager.h"
#import "UIImage+EaseUI.h"
#import "AgoraChatMessage+EaseUIExt.h"
#import "UIViewController+HUD.h"
#import "EaseEmojiHelper.h"

#define kEMMsgImageDefaultSize 120
#define kEMMsgImageMinWidth 120
#define kEMMsgImageMaxWidth 150
#define kEMMsgImageMaxHeight 200

@interface ForwardModel ()

@property (nonatomic, strong, readwrite,nullable) NSAttributedString *contentAttributeText;

@property (nonatomic, assign, readwrite) CGFloat contentHeight;

@end

@implementation ForwardModel

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)forwardMessage {
    self = [super init];
    if (self) {
        self.contentHeight = 0;
        self.contentAttributeText = nil;
        self.message = forwardMessage;
        NSDictionary *quoteInfo = forwardMessage.ext[@"msgQuote"];
        __weak typeof(self) weakSelf = self;
        if (quoteInfo && [quoteInfo isKindOfClass:[NSDictionary class]]) {
            NSDictionary <NSString *, NSNumber *>*msgTypeDict = @{
                @"txt": @(AgoraChatMessageBodyTypeText),
                @"img": @(AgoraChatMessageBodyTypeImage),
                @"video": @(AgoraChatMessageBodyTypeVideo),
                @"audio": @(AgoraChatMessageBodyTypeVoice),
                @"custom": @(AgoraChatMessageBodyTypeCustom),
                @"file": @(AgoraChatMessageBodyTypeFile),
                @"location": @(AgoraChatMessageBodyTypeLocation),
                @"combine": @(AgoraChatMessageBodyTypeCombine)
            };
            NSString *quoteMsgId = quoteInfo[@"msgID"];
            AgoraChatMessageBodyType msgBodyType = msgTypeDict[quoteInfo[@"msgType"]].intValue;
            NSString *msgSender = quoteInfo[@"msgSender"];
            NSString *msgPreview = quoteInfo[@"msgPreview"];
            msgPreview = [EaseEmojiHelper convertEmoji:msgPreview];
            AgoraChatMessage *quoteMessage = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:quoteMsgId];
            id<EaseUserProfile> userInfo = [EaseUserUtils.shared getUserInfo:msgSender moduleType:quoteMessage.chatType == AgoraChatTypeChat ? EaseUserModuleTypeChat : EaseUserModuleTypeGroupChat];
            NSString *showName = userInfo.showName.length > 0 ? userInfo.showName : msgSender;
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineHeightMultiple = 1.12;
            
//            if (quoteMessage.chatThread) {
//                [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: [Thread]%@\n------\n", showName,IsStringEmpty(quoteMessage.chatThread.threadName) ? @"":quoteMessage.chatThread.threadName] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSParagraphStyleAttributeName:paragraphStyle}]];
//                self.contentAttributeText = result;
//                
//            } else {
                [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@\n------\n", showName,msgPreview] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSParagraphStyleAttributeName:paragraphStyle}]];
                self.contentAttributeText = result;
//            }
            
//            if ([self detectURL:forwardMessage.easeUI_quoteShowText]) {
//                self.contentAttributeText = [self appendQuoteContent:forwardMessage.easeUI_quoteShowText];
//                for (NSString *url in [self urls:content]) {
//                    [self appendQuoteLink:url];
//                }
//                self.contentAttributeText = [self appendQuoteLink:forwardMessage.easeUI_quoteShowText];
//            } else {
                self.contentAttributeText = [self appendQuoteContent:forwardMessage.easeUI_quoteShowText];
//            }
            self.contentHeight;
        } else {
            id<EaseUserProfile> userInfo = [EaseUserUtils.shared getUserInfo:forwardMessage.from moduleType:forwardMessage.chatType == AgoraChatTypeChat ? EaseUserModuleTypeChat : EaseUserModuleTypeGroupChat];
            NSString *showName = userInfo.showName.length > 0 ? userInfo.showName : forwardMessage.from;
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineHeightMultiple = 1.2;
//            if (forwardMessage.chatThread && !IsStringEmpty(forwardMessage.chatThread.threadName)) {
//                AgoraChatMessage *threadMessage = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:forwardMessage.chatThread.parentId];
//                NSString *threadContent = [NSString stringWithFormat:@"------\n[Thread] %@\n%@:%@",forwardMessage.chatThread.threadName,showName,forwardMessage.chatThread.lastMessage.easeUI_quoteShowText];
//                switch (threadMessage.body.type) {
//                    case AgoraChatMessageBodyTypeText:
//                    {
//                        NSString *text = IsStringEmpty(((AgoraChatTextMessageBody *)threadMessage.body).text) ? @"":((AgoraChatTextMessageBody *)threadMessage.body).text;
//                        [result appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSForegroundColorAttributeName:[UIColor darkTextColor]}]];
//                        
//                        self.contentAttributeText = [self appendThreadContent:threadContent];
//                        self.contentHeight;
//                    }
//                        break;
//                    case AgoraChatMessageBodyTypeImage:
//                    {
//                        self.contentAttributeText = result;
//                        __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                        if ([((AgoraChatImageMessageBody *)threadMessage.body).thumbnailLocalPath length] > 0) {
//                            img = [UIImage imageWithContentsOfFile:((AgoraChatImageMessageBody *)threadMessage.body).thumbnailLocalPath];
//                        }
//                        if (!img) {
//                            if (((AgoraChatImageMessageBody *)threadMessage.body).thumbnailRemotePath.length) {
//                                NSURL *imageURL = [NSURL URLWithString:((AgoraChatImageMessageBody *)threadMessage.body).thumbnailRemotePath];
//                                [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                    if (error == nil && image != nil) {
//                                        img = image;
//                                    } else {
//                                        img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                                    }
//                                    weakSelf.contentAttributeText = [weakSelf appendImage:result image:img];
//                                    weakSelf.contentAttributeText = [weakSelf appendThreadContent:threadContent];
//                                    weakSelf.contentHeight;
//                                }];
//                            } else {
//                                img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                                self.contentAttributeText = [self appendImage:result image:img];
//                                self.contentAttributeText = [self appendThreadContent:threadContent];
//                                self.contentHeight;
//                            }
//                            
//                        } else {
//                            self.contentAttributeText = [self appendImage:result image:img];
//                            self.contentAttributeText = [self appendThreadContent:threadContent];
//                            self.contentHeight;
//                        }
//                    }
//                        break;
//                    case AgoraChatMessageBodyTypeVideo:
//                    {
//                        self.contentAttributeText = result;
//                        __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                        if ([((AgoraChatVideoMessageBody *)threadMessage.body).thumbnailLocalPath length] > 0) {
//                            img = [UIImage imageWithContentsOfFile:((AgoraChatVideoMessageBody *)threadMessage.body).thumbnailLocalPath];
//                        }
//                        if (!img) {
//                            if (((AgoraChatImageMessageBody *)threadMessage.body).thumbnailRemotePath.length) {
//                                NSURL *imageURL = [NSURL URLWithString:((AgoraChatVideoMessageBody *)threadMessage.body).thumbnailRemotePath];
//                                [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                    if (error == nil && image != nil) {
//                                        img = image;
//                                    } else {
//                                        img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                                    }
//                                    weakSelf.contentAttributeText = [weakSelf appendImage:result image:[weakSelf combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
//                                    weakSelf.contentAttributeText = [weakSelf appendThreadContent:threadContent];
//                                    weakSelf.contentHeight;
//                                }];
//                            }  else {
//                                img = [UIImage easeUIImageNamed:@"msg_img_broken"];
//                                self.contentAttributeText = [self appendImage:result image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
//                                self.contentAttributeText = [self appendThreadContent:threadContent];
//                                self.contentHeight;
//                            }
//                        } else {
//                            self.contentAttributeText = [self appendImage:result image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
//                            self.contentAttributeText = [self appendThreadContent:threadContent];
//                            self.contentHeight;
//                        }
//                    }
//                        break;
//                    case AgoraChatMessageBodyTypeFile:
//                    case AgoraChatMessageBodyTypeCombine:
//                    case AgoraChatMessageBodyTypeVoice:
//                    {
//                        self.contentAttributeText = [self appendThreadContent:threadContent];
//                        self.contentHeight = 114;
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                
//            } else {
            UIViewController *container = [UIViewController currentViewController];
                switch (forwardMessage.body.type) {
                    case AgoraChatMessageBodyTypeText:
                    {
                        self.contentAttributeText = result;
                        NSString *text = IsStringEmpty(((AgoraChatTextMessageBody *)forwardMessage.body).text) ? @"":((AgoraChatTextMessageBody *)forwardMessage.body).text;
                        
                        text = [EaseEmojiHelper convertEmoji:text];
                        self.contentAttributeText = [self appendQuoteContent:text];
                        
                    }
                        break;
                    case AgoraChatMessageBodyTypeImage:
                    {
                        self.contentAttributeText = result;
                        __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                        if ([((AgoraChatImageMessageBody *)forwardMessage.body).thumbnailLocalPath length] > 0) {
                            img = [UIImage imageWithContentsOfFile:((AgoraChatImageMessageBody *)forwardMessage.body).thumbnailLocalPath];
                        }
                        if (!img) {
                            if (((AgoraChatImageMessageBody *)forwardMessage.body).thumbnailRemotePath.length) {
                                NSURL *imageURL = [NSURL URLWithString:((AgoraChatImageMessageBody *)forwardMessage.body).thumbnailRemotePath];
                                [container hideHud];
                                [container showHudInView:container.view hint:@"loading thumbnail"];
                                [EaseWebImageManager.sharedManager loadImageWithURL:imageURL options:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, EaseImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                    [container hideHud];
                                    if (error == nil && image != nil) {
                                        img = image;
                                    } else {
                                        img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                    }
                                    weakSelf.contentAttributeText = [weakSelf appendImage:result image:img];
                                    weakSelf.contentHeight = [self getImageSize:img].height+35;
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (weakSelf.reloadHeight) {
                                            weakSelf.reloadHeight(forwardMessage.messageId);
                                        }
                                    });
                                }];
                            } else {
                                img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                self.contentAttributeText = [self appendImage:result image:img];
                                self.contentHeight;
                            }
                            
                        } else {
                            self.contentAttributeText = [self appendImage:result image:img];
                            self.contentHeight;
                        }
                    }
                        break;
                    case AgoraChatMessageBodyTypeVideo:
                    {
                        self.contentAttributeText = result;
                        __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                        if ([((AgoraChatVideoMessageBody *)forwardMessage.body).thumbnailLocalPath length] > 0) {
                            img = [UIImage imageWithContentsOfFile:((AgoraChatVideoMessageBody *)forwardMessage.body).thumbnailLocalPath];
                        }
                        if (!img) {
                            if (((AgoraChatVideoMessageBody *)forwardMessage.body).thumbnailRemotePath.length) {
                                NSURL *imageURL = [NSURL URLWithString:((AgoraChatVideoMessageBody *)forwardMessage.body).thumbnailRemotePath];
                                [container hideHud];
                                [container showHudInView:container.view hint:@"loading thumbnail"];
                                [EaseWebImageManager.sharedManager loadImageWithURL:imageURL options:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, EaseImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                    [container hideHud];
                                    if (error == nil && image != nil) {
                                        img = image;
                                    } else {
                                        img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                    }
                                    weakSelf.contentAttributeText = [weakSelf appendImage:result image:[weakSelf combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                                    weakSelf.contentHeight = [self getImageSize:img].height+35;
                                    if (weakSelf.reloadHeight) {
                                        weakSelf.reloadHeight(forwardMessage.messageId);
                                    }
                                }];
                            }  else {
                                img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                self.contentAttributeText = [self appendImage:result image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                                self.contentHeight;
                            }
                        } else {
                            self.contentAttributeText = [self appendImage:result image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                            self.contentHeight;
                        }
                        
                    }
                        break;
                    case AgoraChatMessageBodyTypeVoice:
                    case AgoraChatMessageBodyTypeFile:
                    case AgoraChatMessageBodyTypeCombine:
                    {
                        self.contentAttributeText = nil;
                        if (forwardMessage.body.type == AgoraChatMessageBodyTypeCombine) {
                            AgoraChatCombineMessageBody *body = (AgoraChatCombineMessageBody *)forwardMessage.body;
                            [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@\n",body.title]]];
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                            paragraphStyle.lineHeightMultiple = 1.2;
                            paragraphStyle.lineBreakMode = 1;
                            [result appendAttributedString:[[NSAttributedString alloc] initWithString:[@"  " stringByAppendingString:body.summary] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]}]];
                            self.contentAttributeText = result;
                            self.contentHeight = 85;
                        } else {
                            self.contentHeight = 75;
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
//            }
            
        }
    }
    return self;
}

- (NSString *)date {
    if (!_date) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.message.timestamp/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"MM-dd, HH:mm"];
        NSString *localTimeString = [dateFormatter stringFromDate:date];
        _date = localTimeString;
    }
    return _date;
}

- (BOOL)detectURL:(NSString *)string {
    if ([self urls:string].count > 0) {
        return YES;
    }
    return NO;
}

- (NSArray<NSString *> *)urls:(NSString *)string {
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return  matches;
}

- (CGFloat)contentHeight {
    if (_contentHeight <= 0) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.attributedText = self.contentAttributeText;
        _contentHeight = ceilf([label sizeThatFits:CGSizeMake(EMScreenWidth-72, 999)].height+35);
        label = nil;
    }
    return _contentHeight;
}

- (NSAttributedString *)appendQuoteLink:(NSString *_Nonnull)link {
    NSMutableAttributedString *show = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentAttributeText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2;
    paragraphStyle.lineBreakMode = 1;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:link attributes:@{NSForegroundColorAttributeName:[UIColor systemBlueColor],NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSLinkAttributeName:[UIColor systemBlueColor],NSParagraphStyleAttributeName:paragraphStyle,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    [show appendAttributedString:text];
    return show;
}

- (NSAttributedString *)appendImage:(NSMutableAttributedString *_Nonnull)attributeText image:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    CGSize size = [self getImageSize:image];
    attachment.bounds = CGRectMake(0, -size.height/4, size.width, size.height);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.headIndent = 4; // 调整图片与文字的间距
    NSAttributedString *imageAttribute = [NSAttributedString attributedStringWithAttachment:attachment];
    [attributeText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeText.length)];
    [attributeText appendAttributedString:imageAttribute];
    return attributeText;
}

- (NSAttributedString *)appendQuoteContent:(NSString *_Nonnull)content {
    NSMutableAttributedString *show = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentAttributeText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2;
    paragraphStyle.lineBreakMode = 1;
       
    
       
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium],NSParagraphStyleAttributeName:paragraphStyle}];
    // 遍历匹配到的链接
    NSError *error;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *matches = [detector matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
        if (result.resultType == NSTextCheckingTypeLink) {
            // 设置链接的下划线颜色为蓝色
            [text addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName: [UIColor systemBlueColor],NSForegroundColorAttributeName:[UIColor systemBlueColor],NSParagraphStyleAttributeName:paragraphStyle} range:result.range];
        }
    }];
    [show appendAttributedString:text];
    return show;
}

- (NSAttributedString *)appendThreadContent:(NSString *_Nonnull)content {
    NSMutableAttributedString *show = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentAttributeText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.12;
    paragraphStyle.lineBreakMode = 1;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSParagraphStyleAttributeName:paragraphStyle}];
    [show appendAttributedString:text];
    return show;
}

- (UIImage *)combineImage:(UIImage *)image coverImage:(UIImage *)coverImage {
    CGSize size = [self getImageSize:image];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGFloat width = size.width/4.0;
    [coverImage drawInRect:CGRectMake(size.width/2.0-(width/2.0), image.size.height/2.0-(width/2.0), width, width)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (CGSize)getImageSize:(UIImage *)image {
    if (!image) {
        return CGSizeZero;
    }
    NSInteger tmpWidth = image.size.width;
    if (tmpWidth < kEMMsgImageMinWidth) {
        tmpWidth = kEMMsgImageMinWidth;
    }
    if (tmpWidth > kEMMsgImageMaxWidth) {
        tmpWidth = kEMMsgImageMaxWidth;
    }
    
    NSInteger tmpHeight = tmpWidth / tmpWidth * image.size.height;
    if (tmpHeight > kEMMsgImageMaxHeight) {
        tmpHeight = kEMMsgImageMaxHeight;
    }
    return CGSizeMake(tmpWidth, tmpHeight);
}

@end
