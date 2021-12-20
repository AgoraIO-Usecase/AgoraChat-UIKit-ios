//
//  EaseChatViewController.m
//  EaseIM
//
//  Update by zhangchong on 2020/2.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <Photos/Photos.h>
//#import <AVFoundation/AVFoundation.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EaseChatViewController.h"
#import "EMImageBrowser.h"
#import "EaseDateHelper.h"
#import "EaseMessageModel.h"
#import "EaseMessageCell.h"
#import "EMAudioPlayerUtil.h"
#import "EaseMessageTimeCell.h"
#import "EMMsgTouchIncident.h"
#import "EaseChatViewController+EMMsgLongPressIncident.h"
#import "EaseChatViewController+ChatToolBarIncident.h"
#import "UITableView+Refresh.h"
#import "AgoraChatConversation+EaseUI.h"
#import "EMSingleChatViewController.h"
#import "EMGroupChatViewController.h"
#import "EMChatroomViewController.h"
#import "EaseChatKitManager+ExtFunction.h"
#import "UIViewController+ComponentSize.h"
#import "EaseHeaders.h"
#import "EaseChatEnums.h"
#import "UIAlertAction+Custom.h"
#import "EaseInputMenu+Private.h"

@interface EaseChatViewController ()<EaseMoreFunctionViewDelegate>
{
    EaseChatViewModel *_viewModel;
    EaseMessageCell *_currentLongPressCell;
    UITableViewCell *_currentLongPressCustomCell;
    BOOL _isReloadViewWithModel; //Refresh the session page
}
@property (nonatomic, strong) EaseExtendMenuView *longPressView;
@property (nonatomic, strong) EaseInputMenu *inputBar;
@property (nonatomic, strong) dispatch_queue_t msgQueue;
@property (nonatomic, strong) NSMutableArray<AgoraChatMessage *> *messageList;

@property (nonatomic, strong) id<EaseUserProfile> sentProfile;
@property (nonatomic, strong) id<EaseUserProfile> otherProfile;
@end

@implementation EaseChatViewController

+ (EaseChatViewController *)initWithConversationId:(NSString *)aConversationId
                      conversationType:(AgoraChatConversationType)aType
                         chatViewModel:(EaseChatViewModel *)aModel
{
    
    switch (aType) {
        case AgoraChatConversationTypeChat:
        {
            return [[EMSingleChatViewController alloc] initSingleChatViewControllerWithCoversationid:aConversationId
                                                                                           chatViewModel:aModel];
        }
            break;
        case AgoraChatConversationTypeGroupChat:
        {
            return [[EMGroupChatViewController alloc] initGroupChatViewControllerWithCoversationid:aConversationId
                                                                                           chatViewModel:aModel];
        }
            break;
        case AgoraChatConversationTypeChatRoom:
        {
            return [[EMChatroomViewController alloc] initChatRoomViewControllerWithCoversationid:aConversationId
                                                                                   chatViewModel:aModel];
        }
            break;
        default:
            break;
    }
    return nil;
}


- (instancetype)initChatViewControllerWithCoversationid:(NSString *)conversationId
                                       conversationType:(AgoraChatConversationType)conType
                                          chatViewModel:(EaseChatViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _currentConversation = [AgoraChatClient.sharedClient.chatManager getConversation:conversationId type:conType createIfNotExist:YES];
        _msgQueue = dispatch_queue_create("emmessage.com", NULL);
        _viewModel = viewModel;
        _isReloadViewWithModel = NO;
        _sentProfile = nil;
        _otherProfile = nil;
        [EaseChatKitManager.shared setConversationId:_currentConversation.conversationId];
        if (!_viewModel) {
            _viewModel = [[EaseChatViewModel alloc] init];
        }
        
        _inputBar = [[EaseInputMenu alloc] initWithViewModel:_viewModel];
        _inputBar.delegate = self;
        //Session toolbar
        [self _setupChatBarMoreViews];
    }
    return self;
}

- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry
{
    if (!userProfileAry || userProfileAry.count == 0) return;
    
    __weak typeof(self) weakself = self;
    //single chat
    if (self.currentConversation.type == AgoraChatTypeChat) {
        for (id<EaseUserProfile> matchingProfile in userProfileAry) {
            if ([matchingProfile.easeId isEqualToString:self.currentConversation.conversationId] && !self.otherProfile) {
                self.otherProfile = matchingProfile;
            }
            if ([matchingProfile.easeId isEqualToString:self.currentConversation.conversationId] && !self.sentProfile) {
                self.sentProfile = matchingProfile;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int index = 0; index < weakself.dataArray.count; index++) {
                id obj = [weakself.dataArray objectAtIndex:index];
                EaseMessageModel *model = nil;
                if ([obj isKindOfClass:[EaseMessageModel class]]) {
                    model = (EaseMessageModel *)obj;
                    if ([model.message.from isEqualToString:weakself.currentConversation.conversationId]) {
                        model.userDataProfile = weakself.otherProfile;
                    }
                    if ([model.message.from isEqualToString:self.currentConversation.conversationId]) {
                        model.userDataProfile = weakself.sentProfile;
                    }
                }
            }
            
            if (weakself.tableView.isRefreshing) {
                [weakself.tableView endRefreshing];
            }
            [weakself refreshTableView:NO];
        });

        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakself.dataArray || weakself.dataArray.count == 0) return;

        //group chatroom
        for (int index = 0; index < weakself.dataArray.count; index++) {
            id obj = [weakself.dataArray objectAtIndex:index];
            EaseMessageModel *model = nil;
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                model = (EaseMessageModel *)obj;
                if (model.type <= AgoraChatMessageTypeExtCall) {
                    for (id<EaseUserProfile> matchingProfile in userProfileAry) {
                        if ([model.message.from isEqualToString:matchingProfile.easeId]) {
                            model.userDataProfile = matchingProfile;
                            break;
                        }
                    }
                }
            }
        }
        
        if (weakself.tableView.isRefreshing) {
            [weakself.tableView endRefreshing];
        }
        [weakself refreshTableView:NO];
    });
}

- (void)setChatVCWithViewModel:(EaseChatViewModel *)viewModel
{
    _viewModel = viewModel;
    _isReloadViewWithModel = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTableView:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.msgTimelTag = -1;
    [self _setupChatSubviews];
    
    if (self.currentConversation.type == AgoraChatTypeChat) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:)]) {
            NSMutableArray<id<EaseUserProfile>> *singleChatProfiles = [[NSMutableArray alloc]init];
            id<EaseUserProfile> userProfile = [self.delegate userProfile:self.currentConversation.conversationId];
            if (userProfile) {
                [singleChatProfiles addObject:userProfile];
            }
            userProfile = [self.delegate userProfile:self.currentConversation.conversationId];
            if (userProfile) {
                [singleChatProfiles addObject:userProfile];
            }
            if (singleChatProfiles.count > 0) {
                [self setUserProfiles:singleChatProfiles];
            }
        }
    }
    
    /*
    //草稿
    if (![[self.currentConversation draft] isEqualToString:@""]) {
        self.inputBar.textView.text = [self.currentConversation draft];
        [self.currentConversation setDraft:@""];
    }*/
    [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    [self loadData:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [EaseChatKitManager.shared markAllMessagesAsReadWithConversation:self.currentConversation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanPopupControllerView) name:CALL_MAKE1V1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanPopupControllerView) name:CALL_MAKECONFERENCE object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //群聊@“我”提醒
    if(self.currentConversation.type == AgoraChatConversationTypeGroupChat && [self.currentConversation remindMe]) {
        [self.currentConversation resetRemindMe];
    };
}

- (void)dealloc
{
    [EaseChatKitManager.shared setConversationId:@""];
    [self hideLongPressView];
    [[EMAudioPlayerUtil sharedHelper] stopPlayer];
    if (self.currentConversation.type == AgoraChatTypeChatRoom) {
        [[AgoraChatClient sharedClient].chatManager deleteConversation:self.currentConversation.conversationId isDeleteMessages:YES completion:nil];
        [[AgoraChatClient sharedClient].roomManager leaveChatroom:self.currentConversation.conversationId completion:nil];
    } else {
        /*
        //草稿
        if (self.inputBar.textView.text.length > 0) {
            [self.currentConversation setDraft:self.inputBar.textView.text];
        }*/
    }
    //Refreshing the session list
    [[NSNotificationCenter defaultCenter] postNotificationName:CONVERSATIONLIST_UPDATE object:nil];
    [[AgoraChatClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subviews

- (void)_setupChatSubviews
{
    [self.view addSubview:self.inputBar];
    [self.inputBar Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = _viewModel.chatViewBgColor;
    [self.view addSubview:self.tableView];
    [self.tableView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.inputBar.ease_top);
    }];
}

- (void)_setupChatBarMoreViews
{
    //voice
    NSString *path = [self getAudioOrVideoPath];
    EaseInputMenuRecordAudioView *recordView = [[EaseInputMenuRecordAudioView alloc] initWithRecordPath:path];
    recordView.delegate = self;
    self.inputBar.recordAudioView = recordView;
    
    //Emoticon
    EaseInputMenuEmoticonView *moreEmoticonView = [[EaseInputMenuEmoticonView alloc] initWithViewHeight:255];
    moreEmoticonView.delegate = self;
    self.inputBar.moreEmoticonView = moreEmoticonView;
    
    //Extend the functionality
    __weak typeof(self) weakself = self;
    EaseExtendMenuModel *photoAlbumExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"photo-album"] funcDesc:@"Photo & Video Library" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself chatToolBarComponentIncidentAction:EMChatToolBarPhotoAlbum];
    }];
    EaseExtendMenuModel *cameraExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"camera"] funcDesc:@"Camera" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself chatToolBarComponentIncidentAction:EMChatToolBarCamera];
    }];
    EaseExtendMenuModel *fileExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"attachments"] funcDesc:@"Attachments" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself chatToolBarFileOpenAction];
    }];
    NSMutableArray<EaseExtendMenuModel*> *extMenuArray = [@[cameraExtModel,photoAlbumExtModel,fileExtModel] mutableCopy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarExtMenuItemArray:conversationType:)]) {
        extMenuArray = [self.delegate inputBarExtMenuItemArray:extMenuArray conversationType:_currentConversation.type];
    }
    EaseExtendMenuView *moreFunction = [[EaseExtendMenuView alloc]initWithextMenuModelArray:extMenuArray menuViewModel:[[EaseExtMenuViewModel alloc]initWithType:ExtTypeChatBar itemCount:[extMenuArray count] extendMenuModel:_viewModel.extendMenuViewModel]];
    self.inputBar.extendMenuView = moreFunction;
    
    //[self.inputBar setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8]] locations:@[@0.25] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = [self.dataArray objectAtIndex:indexPath.row];
    NSString *cellString = nil;
    EaseChatWeakRemind type = EaseChatWeakRemindMsgTime;
    if ([obj isKindOfClass:[NSString class]]) {
        cellString = (NSString *)obj;
    }
    if ([obj isKindOfClass:[EaseMessageModel class]]) {
        EaseMessageModel *model = (EaseMessageModel *)obj;
        if (model.type == AgoraChatMessageTypeExtRecall) {
            if ([model.message.from isEqualToString:self.currentConversation.conversationId]) {
                cellString = @"You recall a message";
            } else {
                cellString = @"The other party recall a message";
            }
            type = EaseChatWeakRemindSystemHint;
        }
        if (model.type == AgoraChatMessageTypeExtNewFriend || model.type == AgoraChatMessageTypeExtAddGroup) {
            if ([model.message.body isKindOfClass:[AgoraChatTextMessageBody class]]) {
                cellString = ((AgoraChatTextMessageBody *)(model.message.body)).text;
                type = EaseChatWeakRemindSystemHint;
            }
        }
    }
    
    if ([cellString length] > 0) {
        NSString *identifier = (type == EaseChatWeakRemindMsgTime) ? @"EaseMessageTimeCell" : @"AgoraChatMessageSystemHint";
        EaseMessageTimeCell *cell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseMessageTimeCell alloc] initWithViewModel:_viewModel remindType:type];
        }
        cell.timeLabel.text = cellString;
        return cell;
    }
    
    EaseMessageModel *model = (EaseMessageModel *)obj;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellForItem:messageModel:)]) {
        UITableViewCell *customCell = [self.delegate cellForItem:tableView messageModel:model];
        if (customCell) {
            UILongPressGestureRecognizer *customCelllongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(customCellLongPressAction:)];
            [customCell addGestureRecognizer:customCelllongPress];
            return customCell;
        }
    }
    NSString *identifier = [EaseMessageCell cellIdentifierWithDirection:model.direction type:model.type];
    EaseMessageCell *cell = (EaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    if (cell == nil || _isReloadViewWithModel == YES) {
        _isReloadViewWithModel = NO;
        cell = [[EaseMessageCell alloc] initWithDirection:model.direction chatType:model.message.chatType messageType:model.type viewModel:_viewModel];
        cell.delegate = self;
    }
    cell.model = model;
    if (cell.model.message.body.type == AgoraChatMessageTypeVoice) {
        cell.model.weakMessageCell = cell;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexpath.row : %ld ", (long)indexPath.row);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray || [self.dataArray count] == 0 || ([self.dataArray count] - 1) < indexPath.row) return;
    id obj = [self.dataArray objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[EaseMessageModel class]]) {
        EaseMessageModel *model = (EaseMessageModel *)obj;
        if (model.message.body.type == AgoraChatMessageTypeVoice) {
            model.weakMessageCell = nil;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.inputBar clearMoreViewAndSelectedButton];
    [self hideLongPressView];
}

#pragma mark - EaseInputMenuDelegate

- (BOOL)textView:(UITextView *)textView shouldngeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldChangeTextInRange:replacementText:)]) {
        BOOL isValid = [self.delegate textViewShouldChangeTextInRange:range replacementText:text];
        return isValid;
    }
    return YES;
}

- (void)inputBarSendMsgAction:(NSString *)text
{
    if ((text.length > 0 && ![text isEqualToString:@""])) {
        [self sendTextAction:text ext:nil];
        [self.inputBar clearInputViewText];
    }
}

- (void)inputBarDidShowToolbarAction
{
    [self hideLongPressView];
    [self.tableView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.inputBar.ease_top);
    }];
    
    [self performSelector:@selector(scrollToBottomRow) withObject:nil afterDelay:0.1];
}

- (void)didSelectExtFuncPopupView
{
    [self inputBarDidShowToolbarAction];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (EaseExtendMenuModel *menuModel in self.inputBar.extendMenuView.extMenuModelArray) {
        [alertController addAction:[UIAlertAction alertActionWithTitle:menuModel.funcDesc iconImage:menuModel.icon textColor:[UIColor colorWithHexString:@"#000000"] alignment:NSTextAlignmentLeft completion:^{
            if (menuModel.itemDidSelectedHandle) {
                menuModel.itemDidSelectedHandle(menuModel.funcDesc, YES);
            }
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
//    for (UIAlertAction *alertAction in alertController.actions)
//        [alertAction setValue:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0] forKey:@"_titleTextColor"];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - EaseInputMenuRecordAudioViewDelegate

- (void)chatBarRecordAudioViewStopRecord:(NSString *)aPath
                              timeLength:(NSInteger)aTimeLength
{
    AgoraChatVoiceMessageBody *body = [[AgoraChatVoiceMessageBody alloc] initWithLocalPath:aPath displayName:@"audio"];
    body.duration = (int)aTimeLength;
    if(body.duration < 1){
        [self showHint:@"recording time too short !"];
        return;
    }
    [self sendMessageWithBody:body ext:nil];
}

#pragma mark - EaseInputMenuEmoticonViewDelegate

- (BOOL)didSelectedTextDetele
{
    return [self.inputBar deleteTailText];
}

- (void)didSelectedEmoticon:(EaseEmoticonModel *)aModel
{
    if (aModel.type == EMEmotionTypeEmoji) {
        [self.inputBar inputViewAppendText:aModel.name];
    }
    
    if (aModel.type == EMEmotionTypeGif) {
        NSDictionary *ext = @{MSG_EXT_GIF:@(YES), MSG_EXT_GIF_ID:aModel.eId};
        [self sendTextAction:aModel.name ext:ext];
    }
}

- (void)didChatBarEmoticonViewSendAction
{
    [self sendTextAction:self.inputBar.text ext:nil];
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellDidSelected:(EaseMessageCell *)aCell
{
    [self hideLongPressView];
    BOOL isCustom = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMessageItem:userProfile:)]) {
        isCustom = [self.delegate didSelectMessageItem:aCell.model.message userProfile:aCell.model.userDataProfile];
        if (!isCustom) return;
    }
    //Message event policy classification
    AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:aCell];
    eventStrategy.chatController = self;
    [eventStrategy messageCellEventOperation:aCell];
}

//Message long press event
- (void)messageCellDidLongPress:(UITableViewCell *)aCell cgPoint:(CGPoint)point
{
    if (aCell != _currentLongPressCell) {
        [self hideLongPressView];
    }
    self.longPressIndexPath = [self.tableView indexPathForCell:aCell];
    __weak typeof(self) weakself = self;
    EaseExtendMenuModel *copyExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"copy"] funcDesc:@"Copy" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself copyLongPressAction];
    }];
    EaseExtendMenuModel *deleteExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"delete"] funcDesc:@"Delete" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself deleteLongPressAction:^(AgoraChatMessage *deleteMsg) {
            if (deleteMsg) {
                NSUInteger index = [weakself.messageList indexOfObject:deleteMsg];
                if (index != -1) {
                    [weakself.messageList removeObject:deleteMsg];
                    if ([deleteMsg.messageId isEqualToString:weakself.moreMsgId]) {
                        if ([weakself.messageList count] > 0) {
                            weakself.moreMsgId = weakself.messageList[0].messageId;
                        } else {
                            weakself.moreMsgId = @"";
                        }
                    }
                }
            }
        }];
    }];
    EaseExtendMenuModel *recallExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"unsend"] funcDesc:@"Unsend" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself recallLongPressAction];
    }];
    
    NSMutableArray<EaseExtendMenuModel*> *extMenuArray = [[NSMutableArray<EaseExtendMenuModel*> alloc]init];
    BOOL isCustomCell = NO;
    if (![aCell isKindOfClass:[EaseMessageCell class]]) {
        [extMenuArray addObject:recallExtModel];
        isCustomCell = YES;
        _currentLongPressCustomCell = aCell;
    } else {
        _currentLongPressCell = (EaseMessageCell*)aCell;
        long long currentTimestamp = [[NSDate new] timeIntervalSince1970] * 1000;
        if (_currentLongPressCell.model.message.direction == AgoraChatMessageDirectionSend && (currentTimestamp - _currentLongPressCell.model.message.timestamp <= 120000)) {
            [extMenuArray addObject:recallExtModel];
        }
    }
    if (_currentLongPressCell && _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeText) {
        [extMenuArray addObject:copyExtModel];
    }
    [extMenuArray addObject:deleteExtModel];
    
    if (isCustomCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCellLongPressExtMenuItemArray:customCell:)]) {
            //自定义cell长按
            extMenuArray = [self.delegate customCellLongPressExtMenuItemArray:extMenuArray customCell:_currentLongPressCustomCell];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(messageLongPressExtMenuItemArray:message:)]) {
        //默认消息长按
        extMenuArray = [self.delegate messageLongPressExtMenuItemArray:extMenuArray message:_currentLongPressCell.model.message];
    }
    if ([extMenuArray count] <= 0) {
        return;
    }

    self.longPressView = [[EaseExtendMenuView alloc]initWithextMenuModelArray:extMenuArray menuViewModel:[[EaseExtMenuViewModel alloc]initWithType:isCustomCell ? ExtTypeCustomCellLongPress : ExtTypeLongPress itemCount:[extMenuArray count] extendMenuModel:_viewModel.extendMenuViewModel]];
    self.longPressView.delegate = self;
    
    CGSize longPressViewsize = [self.longPressView getExtViewSize];
    self.longPressView.layer.cornerRadius = 8;
    CGRect viewRect = [self.view convertRect:self.view.bounds toView:nil];
    CGRect rect = [aCell convertRect:aCell.bounds toView:nil];
    CGFloat maxWidth = self.view.frame.size.width;
    CGFloat maxHeight = self.tableView.frame.size.height;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    if (!isCustomCell) {
        if (_currentLongPressCell.model.direction == AgoraChatMessageDirectionReceive || (_viewModel.msgAlignmentStyle == EaseAlignmentlAll_Left && _currentLongPressCell.model.message.chatType == AgoraChatTypeGroupChat)) {
            xOffset = (avatarLonger + 3*componentSpacing + _currentLongPressCell.bubbleView.frame.size.width/2) - (longPressViewsize.width/2);
            if (xOffset < 2*componentSpacing) {
                xOffset = 2*componentSpacing;
            }
        } else {
            xOffset = (maxWidth - avatarLonger - 3*componentSpacing - _currentLongPressCell.bubbleView.frame.size.width/2) - (longPressViewsize.width/2);
            if ((xOffset + longPressViewsize.width) > (maxWidth - componentSpacing)) {
                xOffset = maxWidth - componentSpacing - longPressViewsize.width;
            }
        }
        yOffset = rect.origin.y - longPressViewsize.height + 2 * componentSpacing;
    } else {
        xOffset = point.x - longPressViewsize.width/2;
        if ((xOffset + longPressViewsize.width) > (maxWidth - 2*componentSpacing)) {
            xOffset = maxWidth - 2*componentSpacing - longPressViewsize.width;
        }
        if (xOffset < 2*componentSpacing) {
            xOffset = 2*componentSpacing;
        }
        yOffset = point.y - longPressViewsize.height - componentSpacing;
    }
    CGFloat topBoundary = viewRect.origin.y < [self bangScreenSize] ? [self bangScreenSize] : viewRect.origin.y;
    if (yOffset <= topBoundary) {
        yOffset = topBoundary;
        if ((yOffset + longPressViewsize.height) > isCustomCell ? (point.y + componentSpacing) : (rect.origin.y + componentSpacing)) {
            yOffset = isCustomCell ? (point.y + 1.5 * componentSpacing) : (rect.origin.y + rect.size.height - componentSpacing / 2);
        }
        if (!isCustomCell) {
            if (_currentLongPressCell.bubbleView.frame.size.height > (maxHeight - longPressViewsize.height - 2 * componentSpacing)) {
                yOffset = maxHeight / 2;
            }
        } else {
            if (aCell.frame.size.height > (maxHeight - longPressViewsize.height - 4)) {
                yOffset = maxHeight / 2;
            }
        }
    }
    self.longPressView.frame = CGRectMake(xOffset, yOffset, longPressViewsize.width, longPressViewsize.height);
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    [win addSubview:self.longPressView];
    
    UIBezierPath *shadowPath = [UIBezierPath
    bezierPathWithRect:self.longPressView.bounds];
    self.longPressView.layer.masksToBounds = NO;
    self.longPressView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.12].CGColor;
    self.longPressView.layer.shadowOffset = CGSizeMake(8.0f, 24.0f);
    self.longPressView.layer.shadowOpacity = 1;
    self.longPressView.layer.shadowPath = shadowPath.CGPath;
    self.longPressView.layer.shadowRadius = 8;
}

- (void)messageCellDidResend:(EaseMessageModel *)aModel
{
    if (aModel.message.status != AgoraChatMessageStatusFailed && aModel.message.status != AgoraChatMessageStatusPending) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [[[AgoraChatClient sharedClient] chatManager] resendMessage:aModel.message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself.tableView reloadData];
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(didSendMessage:error:)]) {
            [weakself.delegate didSendMessage:message error:error];
        }
    }];
    
    [self.tableView reloadData];
}

//Avatar click
- (void)avatarDidSelected:(EaseMessageModel *)model
{
    [self hideLongPressView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidSelected:)]) {
        [self.delegate avatarDidSelected:model.userDataProfile];
    }
}

//Avatar long press
- (void)avatarDidLongPress:(EaseMessageModel *)model
{
    [self hideLongPressView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(avatarDidLongPress:)]) {
        [self.delegate avatarDidLongPress:model.userDataProfile];
    }
}

#pragma mark -- EaseMoreFunctionViewDelegate
- (void)menuExtItemDidSelected:(EaseExtendMenuModel *)menuItemModel extType:(ExtType)extType
{
    if (extType != ExtTypeChatBar) {
        [self hideLongPressView];
    }
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

#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    __weak typeof(self) weakself = self;
    dispatch_async(self.msgQueue, ^{
        NSString *conId = weakself.currentConversation.conversationId;
        NSMutableArray *msgArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [aMessages count]; i++) {
            AgoraChatMessage *msg = aMessages[i];
            if (![msg.conversationId isEqualToString:conId]) {
                continue;
            }
            [weakself sendReadReceipt:msg];
            [weakself.currentConversation markMessageAsReadWithId:msg.messageId error:nil];
            [msgArray addObject:msg];
            [weakself.messageList addObject:msg];
        }
        NSArray *formated = [weakself formatMessages:msgArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.dataArray addObjectsFromArray:formated];
            [weakself refreshTableView:YES];
        });
    });
}

- (void)msgStatusDidChange:(AgoraChatMessage *)aMessage
                         error:(AgoraChatError *)aError
{
    __weak typeof(self) weakself = self;
    dispatch_async(self.msgQueue, ^{
        NSString *conId = self.currentConversation.conversationId;
        if (![conId isEqualToString:aMessage.conversationId]){
            return ;
        }
        
        __block NSUInteger index = NSNotFound;
        __block EaseMessageModel *reloadModel = nil;
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                EaseMessageModel *model = (EaseMessageModel *)obj;
                if ([model.message.messageId isEqualToString:aMessage.messageId]) {
                    reloadModel = model;
                    index = idx;
                    *stop = YES;
                }
            }
        }];
        
        if (index != NSNotFound) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.dataArray replaceObjectAtIndex:index withObject:reloadModel];
                [weakself.tableView beginUpdates];
                [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [weakself.tableView endUpdates];
            });
        }
        
    });
}

- (void)onConversationRead:(NSString *)from to:(NSString *)to
{
    if (self.currentConversation.type == AgoraChatConversationTypeChat) {
        if (self.tableView.isRefreshing) {
            [self.tableView endRefreshing];
        }
        [self refreshTableView:NO];
    }
}

#pragma mark - KeyBoard

- (void)keyBoardWillShow:(NSNotification *)note
{
    // Obtaining User information
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // Get keyboard height
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;

    CGFloat offset = [UIScreen mainScreen].bounds.size.height - self.view.frame.origin.y - self.view.frame.size.height;
    
    if (offset >= keyBoardHeight) {
        return;
    }
    
    keyBoardHeight -= offset;

    void (^animation)(void) = ^void(void) {
        [self.inputBar Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-keyBoardHeight);
        }];
    };
    [self keyBoardWillShow:note animations:animation completion:^(BOOL finished, CGRect keyBoardBounds) {
        if (finished) {
            [self performSelector:@selector(scrollToBottomRow) withObject:nil afterDelay:0.1];
        }
    }];
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    void (^animation)(void) = ^void(void) {
        [self.inputBar Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    };
    [self keyBoardWillHide:note animations:animation completion:nil];
}

#pragma mark - Gesture Recognizer

//Click on the message list to collapse more functions
- (void)handleTapTableViewAction:(UITapGestureRecognizer *)aTap
{
    if (aTap.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
        [self.inputBar clearMoreViewAndSelectedButton];
        [self hideLongPressView];
    }
}

- (void)scrollToBottomRow
{
    [self hideLongPressView];
    NSInteger toRow = -1;
    if ([self.dataArray count] > 0) {
        toRow = self.dataArray.count - 1;
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Send Message

- (void)sendTextAction:(NSString *)aText
                    ext:(NSDictionary *)aExt
{
    if(![aExt objectForKey:MSG_EXT_GIF]){
        [self.inputBar clearInputViewText];
    }
    if ([aText length] == 0) {
        return;
    }
    
    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:aText];
    [self sendMessageWithBody:body ext:aExt];
}

#pragma mark - Data

- (void)loadData:(BOOL)isScrollBottom
{
    __weak typeof(self) weakself = self;
    void (^block)(NSArray *aMessages, AgoraChatError *aError) = ^(NSArray *aMessages, AgoraChatError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself refreshTableViewWithData:aMessages isInsertBottom:NO isScrollBottom:isScrollBottom];
        });
    };
    
    [self.currentConversation loadMessagesStartFromId:self.moreMsgId count:50 searchDirection:AgoraChatMessageSearchDirectionUp completion:block];
}

- (NSArray *)formatMessages:(NSArray<AgoraChatMessage *> *)aMessages
{
    NSMutableArray *formated = [[NSMutableArray alloc] init];

    for (int i = 0; i < [aMessages count]; i++) {
        AgoraChatMessage *msg = aMessages[i];
        if (msg.chatType == AgoraChatTypeChat && msg.isReadAcked && (msg.body.type == AgoraChatMessageBodyTypeText || msg.body.type == AgoraChatMessageBodyTypeLocation)) {
            [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
        }
        
        if (msg.chatType == AgoraChatTypeGroupChat && msg.isNeedGroupAck && !msg.isReadAcked) {
            [[AgoraChatClient sharedClient].chatManager sendGroupMessageReadAck:msg.messageId toGroup:msg.conversationId content:@"123" completion:nil];
        }
        
        CGFloat interval = (self.msgTimelTag - msg.timestamp) / 1000;
        if (self.msgTimelTag < 0 || interval > 60 || interval < -60) {
            NSString *timeStr = [EaseDateHelper formattedTimeFromTimeInterval:msg.timestamp];
            [formated addObject:timeStr];
            self.msgTimelTag = msg.timestamp;
        }
        EaseMessageModel *model = nil;
        model = [[EaseMessageModel alloc] initWithAgoraChatMessage:msg];
        if (!model) {
            model = [[EaseMessageModel alloc]init];
        }
        
        if (model.type <= AgoraChatMessageTypeExtCall) {
            if (self.currentConversation.type == AgoraChatTypeChat) {
                if ([model.message.from isEqualToString:self.currentConversation.conversationId]) {
                    model.userDataProfile = self.otherProfile;
                }
                if ([model.message.from isEqualToString:self.currentConversation.conversationId]) {
                    model.userDataProfile = self.sentProfile;
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:)]) {
                    id<EaseUserProfile> userData = [self.delegate userProfile:msg.from];
                    model.userDataProfile = userData;
                }
            }
        }
        
        [formated addObject:model];
    }
    
    return formated;
}

- (void)refreshTableViewWithData:(NSArray<AgoraChatMessage *> *)messages isInsertBottom:(BOOL)isInsertBottom isScrollBottom:(BOOL)isScrollBottom
{
    __weak typeof(self) weakself = self;
    if (messages && [messages count]) {
        NSMutableArray<AgoraChatMessage *> *tempMsgs = [[NSMutableArray<AgoraChatMessage *> alloc]init];
        for (AgoraChatMessage *message in messages) {
            if (message.body.type != AgoraChatMessageTypeCmd) {
                [tempMsgs addObject:message];
            }
        }
        if (isInsertBottom) {
            [weakself.messageList addObjectsFromArray:tempMsgs];
        } else {
            [weakself.messageList insertObjects:tempMsgs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempMsgs count])]];
            AgoraChatMessage *msg = tempMsgs[0];
            weakself.moreMsgId = msg.messageId;
        }
        
        dispatch_async(self.msgQueue, ^{
            NSArray *formated = [weakself formatMessages:tempMsgs];
            if (isInsertBottom) {
                [weakself.dataArray addObjectsFromArray:formated];
            } else {
                [weakself.dataArray insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakself.tableView.isRefreshing) {
                    [weakself.tableView endRefreshing];
                }
                [weakself refreshTableView:isScrollBottom];
            });
        });
    } else {
        if (weakself.tableView.isRefreshing) {
            [weakself.tableView endRefreshing];
        }
    }
}

- (void)dropdownRefreshTableViewWithData
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreMessageData:currentMessageList:)]) {
//        [self.delegate loadMoreMessageData:self.moreMsgId currentMessageList:[self.messageList copy]];
//    } else {
//        if (self.tableView.isRefreshing) {
//            [self.tableView endRefreshing];
//        }
//    }
    
    [self loadData:NO];
}

#pragma mark - Action

- (void)cleanPopupControllerView
{
    [self.view endEditing:YES];
    [self hideLongPressView];
    [self.inputBar clearMoreViewAndSelectedButton];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    [[EMImageBrowser sharedBrowser] dismissViewController];
    [self stopAudioPlayer];
}

- (void)stopAudioPlayer
{
    [[EMAudioPlayerUtil sharedHelper] stopPlayer];
}

//Hide long click function area
- (void)hideLongPressView
{
    [self.longPressView removeFromSuperview];
    [self resetCellLongPressStatus:_currentLongPressCell];
}

//Hold down the custom cell
- (void)customCellLongPressAction:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        CGPoint longLocationForWindow = [aLongPress locationInView:window];
        CGPoint longLocationForTableview = [aLongPress locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:longLocationForTableview];
        [self messageCellDidLongPress:[self.tableView cellForRowAtIndexPath:indexPath] cgPoint:longLocationForWindow];
    }
}

//Sending message body
- (void)sendMessageWithBody:(AgoraChatMessageBody *)aBody
                        ext:(NSDictionary * __nullable)aExt
{
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    NSString *to = self.currentConversation.conversationId;
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:to from:from to:to body:aBody ext:aExt];
    //Whether a reading receipt needs to be sent
    if([aExt objectForKey:MSG_EXT_READ_RECEIPT]) {
        message.isNeedGroupAck = YES;
    }
    message.chatType = (AgoraChatType)self.currentConversation.type;
    
    __weak typeof(self) weakself = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendMessage:)]) {
        AgoraChatMessage *callbackMsg = [self.delegate willSendMessage:message];
        if (!callbackMsg || !callbackMsg.messageId || [callbackMsg.messageId isEqualToString:@""])
            return;
        [weakself sendMsgimpl:callbackMsg];
    } else {
        [self sendMsgimpl:message];
    }
}

- (void)sendMsgimpl:(AgoraChatMessage *)message
{
    __weak typeof(self) weakself = self;
    NSArray *formated = [self formatMessages:@[message]];
    [self.dataArray addObjectsFromArray:formated];
    [self.messageList addObject:message];
    if (!self.moreMsgId)
        //The first message of a new session
        self.moreMsgId = message.messageId;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself refreshTableView:YES];
    });
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself msgStatusDidChange:message error:error];
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(didSendMessage:error:)]) {
            [weakself.delegate didSendMessage:message error:error];
        }
    }];
}

#pragma mark - Public

- (void)setupInputMenu:(EaseInputMenu *)inputbar
{
    if (!inputbar) {
        _inputBar = inputbar;
    }
}

//Send input state
- (void)setTypingIndicator:(BOOL)typingIndicator{}

//Read receipt
- (void)sendReadReceipt:(AgoraChatMessage *)msg{}

- (void)refreshTableView:(BOOL)isScrollBottom
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView reloadData];
        [weakself.tableView setNeedsLayout];
        [weakself.tableView layoutIfNeeded];
        if (isScrollBottom) {
            [weakself scrollToBottomRow];
        }
    });
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 130;
        _tableView.scrollsToTop = NO;
        [_tableView enableRefresh:@"drop down refresh" color:UIColor.systemGrayColor];
        [_tableView.refreshControl addTarget:self action:@selector(dropdownRefreshTableViewWithData) forControlEvents:UIControlEventValueChanged];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];;
    }
    return _dataArray;
}

- (NSMutableArray<AgoraChatMessage *> *)messageList
{
    if (!_messageList) {
        _messageList = [[NSMutableArray<AgoraChatMessage *> alloc]init];
    }
    return _messageList;
}

@end
