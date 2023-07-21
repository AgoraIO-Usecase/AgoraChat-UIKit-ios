//
//  EaseMessageModel.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/18.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseMessageModel.h"
#import "EaseHeaders.h"
#import "EaseMessageCell.h"
#import "EaseMessageCell+Category.h"
#import <AgoraChat/NSObject+Coding.h>
#import "EaseUserUtils.h"
#import <SDWebImage/SDWebImageManager.h>

@interface EaseMessageModel ()

@property (nonatomic, strong, readwrite,nullable) NSAttributedString *quoteContent;

@property (nonatomic, assign, readwrite) CGFloat quoteHeight;
@end

@implementation EaseMessageModel

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)aMsg
{
    self = [super init];
    if (self) {
        self.isUrl = NO;
        _quoteHeight = 0;
        _message = aMsg;
        _direction = aMsg.direction;
        _type = (AgoraChatMessageType)aMsg.body.type;
        if (aMsg.body.type == AgoraChatMessageBodyTypeText) {
            if ([aMsg.ext objectForKey:MSG_EXT_GIF]) {
                _type = AgoraChatMessageTypeExtGif;
                return self;
            }
            if ([aMsg.ext objectForKey:MSG_EXT_RECALL]) {
                _type = AgoraChatMessageTypeExtRecall;
                return self;
            }
            if ([[aMsg.ext objectForKey:MSG_EXT_NEWNOTI] isEqualToString:NOTI_EXT_ADDFRIEND]) {
                _type = AgoraChatMessageTypeExtNewFriend;
                return self;
            }
            if ([[aMsg.ext objectForKey:MSG_EXT_NEWNOTI] isEqualToString:NOTI_EXT_ADDGROUP]) {
                _type = AgoraChatMessageTypeExtAddGroup;
                return self;
            }
            
            NSString *conferenceId = [aMsg.ext objectForKey:@"conferenceId"];
            if ([conferenceId length] == 0)
                conferenceId = [aMsg.ext objectForKey:MSG_EXT_CALLID];
            if ([conferenceId length] > 0) {
                _type = AgoraChatMessageTypeExtCall;
                return self;
            }
            NSString *text = ((AgoraChatTextMessageBody *)aMsg.body).text;
            NSDataDetector *detector= [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
            NSArray *checkArr = [detector matchesInString:text options:0 range:NSMakeRange(0, text.length)];
            if (checkArr.count >= 1) {
                NSTextCheckingResult *result = checkArr.firstObject;
                NSString *urlStr = result.URL.absoluteString;
                NSRange range = [text rangeOfString:urlStr options:NSCaseInsensitiveSearch];
                if (range.length > 0) {
                    self.isUrl = YES;
                }
            }
            _type = AgoraChatMessageTypeText;
            NSDictionary *quoteInfo = aMsg.ext[@"msgQuote"];
            if (![quoteInfo isKindOfClass:[NSDictionary class]]) {
                return self;
            }
            if (quoteInfo) {
                NSDictionary <NSString *, NSNumber *>*msgTypeDict = @{
                    @"txt": @(AgoraChatMessageBodyTypeText),
                    @"img": @(AgoraChatMessageBodyTypeImage),
                    @"video": @(AgoraChatMessageBodyTypeVideo),
                    @"audio": @(AgoraChatMessageBodyTypeVoice),
                    @"custom": @(AgoraChatMessageBodyTypeCustom),
                    @"file": @(AgoraChatMessageBodyTypeFile),
                    @"location": @(AgoraChatMessageBodyTypeLocation)
                };
                NSString *quoteMsgId = quoteInfo[@"msgID"];
                AgoraChatMessageBodyType msgBodyType = msgTypeDict[quoteInfo[@"msgType"]].intValue;
                NSString *msgSender = quoteInfo[@"msgSender"];
                NSString *msgPreview = quoteInfo[@"msgPreview"];
                AgoraChatMessage *quoteMessage = [AgoraChatClient.sharedClient.chatManager getMessageWithMessageId:quoteMsgId];
                if (!quoteMessage && msgPreview.length > 0 && msgSender.length > 0) {
                    self.type = msgBodyType;
                }
                id<EaseUserProfile> userInfo = [EaseUserUtils.shared getUserInfo:msgSender moduleType:quoteMessage.chatType == AgoraChatTypeChat ? EaseUserModuleTypeChat : EaseUserModuleTypeGroupChat];
                NSString *showName = userInfo.showName.length > 0 ? userInfo.showName : msgSender;
                NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineHeightMultiple = 1.07;
                [result appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", showName] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:11 weight:UIFontWeightSemibold],NSParagraphStyleAttributeName:paragraphStyle}]];
                if (self.message.chatThread) {
                    self.quoteContent = [self appendImage:result imageQuote:NO image:[UIImage easeUIImageNamed:@"quote_file"]];
                    self.quoteContent = [self appendContent:((AgoraChatFileMessageBody *)quoteMessage.body).displayName];
                } else {
                    __weak typeof(self) weakSelf = self;
                    switch (msgBodyType) {
                        case AgoraChatMessageBodyTypeText:
                        {
                            self.quoteContent = result;
                            self.quoteContent = [self appendContent:msgPreview];
                        }
                            break;
                        case AgoraChatMessageBodyTypeImage:
                        {
                            __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                            if ([((AgoraChatImageMessageBody *)quoteMessage.body).localPath length] > 0) {
                                img = [UIImage imageWithContentsOfFile:((AgoraChatImageMessageBody *)quoteMessage.body).localPath];
                            }
                            if (!img) {
                                if (((AgoraChatImageMessageBody *)quoteMessage.body).thumbnailRemotePath.length) {
                                    NSURL *imageURL = [NSURL URLWithString:((AgoraChatImageMessageBody *)quoteMessage.body).thumbnailRemotePath];
                                    [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:@[] progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (error == nil && image != nil) {
                                            img = image;
                                        } else {
                                            img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                        }
                                        weakSelf.quoteContent = [weakSelf appendImage:result imageQuote:true image:img];
                                    }];
                                } else {
                                    img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                    self.quoteContent = [self appendImage:result imageQuote:true image:img];
                                }
                                
                            } else {
                                self.quoteContent = [self appendImage:result imageQuote:true image:img];
                            }
                        }
                            break;
                        case AgoraChatMessageBodyTypeVideo:
                        {
                            __block UIImage *img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                            if ([((AgoraChatVideoMessageBody *)quoteMessage.body).thumbnailLocalPath length] > 0) {
                                img = [UIImage imageWithContentsOfFile:((AgoraChatVideoMessageBody *)quoteMessage.body).thumbnailLocalPath];
                            }
                            if (!img) {
                                if (((AgoraChatImageMessageBody *)quoteMessage.body).thumbnailRemotePath.length) {
                                    NSURL *imageURL = [NSURL URLWithString:((AgoraChatVideoMessageBody *)quoteMessage.body).thumbnailRemotePath];
                                    [SDWebImageManager.sharedManager downloadImageWithURL:imageURL options:@[] progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (error == nil && image != nil) {
                                            img = image;
                                        } else {
                                            img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                        }
                                        weakSelf.quoteContent = [weakSelf appendImage:result imageQuote:true image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                                    }];
                                }  else {
                                    img = [UIImage easeUIImageNamed:@"msg_img_broken"];
                                    self.quoteContent = [self appendImage:result imageQuote:true image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                                }
                            } else {
                                self.quoteContent = [self appendImage:result imageQuote:true image:[self combineImage:img coverImage:[UIImage easeUIImageNamed:@"video_cover"]]];
                            }
                            
                        }
                            break;
                        case AgoraChatMessageBodyTypeVoice:
                        {
                            self.quoteContent = [self appendImage:result imageQuote:NO image:[UIImage easeUIImageNamed:@"quote_voice"]];
                            self.quoteContent = [self appendContent:[NSString stringWithFormat:@"%d”", ((AgoraChatVoiceMessageBody *)quoteMessage.body).duration]];
                        }
                            break;
                        case AgoraChatMessageTypeFile:
                        {
                            self.quoteContent = [self appendImage:result imageQuote:NO image:[UIImage easeUIImageNamed:@"quote_file"]];
                            self.quoteContent = [self appendContent:((AgoraChatFileMessageBody *)quoteMessage.body).displayName];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.quoteHeight;
                    });
                }
            }

        }
    }

    return self;
}

- (void)setMessage:(AgoraChatMessage *)message {
    _message = message;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self ease_copyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self ease_mutableCopyWithZone:zone];
}

- (CGFloat)quoteHeight {
    if (_quoteContent.length && _quoteHeight <= 0) {
        UILabel *label = [UILabel new];
        label.attributedText = _quoteContent;
        _quoteHeight = ceilf([label sizeThatFits:CGSizeMake(EMScreenWidth*0.75-24, 999)].height+16);
        label = nil;
    }
    return _quoteHeight;
}

- (NSAttributedString *)appendImage:(NSMutableAttributedString *_Nonnull)attributeText imageQuote:(BOOL)imageQuote image:(UIImage *)image {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    CGSize size = imageQuote ? ImageQuoteSize:CompositeStyleSize;
    attachment.bounds = CGRectMake(0, -size.height/4, size.width, size.height);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.headIndent = 4; // 调整图片与文字的间距
    NSAttributedString *imageAttribute = [NSAttributedString attributedStringWithAttachment:attachment];
    [attributeText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeText.length)];
    [attributeText appendAttributedString:imageAttribute];
    return attributeText;
}

- (NSAttributedString *)appendContent:(NSString *_Nonnull)content {
    NSMutableAttributedString *show = [[NSMutableAttributedString alloc] initWithAttributedString:self.quoteContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.12;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular],NSParagraphStyleAttributeName:paragraphStyle}];
    [show appendAttributedString:text];
    return show;
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
