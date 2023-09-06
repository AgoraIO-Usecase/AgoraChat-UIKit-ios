//
//  ForwardMessagesViewController.m
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/28.
//

#import "ForwardMessagesViewController.h"
#import "ForwardList.h"
#import <AgoraChat/AgoraChat.h>
#import "UIViewController+HUD.h"
#import "EaseDefines.h"
#import "ForwardModel.h"
#import "EMMsgTouchIncident.h"
#import "EMAudioPlayerUtil.h"
#import "ForwardMessageCell.h"
#import "UIViewController+HUD.h"

@interface ForwardMessagesViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic) ForwardList *forwardList;

@property (nonatomic) AgoraChatMessage *combineMessage;

@property (nonatomic) NSArray<AgoraChatMessage*> *attachmentMessages;

@property (nonatomic) NSMutableArray <id<EaseUserProfile>>*userProfiles;

@end

@implementation ForwardMessagesViewController

- (instancetype)initWithMessage:(AgoraChatMessage *)message userProfiles:(nonnull NSMutableArray <id<EaseUserProfile>>*)profiles {
    self = [super init];
    if (self) {
        _combineMessage = message;
        _userProfiles = profiles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *text = ((AgoraChatCombineMessageBody *)self.combineMessage.body).title;
    self.title = IsStringEmpty(text) ? @"A Chat History":text;
    [self showHudInView:self.view hint:@"Loading..."];
    __weak typeof(self) weakSelf = self;
    [AgoraChatClient.sharedClient.chatManager downloadAndParseCombineMessage:self.combineMessage completion:^(NSArray<AgoraChatMessage *> * _Nullable messages, AgoraChatError * _Nullable error) {
        [weakSelf hideHud];
        if (!error) {
            weakSelf.attachmentMessages = messages;
            [weakSelf.view addSubview:weakSelf.forwardList];
        } else {
            [weakSelf showHint:error.errorDescription];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (ForwardList *)forwardList {
    if (!_forwardList) {
        _forwardList = [[ForwardList alloc] initWithFrame:CGRectMake(0, 0, EMScreenWidth, EMScreenHeight-EMNavgationHeight) style:UITableViewStylePlain models:[self models]];
        __weak typeof(self) weakSelf = self;
        _forwardList.selectBlock = ^(ForwardModel * _Nonnull model,ForwardMessageCell *cell) {
            if (model.message.body.type != AgoraChatMessageBodyTypeCombine) {
                //Message event policy classification
                AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:(AgoraChatMessageType *)model.message.body.type];
                model.isPlaying = !model.isPlaying;
                [eventStrategy messageCellEvent:model.message controller:weakSelf needRefresh:^(BOOL playing) {
                    if (model.message.body.type == AgoraChatMessageBodyTypeVoice) {
                        if (playing && model.isPlaying) {
                            [cell startVoiceAnimation];
                        } else  {
                            [[EMAudioPlayerUtil sharedHelper] stopPlayer];
                            [cell stopVoiceAnimation];
                        }
                    }
                }];
            } else {
                [weakSelf lookupCombineMessage:model.message];
            }
        };
    }
    return _forwardList;
}

- (NSArray<ForwardModel *> *)models {
    NSMutableArray *array = [NSMutableArray array];
    for (AgoraChatMessage *message in self.attachmentMessages) {
        ForwardModel *model = [[ForwardModel alloc] initWithAgoraChatMessage:message];
        for (id<EaseUserProfile> profile in self.userProfiles) {
            if ([message.from isEqualToString:profile.easeId]) {
                model.userDataProfile = profile;
                break;
            }
        }
        [array addObject:model];
    }
    return array;
}

- (void)lookupCombineMessage:(AgoraChatMessage *)message
{
    ForwardMessagesViewController *VC = [[ForwardMessagesViewController alloc] initWithMessage:message userProfiles:self.userProfiles];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -- UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[EMAudioPlayerUtil sharedHelper] stopPlayer];
}

@end


