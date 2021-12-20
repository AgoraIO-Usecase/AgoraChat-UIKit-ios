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

@implementation AgoraChatMessageEventStrategy

- (void)messageCellEventOperation:(EaseMessageCell *)aCell{}

@end

/**
    Message event factory
*/
@implementation AgoraChatMessageEventStrategyFactory

+ (AgoraChatMessageEventStrategy * _Nonnull)getStratrgyImplWithMsgCell:(EaseMessageCell *)aCell
{
    if (aCell.model.type == AgoraChatMessageTypeText)
        return [[TextMsgEvent alloc]init];
    if (aCell.model.type == AgoraChatMessageTypeImage)
        return [[ImageMsgEvent alloc] init];
    if (aCell.model.type == AgoraChatMessageTypeLocation)
        return [[LocationMsgEvent alloc] init];
    if (aCell.model.type == AgoraChatMessageTypeVoice)
        return [[VoiceMsgEvent alloc]init];
    if (aCell.model.type == AgoraChatMessageTypeVideo)
        return [[VideoMsgEvent alloc]init];
    if (aCell.model.type == AgoraChatMessageTypeFile)
        return [[FileMsgEvent alloc]init];
    if (aCell.model.type == AgoraChatMessageTypeExtCall)
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

@end

/**
    Image event
 */
@implementation ImageMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    __weak typeof(self.chatController) weakself = self.chatController;
    void (^downloadThumbBlock)(EaseMessageModel *aModel) = ^(EaseMessageModel *aModel) {
        [weakself showHint:@"Fetch thumbnails..."];
        [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:aModel.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (!error) {
                [weakself.tableView reloadData];
            }
        }];
    };
    
    AgoraChatImageMessageBody *body = (AgoraChatImageMessageBody*)aCell.model.message.body;
    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed) {
        if (!isCustomDownload) {
            downloadThumbBlock(aCell.model);
        }
        
        return;
    }
    
    BOOL isAutoDownloadThumbnail = [AgoraChatClient sharedClient].options.isAutoDownloadThumbnail;
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusPending && !isAutoDownloadThumbnail) {
        downloadThumbBlock(aCell.model);
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
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:aCell.model.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
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

@end


/**
    Location message event
 */
@implementation LocationMsgEvent

- (void)messageCellEventOperation:(EaseMessageCell *)aCell
{
    AgoraChatLocationMessageBody *body = (AgoraChatLocationMessageBody *)aCell.model.message.body;
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
    AgoraChatVoiceMessageBody *body = (AgoraChatVoiceMessageBody*)aCell.model.message.body;
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading voice, click later"];
        return;
    }
    
    void (^playBlock)(EaseMessageModel *aModel) = ^(EaseMessageModel *aModel) {
        if (!aModel.message.isListened) {
            aModel.message.isListened = YES;
        }
        
        if (!aModel.message.isReadAcked) {
            [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:aModel.message.messageId toUser:aModel.message.conversationId completion:nil];
        }

        id model = [EMAudioPlayerUtil sharedHelper].model;
        if (model && [model isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel *oldModel = (EaseMessageModel *)model;
            if (oldModel == aCell.model && oldModel.isPlaying == YES) {
                [[EMAudioPlayerUtil sharedHelper] stopPlayer];
                [EMAudioPlayerUtil sharedHelper].model = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:AUDIOMSGSTATECHANGE object:aModel];
                return;
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AUDIOMSGSTATECHANGE object:aModel];
        [[EMAudioPlayerUtil sharedHelper] startPlayerWithPath:body.localPath model:aModel completion:^(NSError * _Nonnull error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AUDIOMSGSTATECHANGE object:aModel];
        }];
    };
    
    if (body.downloadStatus == AgoraChatDownloadStatusSucceed) {
        playBlock(aCell.model);
        return;
    }
    
    if (![AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments) {
        return;
    }
    
    __weak typeof(self.chatController) weakChatControl = self.chatController;
    [self.chatController showHudInView:self.chatController.view hint:@"Download voice..."];
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:aCell.model.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakChatControl hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Voice download failure"];
        } else {
            playBlock(aCell.model);
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
        [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:aCell.model.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
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
    
    AgoraChatVideoMessageBody *body = (AgoraChatVideoMessageBody*)aCell.model.message.body;
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading video, click later"];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isCustomDownload = !([AgoraChatClient sharedClient].options.isAutoTransferMessageAttachments);
    if (body.thumbnailDownloadStatus == AgoraChatDownloadStatusFailed || ![fileManager fileExistsAtPath:body.thumbnailLocalPath]) {
        [self.chatController showHint:@"Download image thumbnails"];
        if (!isCustomDownload) {
            [[AgoraChatClient sharedClient].chatManager downloadMessageThumbnail:aCell.model.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
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
    AgoraChatFileMessageBody *body = (AgoraChatFileMessageBody *)aCell.model.message.body;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (body.downloadStatus == AgoraChatDownloadStatusDownloading) {
        [EaseAlertController showInfoAlert:@"Downloading file, click later"];
        return;
    }
    __weak typeof(self.chatController) weakself = self.chatController;
    void (^checkFileBlock)(NSString *aPath) = ^(NSString *aPathe) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:aPathe];
        NSLog(@"\nfile  --    :%@",[fileHandle readDataToEndOfFile]);
        [fileHandle closeFile];
        UIDocumentInteractionController *docVc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:aPathe]];
        docVc.delegate = weakself;
        [docVc presentPreviewAnimated:YES];
    };
    
    if (body.downloadStatus == AgoraChatDownloadStatusSuccessed && [fileManager fileExistsAtPath:body.localPath]) {
        checkFileBlock(body.localPath);
        return;
    }
    
    [[AgoraChatClient sharedClient].chatManager downloadMessageAttachment:aCell.model.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself hideHud];
        if (error) {
            [EaseAlertController showErrorAlert:@"Download file failed !"];
        } else {
            if (!message.isReadAcked) {
                [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:message.messageId toUser:message.conversationId completion:nil];
            }
            checkFileBlock([(AgoraChatFileMessageBody*)message.body localPath]);
        }
    }];
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
