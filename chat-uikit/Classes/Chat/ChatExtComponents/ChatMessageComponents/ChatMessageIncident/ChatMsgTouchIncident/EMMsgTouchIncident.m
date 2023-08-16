//
//  EMMsgTouchIncident.m
//  EaseIM
//
//  Created by zhangchong on 2020/7/7.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "EMMsgTouchIncident.h"

#import "EaseMessageTimeCell.h"
#import "EMLocationViewController.h"
#import "EMImageBrowser.h"
#import "EaseDateHelper.h"
#import "EMAudioPlayerUtil.h"
#import "EMMsgRecordCell.h"
#import "EaseHeaders.h"
#import "EMMsgTextBubbleView.h"
#import "EaseMessageCell+Category.h"
#import "UIViewController+HUD.h"

@implementation AgoraChatMessageEventStrategy

- (void)messageCellEventOperation:(EaseMessageCell *)aCell{}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh{}

@end

/**
    Message event factory
*/
@implementation AgoraChatMessageEventStrategyFactory

+ (AgoraChatMessageEventStrategy * _Nonnull)getStratrgyImplWithMsgCell:(AgoraChatMessageType *)type
{
    if (type == AgoraChatMessageTypeText)
        return [[TextMsgEvent alloc]init];
    if (type == AgoraChatMessageTypeImage)
        return [[ImageMsgEvent alloc] init];
    if (type == AgoraChatMessageTypeLocation)
        return [[LocationMsgEvent alloc] init];
    if (type == AgoraChatMessageTypeVoice)
        return [[VoiceMsgEvent alloc]init];
    if (type == AgoraChatMessageTypeVideo)
        return [[VideoMsgEvent alloc]init];
    if (type == AgoraChatMessageTypeFile)
        return [[FileMsgEvent alloc]init];
    if (type == AgoraChatMessageTypeExtCall)
        return [[ConferenceMsgEvent alloc]init];
    
    return [[AgoraChatMessageEventStrategy alloc]init];
}

@end

/**
    The text event
 */
@implementation TextMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    EMMsgTextBubbleView *textBubbleView = (EMMsgTextBubbleView *)aCell.bubbleView;
    NSString *chatStr = textBubbleView.textLabel.text;

    NSDataDetector *detector= [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *checkArr = [detector matchesInString:chatStr options:0 range:NSMakeRange(0, chatStr.length)];
    //Check for links
    if(checkArr.count > 0) {
        if (checkArr.count > 1) { //Let the user choose which link to jump to when there are more than 1 urls
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please select the link to open" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            for (NSTextCheckingResult *result in checkArr) {
                NSString *urlStr = result.URL.absoluteString;
                [alertController addAction:[UIAlertAction actionWithTitle:urlStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:[NSDictionary new] completionHandler:nil];
                }]];
            }
            [self.chatController presentViewController:alertController animated:YES completion:nil];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[checkArr[0] URL].absoluteString] options:[NSDictionary new] completionHandler:nil];
        }
    }
}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh {
    if (message.body.type != AgoraChatMessageBodyTypeText) {
        return;
    }
    NSString *chatStr = ((AgoraChatTextMessageBody *)message.body).text;

    NSDataDetector *detector= [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *checkArr = [detector matchesInString:chatStr options:0 range:NSMakeRange(0, chatStr.length)];
    //Check for links
    if(checkArr.count > 0) {
        if (checkArr.count > 1) { //Let the user choose which link to jump to when there are more than 1 urls
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please select the link to open" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            for (NSTextCheckingResult *result in checkArr) {
                NSString *urlStr = result.URL.absoluteString;
                [alertController addAction:[UIAlertAction actionWithTitle:urlStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:[NSDictionary new] completionHandler:nil];
                }]];
            }
            [vc presentViewController:alertController animated:YES completion:nil];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[checkArr[0] URL].absoluteString] options:[NSDictionary new] completionHandler:nil];
        }
    }
}

@end

/**
    Image event
 */
@implementation ImageMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    __weak typeof(self.chatController) weakself = self.chatController;
    AgoraChatMessage* msg = aCell.quoteModel ? aCell.quoteModel.message : aCell.model.message;
    void (^downloadThumbBlock)(void) = ^{
        [weakself showHint:@"Fetch thumbnails..."];
        [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:msg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (!error) {
                [weakself.tableView reloadData];
            }
        }];
    };
    
    AgoraChatImageMessageBody *body = msg.body;

    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed) {
        if (!isCustomDownload) {
            downloadThumbBlock();
        }
        
        return;
    }
    
    BOOL isAutoDownloadThumbnail = [AgoraChatClient sharedClient].options.autoDownloadThumbnail;
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusPending && !isAutoDownloadThumbnail) {
        downloadThumbBlock();
        return;
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSucceed) {
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
        if (image) {
            [[EMImageBrowser sharedBrowser] showImages:@[image] fromController:self.chatController];
            return;
        }
    }
    
    if (isCustomDownload) {
        return;
    }
    
    [self.chatController showHudInView:self.chatController.view hint:@"Download the original image..."];
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:msg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Download original image fail !"];
        } else {
            if (message.direction == AgoraChatMessageDirectionReceive && !message.isReadAcked) {
                [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
            }
            
            NSString *localPath = [(AgoraChatImageMessageBody *)message.body localPath];
            UIImage *image = [UIImage imageWithContentsOfFile:localPath];
            if (image) {
                [[EMImageBrowser sharedBrowser] showImages:@[image] fromController:weakself];
            } else {
                [EaseAlertController showErrorAlert:@"Fetch original image fail !"];
            }
        }
    }];
}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh {
    
    AgoraChatImageMessageBody *body = (AgoraChatImageMessageBody*)message.body;
    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed) {
        if (!isCustomDownload) {
            [vc showHint:@"Fetch thumbnails..."];
            [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
                if (!error) {
                    if (refresh) {
                        refresh(YES);
                    }
                }
            }];
        }
        
        return;
    }
    
    BOOL isAutoDownloadThumbnail = [AgoraChatClient sharedClient].options.autoDownloadThumbnail;
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusPending && !isAutoDownloadThumbnail) {
        [vc showHint:@"Fetch thumbnails..."];
        [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (!error) {
                if (refresh) {
                    refresh(YES);
                }
            }
        }];
        return;
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSucceed) {
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
        if (image) {
            [[EMImageBrowser sharedBrowser] showImages:@[image] fromController:vc];
            return;
        }
    }
    
    if (isCustomDownload) {
        return;
    }
    
    [vc showHudInView:vc.view hint:@"Download the original image..."];
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [vc hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Download original image fail !"];
        } else {
            if (message.direction == AgoraChatMessageDirectionReceive && !message.isReadAcked) {
                [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
            }
            
            NSString *localPath = [(AgoraChatImageMessageBody *)message.body localPath];
            UIImage *image = [UIImage imageWithContentsOfFile:localPath];
            if (image) {
                [[EMImageBrowser sharedBrowser] showImages:@[image] fromController:vc];
            } else {
                [EaseAlertController showErrorAlert:@"Fetch original image fail !"];
            }
        }
    }];
}

@end


/**
    Location message event
 */
@implementation LocationMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    AgoraChatLocationMessageBody *body = (AgoraChatLocationMessageBody *)aCell.model.message.body;
    if (aCell.quoteModel) {
        body = (AgoraChatLocationMessageBody*)aCell.quoteModel.message.body;
    }
    EMLocationViewController *controller = [[EMLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(body.latitude, body.longitude)];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = 0;
    [self.chatController.navigationController presentViewController:navController animated:YES completion:nil];
}

@end

/**
    Voice Message Events
 */
@implementation VoiceMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    AgoraChatMessage* msg = aCell.quoteModel ? aCell.quoteModel.message : aCell.model.message;
    AgoraChatVoiceMessageBody *body = msg.body;
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading voice, click later"];
        return;
    }
    
    void (^playBlock)(EaseMessageModel *aModel) = ^(EaseMessageModel *aModel) {
        if (!aModel.message.isListened) {
            aModel.message.isListened = YES;
            if (aModel.message.isChatThreadMessage) {
                NSMutableDictionary *dic;
                if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EMListenHashMap"]) {
                    dic = [[NSMutableDictionary alloc]init];
                } else {
                    dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EMListenHashMap"] mutableCopy];
                }
                
                [dic setObject:@"1" forKey:aModel.message.messageId];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"EMListenHashMap"];
            }
        }
        
        if (!aModel.message.isReadAcked) {
            [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:aModel.message.messageId toUser:aModel.message.conversationId completion:nil];
        }

        id model = [EMAudioPlayerUtil sharedHelper].model;
        if (model && [model isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel *oldModel = (EaseMessageModel *)model;
            if ([oldModel.message.messageId isEqualToString:aCell.model.message.messageId] && oldModel.isPlaying == YES) {
                [[EMAudioPlayerUtil sharedHelper] stopPlayer];
                [EMAudioPlayerUtil sharedHelper].model = nil;
                aCell.bubbleView.isPlaying = NO;
                return;
            }
        }
        if (aModel.isPlaying == YES) {
            aCell.bubbleView.isPlaying = aModel.isPlaying;
            [aCell setStatusHidden:aModel.message.isListened];
        } else {
            aCell.bubbleView.isPlaying = !aCell.bubbleView.isPlaying;
        }
        [[EMAudioPlayerUtil sharedHelper] startPlayerWithPath:body.localPath model:aModel completion:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                aCell.bubbleView.isPlaying = NO;
            });
        }];
    };
    
    if (body.downloadStatus == AgoraChatDownloadStatusSucceed) {
        if (aCell.quoteModel) {
            playBlock(aCell.quoteModel);
        } else {
            playBlock(aCell.model);
        }
        return;
    }
    
    if (![AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments) {
        return;
    }
    
    __weak typeof(self.chatController) weakChatControl = self.chatController;
    [self.chatController showHudInView:self.chatController.view hint:@"Download voice..."];
    EaseMessageModel *tmp = aCell.model;
    if (aCell.quoteModel) {
        tmp = aCell.quoteModel;
    }
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:tmp.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakChatControl hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Voice download failure"];
        } else {
            playBlock(tmp);
        }
    }];
}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh {
    AgoraChatVoiceMessageBody *body = (AgoraChatVoiceMessageBody*)message.body;

    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading voice, click later"];
        return;
    }
    
    void (^playBlock)(AgoraChatMessage *msg) = ^(AgoraChatMessage *msg) {
        if (!msg.isListened) {
            msg.isListened = YES;
            if (msg.isChatThreadMessage) {
                NSMutableDictionary *dic;
                if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EMListenHashMap"]) {
                    dic = [[NSMutableDictionary alloc]init];
                } else {
                    dic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"EMListenHashMap"] mutableCopy];
                }
                
                [dic setObject:@"1" forKey:msg.messageId];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"EMListenHashMap"];
            }
        }
        
        if (!msg.isReadAcked) {
            [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
        }

        if ([EMAudioPlayerUtil sharedHelper].isPlaying) {
            [[EMAudioPlayerUtil sharedHelper] stopPlayer];
            [EMAudioPlayerUtil sharedHelper].model = nil;
        }
        if (refresh) {
            refresh(YES);
        }
        [[EMAudioPlayerUtil sharedHelper] startPlayerWithPath:body.localPath model:nil completion:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (refresh) {
                    refresh(NO);
                }
            });
        }];
    };
    
    if (body.downloadStatus == AgoraChatDownloadStatusSucceed) {
        playBlock(message);
        return;
    }
    
    if (![AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments) {
        return;
    }
    [vc showHudInView:vc.view hint:@"Download voice..."];
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [vc hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Voice download failure"];
        } else {
            playBlock(message);
        }
    }];
}

@end

/**
    Video message event
 */
@implementation VideoMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    __weak typeof(self.chatController) weakChatController = self.chatController;
    AgoraChatMessage* msg = aCell.quoteModel ? aCell.quoteModel.message : aCell.model.message;
    void (^playBlock)(NSString *aPath) = ^(NSString *aPathe) {
        NSURL *videoURL = [NSURL fileURLWithPath:aPathe];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = [AVPlayer playerWithURL:videoURL];
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
        playerViewController.showsPlaybackControls = YES;
        playerViewController.modalPresentationStyle = 0;
        [weakChatController presentViewController:playerViewController animated:YES completion:^{
            [playerViewController.player play];
        }];
    };

    void (^downloadBlock)(void) = ^ {
        [weakChatController showHudInView:self.chatController.view hint:@"Download video..."];
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:msg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            [weakChatController hideHud];
            if (error) {
                [EaseAlertController showErrorAlert:@"Download video failed !"];
            } else {
                if (!message.isReadAcked) {
                    [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
                }
                playBlock([(AgoraChatVideoMessageBody*)message.body localPath]);
            }
        }];
    };
    
    AgoraChatVideoMessageBody *body = msg.body;
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading video, click later"];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed || ![fileManager fileExistsAtPath:body.thumbnailLocalPath]) {
        [self.chatController showHint:@"Download image thumbnails"];
        if (!isCustomDownload) {
            [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:msg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
                downloadBlock();
            }];
            return;
        }
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSuccessed && [fileManager fileExistsAtPath:body.localPath]) {
        playBlock(body.localPath);
    } else {
        if (!isCustomDownload) {
            downloadBlock();
        }
    }
    
}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh{
    void (^playBlock)(NSString *aPath) = ^(NSString *aPathe) {
        NSURL *videoURL = [NSURL fileURLWithPath:aPathe];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = [AVPlayer playerWithURL:videoURL];
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
        playerViewController.showsPlaybackControls = YES;
        playerViewController.modalPresentationStyle = 0;
        [vc.navigationController presentViewController:playerViewController animated:YES completion:^{
            [playerViewController.player play];
        }];
    };

    void (^downloadBlock)(void) = ^ {
        UIViewController *vc = vc;
        [vc showHudInView:vc.view hint:@"Download video..."];
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            [vc hideHud];
            if (error) {
                [EaseAlertController showErrorAlert:@"Download video failed !"];
            } else {
                if (!message.isReadAcked) {
                    [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
                }
                playBlock([(AgoraChatVideoMessageBody*)message.body localPath]);
            }
        }];
    };
    
    AgoraChatVideoMessageBody *body = (AgoraChatVideoMessageBody*)message.body;

    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading video, click later"];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed || ![fileManager fileExistsAtPath:body.thumbnailLocalPath]) {
//        [vc showHint:@"Download image thumbnails"];
        if (!isCustomDownload) {
            [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
                downloadBlock();
            }];
            return;
        }
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSuccessed && [fileManager fileExistsAtPath:body.localPath]) {
        playBlock(body.localPath);
    } else {
        if (!isCustomDownload) {
            downloadBlock();
        }
    }
}

@end

/**
    File message event
 */
@implementation FileMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    AgoraChatMessage* msg = aCell.quoteModel ? aCell.quoteModel.message : aCell.model.message;
    AgoraChatFileMessageBody *body = msg.body;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading file, click later"];
        return;
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSuccessed && [fileManager fileExistsAtPath:body.localPath]) {
        [self openFile:body.localPath delegate:self.chatController];
        return;
    } else {
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:msg progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            [self.chatController hideHud];
            if (error) {
                [EaseAlertController showErrorAlert:@"Download file failed !"];
            } else {
                if (!message.isReadAcked) {
                    [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
                }
                [self openFile:[(AgoraChatFileMessageBody*)message.body localPath] delegate:self.chatController];
            }
        }];
        
    }
}

- (void)openFile:(NSString *)aPath delegate:(UIViewController *)vc {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPath];
    NSLog(@"\nfile  --    :%@",[fileHandle readDataToEndOfFile]);
    [fileHandle closeFile];
    UIDocumentInteractionController *docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:aPath]];
    docVc.delegate = vc;
    [docVc presentPreviewAnimated:YES];
}

- (void)messageCellEvent:(AgoraChatMessage *)message controller:(UIViewController *)vc needRefresh:(void(^)(BOOL))refresh {
    AgoraChatFileMessageBody *body = (AgoraChatFileMessageBody *)message.body;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading file, click later"];
        return;
    }
    
    if (body.downloadStatus == AgoraChatDownloadStatusSuccessed && [fileManager fileExistsAtPath:body.localPath]) {
        [self openFile:body.localPath delegate:vc];
        return;
    } else {
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (error) {
                [EaseAlertController showErrorAlert:@"Download file failed !"];
            } else {
                if (!message.isReadAcked) {
                    [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
                }
                [self openFile:[(AgoraChatFileMessageBody*)message.body localPath] delegate:vc];
            }
        }];
        
    }
}

@end

/**
    Conference
 */
@implementation ConferenceMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CALL_SELECTCONFERENCECELL object:aCell.model.message];
}

@end
