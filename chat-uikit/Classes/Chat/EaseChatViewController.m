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
#import "EMBottomMoreFunctionView.h"
#import "EaseThreadCreateViewController.h"
#import "EaseThreadChatViewController.h"

#import "EMMaskHighlightViewDelegate.h"
#import "EMBottomReactionDetailView.h"
#import "ChatUIOptions.h"
#import "AgoraChatMessage+EaseUIExt.h"
#import "ForwardMessagesViewController.h"
#import "MessageEditor.h"
#import "EditNavigationBar.h"
#import "EditToolBar.h"
#import "EaseEmojiHelper.h"

#define chatThreadPageSize 10

@interface EaseChatViewController ()<EaseMoreFunctionViewDelegate, EMBottomMoreFunctionViewDelegate>
{
    EaseMessageCell *_currentLongPressCell;
    UITableViewCell *_currentLongPressCustomCell;
    BOOL _isReloadViewWithModel; //Refresh the session page
}
@property (nonatomic, strong) EMBottomMoreFunctionView *longPressView;
@property (nonatomic, strong) dispatch_queue_t msgQueue;
@property (nonatomic, strong) NSMutableArray<AgoraChatMessage *> *messageList;

@property (nonatomic, strong) id<EaseUserProfile> sentProfile;
@property (nonatomic, strong) id<EaseUserProfile> otherProfile;
@property (nonatomic, assign, readwrite) AgoraChatConversationType conversationType;
@property (nonatomic, assign, readwrite) BOOL isChatThread;
@property (nonatomic, strong, readwrite) EaseChatViewModel *viewModel;
@property (nonatomic, strong) NSMutableDictionary *messageIdsMap;
@property (nonatomic) NSString *parentMessageId;
@property (nonatomic) AgoraChatCursorResult *cursor;
@property (nonatomic) MessageEditor *editor;
@property (nonatomic) NSIndexPath* highLightIndexPath;
@end

@implementation EaseChatViewController

+ (EaseChatViewController *)chatWithConversationId:(NSString *)aConversationId
                                  conversationType:(AgoraChatConversationType)aType
                                     chatViewModel:(EaseChatViewModel *)aModel parentMessageId:(NSString *)parentMessageId isChatThread:(BOOL)isChatThread
{
    if (isChatThread == YES) {
        EaseThreadChatViewController *VC = [[EaseThreadChatViewController alloc] initThreadChatViewControllerWithCoversationid:aConversationId chatViewModel:aModel parentMessageId:parentMessageId model:nil];
        return VC;
    }
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
        self.messageIdsMap = [NSMutableDictionary dictionary];
        _currentConversation = [AgoraChatClient.sharedClient.chatManager getConversation:conversationId type:conType createIfNotExist:YES];
        self.conversationType = conType;
        _msgQueue = dispatch_queue_create("emmessage.com", NULL);
        _viewModel = viewModel;
        _isReloadViewWithModel = NO;
        _sentProfile = nil;
        _otherProfile = nil;
        _endScroll = YES;
        _highLightIndexPath = nil;
        [EaseChatKitManager.shared setConversationId:_currentConversation.conversationId];
        if (!_viewModel) {
            _viewModel = [[EaseChatViewModel alloc] init];
        }
        
        _inputBar = [[EaseInputMenu alloc] initWithViewModel:_viewModel];
        _inputBar.delegate = self;
        //Session toolbar
        [self _setupChatBarMoreViews];
        _inputBar.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTypingIndicator:(BOOL)typingIndicator {}

- (instancetype) initChatViewControllerWithCoversationid:(NSString *)conversationId
                                       conversationType:(AgoraChatConversationType)conType
                                          chatViewModel:(EaseChatViewModel *)viewModel isChatThread:(BOOL)isChatThread parentMessageId:(NSString *)parentMessageId
{
    self = [super init];
    if (self) {
        self.parentMessageId = parentMessageId;
        self.messageIdsMap = [NSMutableDictionary dictionary];
        self.isChatThread = isChatThread;
        _currentConversation = [AgoraChatClient.sharedClient.chatManager getConversation:conversationId type:conType createIfNotExist:YES isThread:isChatThread];
        self.conversationType = conType;
        _msgQueue = dispatch_queue_create("emmessage.com", NULL);
        _viewModel = viewModel;
        _isReloadViewWithModel = NO;
        _sentProfile = nil;
        _otherProfile = nil;
        _endScroll = YES;
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
    self.profiles = [NSMutableArray arrayWithArray:userProfileAry];
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
                    if ([model.message.from isEqualToString:weakself.currentConversation.conversationId]) {
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
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself refreshTableView:YES];
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
 
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTableViewAction:)];
//    [self.tableView addGestureRecognizer:tap];

    
    [self loadData:self.isChatThread == YES ? NO:YES];
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
    if(self.currentConversation.type == AgoraChatConversationTypeGroupChat && ([self.currentConversation remindMe] || [self.currentConversation remindALL])) {
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
    [AgoraChatClient.sharedClient.chatManager removeDelegate:self];
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
    NSDictionary *cellNotifyMap;
    EaseChatWeakRemind type = EaseChatWeakRemindMsgTime;
    if ([obj isKindOfClass:[NSString class]]) {
        cellString = (NSString *)obj;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        cellNotifyMap = (NSDictionary *)obj;
    }
    if ([obj isKindOfClass:[EaseMessageModel class]]) {
        EaseMessageModel *model = (EaseMessageModel *)obj;
        if (model.type == AgoraChatMessageTypeExtRecall) {
            if ([model.message.from isEqualToString:AgoraChatClient.sharedClient.currentUsername]) {
                cellString = @"You recalled a message";
            } else {
                NSString* msgFrom = model.message.from;
                if (self.delegate && [self.delegate respondsToSelector:@selector(userProfile:)]) {
                    id<EaseUserProfile> userData = [self.delegate userProfile:model.message.from];
                    if (userData.showName.length > 0)
                        msgFrom = userData.showName;
                }
                cellString = [NSString stringWithFormat:@"%@ recalled a message",msgFrom];
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
    
    if (cellString.length > 0) {
        NSString *identifier = (type == EaseChatWeakRemindMsgTime) ? @"EaseMessageTimeCell" : @"AgoraChatMessageSystemHint";
        EaseMessageTimeCell *cell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseMessageTimeCell alloc] initWithViewModel:_viewModel remindType:type];
        }
        
        cell.timeLabel.text = cellString;
        return cell;
    }
    
    if (cellNotifyMap.count > 0) {
        NSString *identifier = @"AgoraChatMessageSystemHintThread";
        EaseMessageTimeCell *cell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseMessageTimeCell alloc] initWithViewModel:_viewModel remindType:type];
        }
        NSString *text = cellNotifyMap.allKeys.firstObject;
        cell.timeLabel.attributedText = [cell cellAttributeText:text];
        return cell;
    }
    
    EaseMessageModel *model = (EaseMessageModel *)obj;
    if (self.delegate && [self.delegate respondsToSelector:@selector(editedMessageContentSymbol)]) {
        if ([model isKindOfClass:[EaseMessageModel class]]&&!IsStringEmpty(model.message.body.operatorId)) {
            model.editSymbol = [self.delegate editedMessageContentSymbol];
        }
    }
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
    model.isHeader = NO;
    if (cell.model.message.body.type == AgoraChatMessageTypeVoice) {
        cell.model.weakMessageCell = cell;
    }
    cell.model = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editMode == NO) {
        //NSLog(@"indexpath.row : %ld ", (long)indexPath.row);
        id obj = [self.dataArray objectAtIndex:indexPath.row];
        NSString *cellString = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            cellString = (NSString *)obj;
        }
        NSDictionary *cellNotifyMap;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            cellNotifyMap = (NSDictionary *)obj;
        }
        cellString = cellNotifyMap.allKeys.firstObject;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageTimeCell class]] && [cellString containsString:@"thread"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(joinChatThreadFromNotifyMessage:)]) {
                [self.delegate joinChatThreadFromNotifyMessage:cellNotifyMap.allValues.firstObject];
            }
        }
    } else {
        id obj = [self.dataArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel* model = (EaseMessageModel*)obj;
            model.selected = !model.selected;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)threadsList {
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isChatThread == YES) {
        if (self.dataArray.count - 1 == indexPath.row && self.cursor.list.count == chatThreadPageSize && self.loadFinished == YES) {
            self.loadFinished = NO;
            [self loadData:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.endScroll = YES;
    [self.view endEditing:YES];
    [self.inputBar clearMoreViewAndSelectedButton];
    [self hideLongPressView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   self.endScroll = YES;
   if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewEndScroll)]) {
       [self.delegate scrollViewEndScroll];
   }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.highLightIndexPath && (self.highLightIndexPath.section == 0 && self.highLightIndexPath.row < self.dataArray.count)) {
        EaseMessageCell* cell = [self.tableView cellForRowAtIndexPath:self.highLightIndexPath];
        if (cell && [cell isKindOfClass:[EaseMessageCell class]]) {
            [cell showHighlight];
        }
    }
}

#pragma mark - EaseInputMenuDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:ShouldChangeTextInRange:replacementText:)]) {
        BOOL isValid = [self.delegate textView:textView ShouldChangeTextInRange:range replacementText:text];
        return isValid;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
}

- (void)inputBarSendMsgAction:(NSString *)text
{
    if ((text.length > 0 && ![text isEqualToString:@""])) {
        if (self.inputBar.quoteMessage) {
            NSDictionary *msgTypeDict = @{
                @(AgoraChatMessageBodyTypeText): @"txt",
                @(AgoraChatMessageBodyTypeImage): @"img",
                @(AgoraChatMessageBodyTypeVideo): @"video",
                @(AgoraChatMessageBodyTypeVoice): @"audio",
                @(AgoraChatMessageBodyTypeCustom): @"custom",
                @(AgoraChatMessageBodyTypeCmd): @"cmd",
                @(AgoraChatMessageBodyTypeFile): @"file",
                @(AgoraChatMessageBodyTypeLocation): @"location",
                @(AgoraChatMessageBodyTypeCombine): @"combine"
            };
            [self sendTextAction:text ext:@{@"msgQuote": @{
                @"msgID": self.inputBar.quoteMessage.messageId,
                @"msgPreview": self.inputBar.quoteMessage.easeUI_quoteShowText,
                @"msgSender": self.inputBar.quoteMessage.from,
                @"msgType": msgTypeDict[@(self.inputBar.quoteMessage.body.type)]
            }}];
            self.inputBar.quoteMessage = nil;
        } else {
            [self sendTextAction:text ext:nil];
        }
        [self.inputBar clearInputViewText];
    }
}

- (void)inputBarDidShowToolbarAction
{
    [self hideLongPressView];
//    [self.tableView Ease_updateConstraints:^(EaseConstraintMaker *make) {
//        make.bottom.equalTo(self.inputBar.ease_top);
//    }];
    
    [self performSelector:@selector(scrollToBottomRow) withObject:nil afterDelay:0.1];
}

- (void)didSelectExtFuncPopupView
{

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

- (NSString *)inputMenuQuoteMessageShowContent:(AgoraChatMessage *)message
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBarQuoteMessageShowContent:)]) {
        return [_delegate chatBarQuoteMessageShowContent:message];
    }
    return nil;
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
    [self inputBarSendMsgAction:self.inputBar.text];
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellDidSelected:(EaseMessageCell *)aCell
{
    if (self.editMode) {
        aCell.model.selected = !aCell.model.selected;
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:aCell]] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    [self hideLongPressView];
    BOOL isCustom = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMessageItem:userProfile:)]) {
        isCustom = [self.delegate didSelectMessageItem:aCell.model.message userProfile:aCell.model.userDataProfile];
        if (!isCustom) return;
    }
    if (aCell.model.message.body.type != AgoraChatMessageBodyTypeCombine) {
        //Message event policy classification
        AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:aCell.model.type];
        eventStrategy.chatController = self;
        aCell.model.isPlaying = !aCell.model.isPlaying;
        [eventStrategy messageCellEventOperation:aCell];
    } else {
        [self lookupCombineMessage:aCell.model.message];
    }
}

- (void)lookupCombineMessage:(AgoraChatMessage *)message
{
    ForwardMessagesViewController *VC = [[ForwardMessagesViewController alloc] initWithMessage:message userProfiles:self.profiles];
    [self.navigationController pushViewController:VC animated:YES];
}


//Message long press event
- (void)messageCellDidLongPress:(UITableViewCell *)aCell cgPoint:(CGPoint)point
{
    [self.view endEditing:YES];
    if (aCell != _currentLongPressCell) {
        [self hideLongPressView];
    }
    self.longPressIndexPath = [self.tableView indexPathForCell:aCell];
    if (!self.longPressIndexPath) {
        return;
    }
    __weak typeof(self) weakself = self;
    EaseExtendMenuModel *copyExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"copy"] funcDesc:@"Copy" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself copyLongPressAction];
    }];
    EaseExtendMenuModel *deleteExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"delete"] funcDesc:@"Delete" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself deleteLongPressAction:^(AgoraChatMessage *deleteMsg) {
            if (deleteMsg) {
                NSUInteger index = [weakself.messageList indexOfObject:deleteMsg];
                if (index != NSNotFound) {
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
    EaseExtendMenuModel *selectExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"multiple"] funcDesc:@"Select" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageListEntryEditModeWhetherShowBottom)]) {
            weakself.editMode = YES;
            BOOL show = [self.delegate messageListEntryEditModeWhetherShowBottom];
            if (!show) {
                return;
            }
        }
        if ([aCell isKindOfClass:[EaseMessageCell class]]) {
            ((EaseMessageCell*)aCell).model.selected = YES;
        }
        [weakself editModeAction];
    }];
    EaseExtendMenuModel *recallExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"unsend"] funcDesc:@"Unsend" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself recallLongPressAction];
    }];
    
    EaseExtendMenuModel *quoteModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"reply"] funcDesc:@"Reply" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        EaseMessageModel *model = [weakself.dataArray objectAtIndex:weakself.longPressIndexPath.row];
        weakself.inputBar.quoteMessage = model.message;
        [weakself.inputBar raiseKeyboard];
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
        
        if (_currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeText ||  _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeImage || _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeVideo || _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeFile || _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeVoice || _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeCombine || _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeLocation) {
            if (self.currentConversation.type == AgoraChatConversationTypeGroupChat && !self.currentConversation.isChatThread && _currentLongPressCell.model.message.chatThread == nil) {
                EaseExtendMenuModel *creatThread = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"groupThread"] funcDesc:@"Create Thread" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
                    if ([aCell isKindOfClass:[EaseMessageCell class]]) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(createThread:)]) {
                            [self.delegate createThread:((EaseMessageCell*)aCell).model];
                        } else {
                            [weakself createThread:((EaseMessageCell*)aCell).model];
                        }
                    }
                }];
                [extMenuArray addObject:creatThread];
            }
            if (_currentLongPressCell.model.message.direction == AgoraChatMessageDirectionSend && (currentTimestamp - _currentLongPressCell.model.message.timestamp <= 120000)) {
                [extMenuArray addObject:recallExtModel];
            }
        }
    }
    if (_currentLongPressCell && _currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeText) {
        [extMenuArray addObject:copyExtModel];
    }
    
    
    EaseMessageModel *model = _currentLongPressCell.model;
    if (model.message.status == AgoraChatMessageStatusSucceed)
        [extMenuArray addObject:quoteModel];
    if (_currentLongPressCell.model.message.body.type == AgoraChatMessageBodyTypeText) {
        EaseExtendMenuModel *editItem = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"edit"] funcDesc:@"Edit" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
            if ([weakself.delegate respondsToSelector:@selector(messageEditAction)]) {
                [weakself.delegate messageEditAction];
                return;
            }
            [weakself modifyAction:model];
        }];
        [extMenuArray addObject:editItem];
    }
    [extMenuArray addObject:selectExtModel];
    [extMenuArray addObject:deleteExtModel];
    if (isCustomCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customCellLongPressExtMenuItemArray:customCell:)]) {
            //自定义cell长按
            extMenuArray = [self.delegate customCellLongPressExtMenuItemArray:extMenuArray customCell:_currentLongPressCustomCell];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(messageLongPressExtMenuItemArray:message:)]) {
        //默认消息长按
        extMenuArray = [self.delegate messageLongPressExtMenuItemArray:extMenuArray message:_currentLongPressCell.model.message];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(messageLongPressExtMenuItemArray:messageModel:)]) {
        //默认消息长按
        extMenuArray = [self.delegate messageLongPressExtMenuItemArray:extMenuArray messageModel:_currentLongPressCell.model];
    }
    if ([extMenuArray count] <= 0) {
        return;
    }
    
    NSDictionary *userInfo;
    if (_currentLongPressCell.model.message) {
        userInfo = @{
            @"message": _currentLongPressCell.model.message
        };
    }
    BOOL showReaction = YES;
    if (self.conversationType == AgoraChatTypeChatRoom) {
        showReaction = NO;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(messageLongPressExtShowReaction:)]) {
        showReaction = [_delegate messageLongPressExtShowReaction:_currentLongPressCell.model.message];
    }
    [EMBottomMoreFunctionView showMenuItems:extMenuArray showReaction:showReaction delegate:self ligheViews:nil animation:YES userInfo:userInfo];
}

- (void)modifyAction:(EaseMessageModel *)model {
    __weak typeof(self) weakself = self;
    self.editor = [[MessageEditor alloc] initWithFrame:self.view.window.frame message:model.message doneClosure:^(NSString * _Nonnull content) {
        [weakself modifyMessage:content model:model];
    }];
    [self.view.window addSubview:self.editor];
}

- (void)modifyMessage:(NSString *)content model:(EaseMessageModel *)model {
    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:content];
    body.targetLanguages = ((AgoraChatTextMessageBody *)model.message.body).targetLanguages;
    [self showHudInView:self.view hint:@"Modifying message..."];
    __weak typeof(self) weakself = self;
    [AgoraChatClient.sharedClient.chatManager modifyMessage:model.message.messageId body:body completion:^(AgoraChatError * _Nullable error, AgoraChatMessage * _Nullable message) {
        [weakself hideHud];
        if (!error) {
            [weakself.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[EaseMessageModel class]]) {
                    EaseMessageModel *model = (EaseMessageModel *)obj;
                    if ( model.message &&[model.message.messageId isEqualToString:message.messageId]) {
                        model.message = message;
                        UITableViewCell *cell = [weakself.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                        if ([cell isKindOfClass:[EaseMessageCell class]]) {
                            EaseMessageCell *messageCell = (EaseMessageCell*)cell;
                            [weakself.dataArray replaceObjectAtIndex:idx withObject:[[EaseMessageModel alloc] initWithAgoraChatMessage:model.message]];
                            if ([weakself.tableView.visibleCells containsObject:cell]) {
                                [weakself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            }
                            *stop = YES;
                        }
                    }
                }
            }];
        } else {
            [weakself showHint:error.errorDescription];
        }
    }];
}

//- (EditNavigationBar *)editNavigation {
//    if (!_editNavigation) {
//        _editNavigation = [[EditNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, EMNavgationHeight) cancel:^{
//
//        }];
//        _editNavigation.backgroundColor = [UIColor whiteColor];
//    }
//    return _editNavigation;
//
//}

- (EditToolBar *)toolBar {
    if (!_toolBar) {
        __weak typeof(self) weakself = self;
        _toolBar = [[EditToolBar alloc] initWithFrame:CGRectMake(0, EMScreenHeight - 54 - EaseVIEWBOTTOMMARGIN, EMScreenWidth, EaseVIEWBOTTOMMARGIN+54) operationClosure:^(enum EditBarOperationType type) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageListEntryEditModeThenOperation:)]) {
                [self.delegate messageListEntryEditModeThenOperation:type];
            }
        }];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}


- (void)setEditMode:(BOOL)editMode {
    _editMode = editMode;
    for (id obj in self.dataArray) {
        if ([obj isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel *model = (EaseMessageModel*)obj;
            model.editMode = editMode;
        }
    }
    [self.tableView reloadData];
}


- (void)editModeAction {
    self.editMode = YES;
}

- (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [[UIApplication sharedApplication] connectedScenes]) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                if (scene.windows.firstObject.window.isKeyWindow) {
                    return scene.windows.firstObject.window;
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}


- (void)messageCellDidClickQuote:(EaseMessageCell *)aCell {
    [self hideLongPressView];
        if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidClickQuote:)]) {
            if (![_delegate messageCellDidClickQuote:aCell.model.message]) {
                return;
            }
        }
        NSString *msgId = aCell.model.message.ext[@"msgQuote"][@"msgID"];
        if (msgId.length <= 0) {
            [self showHint:@"Message does not exist"];
            return;
        }
        
//        _searchRowAction.isSearching = YES;
//        _searchRowAction.currentSearchPage = 1;
//        _searchRowAction.messageId = msgId;
        BOOL messageExist = NO;
        for (int i = (int)_dataArray.count - 1; i >= 0; i --) {
            EaseMessageModel *model = self.dataArray[i];
            if ([model isKindOfClass:EaseMessageModel.class] && [model.message.messageId isEqualToString:msgId]) {
                messageExist = YES;
                if (model.type == AgoraChatMessageTypeImage || model.type == AgoraChatMessageTypeVideo || model.type == AgoraChatMessageTypeFile || model.type == AgoraChatMessageTypeCombine) {
                    if (model.type == AgoraChatMessageTypeCombine) {
                        [self lookupCombineMessage:model.message];
                    } else {
                        AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:model.type];
                        eventStrategy.chatController = self;
                        aCell.quoteModel = model;
                        [eventStrategy messageCellEventOperation:aCell];
                    }
                } else {
                    NSArray <NSIndexPath *>*indexPaths = [_tableView indexPathsForVisibleRows];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    BOOL isVisibleCell = NO;
                    for (NSIndexPath *i in indexPaths) {
                        if ([i isEqual:indexPath]) {
                            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                            if (cell) {
                                if ([cell isKindOfClass:EaseMessageCell.class]) {
                                    [((EaseMessageCell *)cell) showHighlight];
                                }
                                self.highLightIndexPath = nil;
                            }
                            isVisibleCell = YES;
                            break;
                        }
                    }
                    if (!isVisibleCell) {
                        self.highLightIndexPath = indexPath;
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                    }
                }
//                _searchRowAction.isSearching = NO;
                return;
            }
        }
    if (messageExist == NO) {
        //[self showHint:@"Message does not exist"];
    }
        [self dropdownRefreshTableViewWithData];
}

- (void)messageCellDidLongPressQuote:(EaseMessageCell *)aCell {
    [self hideLongPressView];
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidLongPressQuote:)]) {
        if (![_delegate messageCellDidLongPressQuote:aCell.model.message]) {
            return;
        }
    }
}

- (void)createThread:(EaseMessageModel *)model {
    EaseThreadCreateViewController *vc = [[EaseThreadCreateViewController alloc] initWithType:EMThreadHeaderTypeCreate viewModel:_viewModel message:model];
    vc.navigationItem.leftBarButtonItem.title = @"New Thread";
    [vc.dataArray addObjectsFromArray:@[model]];
    [self.navigationController pushViewController:vc animated:YES];
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
        if (!model.userDataProfile) {
        } else
            [self.delegate avatarDidLongPress:model.userDataProfile];
    }
}

- (void)messageCellDidClickReactionView:(EaseMessageModel *)model {
    [self.inputBar resignFirstResponder];
    __weak typeof(self)weakSelf = self;
    [EMBottomReactionDetailView showMenuItems:model.message animation:YES didRemoveSelfReaction:^(NSString * _Nonnull reaction) {
//        __weak typeof(self)weakSelf = self;
//        [AgoraChatClient.sharedClient.chatManager removeReaction:reaction fromMessage:model.message.messageId completion:^(AgoraChatError * _Nullable error) {
//            if (error) {
//                return;
//            }
            [weakSelf reloadVisibleRowsWithMessageIds:[NSSet setWithObject:model.message.messageId]];
//            __strong typeof(weakSelf)strongSelf = self;
//            if (strongSelf) {
//                NSArray *hightlightViews;
//                id<EMMaskHighlightViewDelegate> aCell = strongSelf->_currentLongPressCell;
//                if (!aCell) {
//                    aCell = strongSelf->_currentLongPressCustomCell;
//                }
//                if ([aCell conformsToProtocol:@protocol(EMMaskHighlightViewDelegate)] && [aCell respondsToSelector:@selector(maskHighlight)]) {
//                    hightlightViews = [((id<EMMaskHighlightViewDelegate>)aCell) maskHighlight];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [EMBottomMoreFunctionView updateHighlightViews:hightlightViews];
//                    });
//                }
//            }
//        }];
    }];
}

- (void)messageCellNeedReload:(EaseMessageCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && indexPath.row < self.dataArray.count) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -- EaseMoreFunctionViewDelegate
- (void)menuExtItemDidSelected:(EaseExtendMenuModel *)menuItemModel extType:(ExtType)extType
{
    if (extType != ExtTypeChatBar) {
        [self hideLongPressView];
    }
}

- (void)toThreadChat:(EaseMessageModel *)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectThreadBubble:)]) {
        [self.delegate didSelectThreadBubble:model];
        return;
    }
    [self pushThreadChat:model];
}

- (void)pushThreadChat:(EaseMessageModel *)model {
    if (!model.message.chatThread.threadId.length) {
        [self showHint:@"conversationId is empty!"];
        return;
    }
    [AgoraChatClient.sharedClient.threadManager joinChatThread:model.message.chatThread.threadId completion:^(AgoraChatThread *thread,AgoraChatError *aError) {
        if (!aError || aError.code == AgoraChatErrorUserAlreadyExist) {
            if (thread) {
                model.thread = thread;
            }
            EaseThreadChatViewController *VC = [[EaseThreadChatViewController alloc] initThreadChatViewControllerWithCoversationid:model.message.chatThread.threadId chatViewModel:self.viewModel parentMessageId:model.message.messageId model:model];
            self.title = model.thread ? model.thread.threadName:model.message.chatThread.threadName;;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
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

- (void)onMessageContentChanged:(AgoraChatMessage *)message operatorId:(NSString *)operatorId operationTime:(NSUInteger)operationTime {
    __weak typeof(self) weakSelf = self;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([obj isKindOfClass:[EaseMessageModel class]]) {
           EaseMessageModel *model = (EaseMessageModel *)obj;
           if ([model.message.messageId isEqualToString:message.messageId]) {
               model.message = message;
               NSIndexPath* indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
               UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
               if ([cell isKindOfClass:[EaseMessageCell class]]) {
                   EaseMessageCell *messageCell = (EaseMessageCell*)cell;
                   EaseMessageModel *editModel = [[EaseMessageModel alloc] initWithAgoraChatMessage:model.message];
                   [weakSelf.dataArray replaceObjectAtIndex:idx withObject:editModel];
                   if ([self.tableView.visibleCells containsObject:cell]) {
                       [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                   }
                   *stop = YES;
               }
           }
       }
    }];
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

- (void)messagesInfoDidRecall:(NSArray<AgoraChatRecallMessageInfo *> *)aRecallMessagesInfo
{
    __block NSDictionary *dic;
    NSMutableArray<NSString*>* messageIds = [NSMutableArray array];
    [aRecallMessagesInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AgoraChatRecallMessageInfo *recallMessageInfo = (AgoraChatRecallMessageInfo *)obj;
        [messageIds addObject:recallMessageInfo.recallMessage.messageId];
        [[[self.dataArray reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([((NSDictionary *)obj).allValues.firstObject isEqualToString:recallMessageInfo.recallMessage.messageId]) {
                    dic = obj;
                    *stop = YES;
                }
            }
        }];
    }];
    
    [self handleMessagesRemove:messageIds];
    __weak typeof(self) weakself =self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.dataArray removeObject:dic];
        [weakself refreshTableView:NO];
    });
}

- (void)handleMessagesRemove:(NSArray<NSString*>*) messageIds
{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[EaseMessageModel class]]) {
            NSDictionary *quoteInfo = [((EaseMessageModel*)obj).message.ext objectForKey:@"msgQuote"];
            if (quoteInfo) {
                NSString *quoteMsgId = quoteInfo[@"msgID"];
                if (quoteMsgId.length > 0 && [messageIds containsObject:quoteMsgId]) {
                    ((EaseMessageModel*)obj).quoteContent =  nil;
                }
            }
        }
    }];
}


- (void)msgStatusDidChange:(AgoraChatMessage *)aMessage
                         error:(AgoraChatError *)aError
{
    __weak typeof(self) weakself = self;
    dispatch_async(self.msgQueue, ^{
        NSString *conId = weakself.currentConversation.conversationId;
        if (![conId isEqualToString:aMessage.conversationId]){
            return ;
        }
        
        __block NSUInteger index = NSNotFound;
        __block EaseMessageModel *reloadModel = nil;
        [weakself.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[EaseMessageModel class]]) {
                EaseMessageModel *model = (EaseMessageModel *)obj;
                if ([model.message.messageId isEqualToString:aMessage.messageId]) {
                    reloadModel = model;
                    index = idx;
                    *stop = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BOOL refresh = NO;
                        for (EaseMessageCell *cell in weakself.tableView.visibleCells) {
                            if ([cell isKindOfClass:[EaseMessageCell class]] && [weakself.tableView indexPathForCell:cell].row == index) {
                                refresh = YES;
                                break;
                            }
                        }
                        if (index != NSNotFound) {
                            [weakself.dataArray replaceObjectAtIndex:index withObject:reloadModel];
                            if (refresh) {
                                [weakself.tableView reloadData];
                            }
                        }
                    });
                }
            }
        }];
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

#pragma mark - EMReaction
- (void)messageReactionDidChange:(NSArray<AgoraChatMessageReactionChange *> *)changes
{
    NSMutableSet *refreshMessageIds = [NSMutableSet set];
    for (AgoraChatMessageReactionChange *change in changes) {
        [refreshMessageIds addObject:change.messageId];
    }
    [self reloadVisibleRowsWithMessageIds:refreshMessageIds];
    
//    NSArray *hightlightViews;
//    id<EMMaskHighlightViewDelegate> aCell = _currentLongPressCell;
//    if (!aCell) {
//        aCell = _currentLongPressCustomCell;
//    }
//
//    if ([aCell conformsToProtocol:@protocol(EMMaskHighlightViewDelegate)] && [aCell respondsToSelector:@selector(maskHighlight)]) {
//        hightlightViews = [((id<EMMaskHighlightViewDelegate>)aCell) maskHighlight];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [EMBottomMoreFunctionView updateHighlightViews:hightlightViews];
//        });
//    }
}

- (void)reloadVisibleRowsWithMessageIds:(NSSet <NSString *>*)messageIds {
    NSArray *visibleRows = [_tableView indexPathsForVisibleRows];
    NSMutableArray <NSIndexPath *>*refreshRows = [NSMutableArray array];
    for (NSIndexPath *row in visibleRows) {
        id obj = self.dataArray[row.row];
        if ([obj isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel *model = (EaseMessageModel *)obj;
            if ([messageIds containsObject:model.message.messageId]) {
                if (self.isChatThread == YES) {
                    AgoraChatMessage *message = [[AgoraChatClient sharedClient].chatManager getMessageWithMessageId:model.message.messageId];
                    if (message.messageId.length) {
                        model.message = message;
                    }
                }
                [refreshRows addObject:row];
            }
        }
    }
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:refreshRows withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}

#pragma mark - EMBottomMoreFunctionView
- (BOOL)bottomMoreFunctionViewShowReaction:(EMBottomMoreFunctionView *)view
{
    return ChatUIOptions.shareOptions.reactionOptions.isOpen;
}

- (void)bottomMoreFunctionView:(EMBottomMoreFunctionView *)view didSelectedMenuItem:(EaseExtendMenuModel *)model {
    if (model.itemDidSelectedHandle) {
        model.itemDidSelectedHandle(model.funcDesc, YES);
    }
    
    [EMBottomMoreFunctionView hideWithAnimation:YES needClear:NO];
}

- (void)bottomMoreFunctionView:(EMBottomMoreFunctionView *)view didSelectedEmoji:(NSString *)emoji changeSelectedStateHandle:(void (^)(void))changeSelectedStateHandle {
    EaseMessageModel *model = [self.dataArray objectAtIndex:self.longPressIndexPath.row];
    if (!model || ![model isKindOfClass:EaseMessageModel.class]) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    void(^refreshBlock)(AgoraChatError *, void(^changeSelectedStateHandle)(void)) = ^(AgoraChatError *error, void(^changeSelectedStateHandle)(void) ) {
        if (error) {
            return;
        }
        [weakSelf reloadVisibleRowsWithMessageIds:[NSSet setWithObject:model.message.messageId]];
//        __strong typeof(weakSelf)strongSelf = self;
//        if (strongSelf) {
//            NSArray *hightlightViews;
//            UITableViewCell *aCell = strongSelf->_currentLongPressCell;
//            if (!aCell) {
//                aCell = strongSelf->_currentLongPressCustomCell;
//            }
//            if ([aCell conformsToProtocol:@protocol(EMMaskHighlightViewDelegate)] && [aCell respondsToSelector:@selector(maskHighlight)]) {
//                hightlightViews = [((id<EMMaskHighlightViewDelegate>)aCell) maskHighlight];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [EMBottomMoreFunctionView updateHighlightViews:hightlightViews];
//                });
//            }
//        }
        if (changeSelectedStateHandle) {
            changeSelectedStateHandle();
        }
    };
    
    if (![model.message getReaction:emoji].isAddedBySelf) {
        [AgoraChatClient.sharedClient.chatManager addReaction:emoji toMessage:model.message.messageId completion:^(AgoraChatError * _Nullable error) {
            refreshBlock(error, changeSelectedStateHandle);
        }];
    } else {
        [AgoraChatClient.sharedClient.chatManager removeReaction:emoji fromMessage:model.message.messageId completion:^(AgoraChatError * _Nullable error) {
            refreshBlock(error, changeSelectedStateHandle);
        }];
    }
    [EMBottomMoreFunctionView hideWithAnimation:YES needClear:NO];
}

- (BOOL)bottomMoreFunctionView:(EMBottomMoreFunctionView *)view getEmojiIsSelected:(NSString *)emoji userInfo:(nonnull NSDictionary *)userInfo {
    AgoraChatMessage *msg = userInfo[@"message"];
    if (!msg) {
        return NO;
    }
    
    AgoraChatMessageReaction *reactionObj = [msg getReaction:emoji];
    if (!reactionObj) {
        return NO;
    }
    return reactionObj.isAddedBySelf;
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
        if ([self.dataArray.lastObject isKindOfClass:[EaseMessageModel class]]) {
            toRow = self.dataArray.count - 1;
        } else {
            EaseMessageModel *tmp;
            for (EaseMessageModel *model in [[self.dataArray reverseObjectEnumerator] allObjects]) {
                if ([model isKindOfClass:[EaseMessageModel class]]) {
                    tmp = model;
                    toRow = [self.dataArray indexOfObject:tmp];
                    break;
                }
            }
        }
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)scrollToTopRow
{
    [self hideLongPressView];
    if ([self.dataArray count] > 0) {
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Send Message

- (void)sendTextAction:(NSString *)aText
                    ext:(NSDictionary *)aExt
{
    if ([aText length] == 0) {
        return;
    }
    NSString* tmp = [EaseEmojiHelper convertFromEmoji:aText];
    AgoraChatTextMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:tmp];
    [self sendMessageWithBody:body ext:aExt];
    if(![aExt objectForKey:MSG_EXT_GIF]){
        [self.inputBar clearInputViewText];
    }
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
    if (self.isChatThread == YES) {
        if (self.dataArray.count <= 0) {
            self.moreMsgId = @"";
        }
        [AgoraChatClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.currentConversation.conversationId conversationType:self.currentConversation.type startMessageId:self.moreMsgId fetchDirection:AgoraChatMessageFetchHistoryDirectionDown pageSize:10 completion:^(AgoraChatCursorResult *aResult, AgoraChatError *aError) {
            weakself.loadFinished = YES;
            if (!aError) {
                weakself.cursor = aResult;
                weakself.moreMsgId = weakself.cursor.cursor;
                [weakself refreshTableViewWithData:aResult.list isInsertBottom:YES isScrollBottom:isScrollBottom];
            }
        }];
    } else {
        [self.currentConversation loadMessagesStartFromId:self.moreMsgId count:50 searchDirection:AgoraChatMessageSearchDirectionUp completion:block];
    }
}

- (NSArray *)formatMessages:(NSArray<AgoraChatMessage *> *)aMessages
{
    NSMutableArray *formated = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [aMessages count]; i++) {
        AgoraChatMessage *msg = aMessages[i];
        if (self.isChatThread == YES) {
            if (msg.chatType == AgoraChatTypeChat && msg.isReadAcked && (msg.body.type == AgoraChatMessageBodyTypeText || msg.body.type == AgoraChatMessageBodyTypeLocation)) {
                [[AgoraChatClient sharedClient].chatManager sendMessageReadAck:msg.messageId toUser:msg.conversationId completion:nil];
            }
            
            if (msg.chatType == AgoraChatTypeGroupChat && msg.isNeedGroupAck && !msg.isReadAcked) {
                [[AgoraChatClient sharedClient].chatManager sendGroupMessageReadAck:msg.messageId toGroup:msg.conversationId content:@"123" completion:nil];
            }
        }
        
        CGFloat interval = (self.msgTimelTag - msg.timestamp) / 1000;
        NSString *timeStr;
        if (self.msgTimelTag < 0 || interval > 60 || interval < -60) {
            timeStr = [EaseDateHelper formattedTimeFromTimeInterval:msg.timestamp dateType:EaseDateTypeChat];
            [formated addObject:timeStr];
            self.msgTimelTag = msg.timestamp;
        }
       
        EaseMessageModel *model = nil;
        model = [[EaseMessageModel alloc] initWithAgoraChatMessage:msg];
        if (!model) {
            model = [[EaseMessageModel alloc]init];
        }
        __weak typeof(self) weakself = self;
        BOOL modelNeedReload = [model valueForKey:@"needReload"];
        if (modelNeedReload) {
            [model setValue:^{
                            [weakself handleMessagesRemove:@[model.message.messageId]];
                            [weakself refreshTableView:NO];
            } forKey:@"loadCompleteBlock"];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellQuoteViewShowContent:)]) {
            if (model.quoteContent.string.length > 0) {
                model.quoteContent = [self.delegate messageCellQuoteViewShowContent:msg];
                model.quoteHeight;
            }
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
                    if (msg.chatThread) {
                        if (msg.chatThread.lastMessage.from != nil && msg.chatThread.lastMessage.from.length > 0) {
                            id<EaseUserProfile> userThreadData = [self.delegate userProfile:msg.chatThread.lastMessage.from];
                            model.threadUserProfile = userThreadData;
                        }
                    }
                }
            }
        }
        model.editMode = self.editMode;
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
            if (message.body.type != AgoraChatMessageTypeCmd && [[self.messageIdsMap valueForKey:message.messageId] boolValue] == NO) {
                [tempMsgs addObject:message];
                [self.messageIdsMap setValue:@(YES) forKey:message.messageId];
            }
        }
        if (isInsertBottom) {
            [weakself.messageList addObjectsFromArray:tempMsgs];
        } else {
            [weakself.messageList insertObjects:tempMsgs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempMsgs count])]];
            if (tempMsgs.count > 0) {
                AgoraChatMessage *msg = tempMsgs[0];
                weakself.moreMsgId = msg.messageId;
            }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
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
    [EMBottomMoreFunctionView hideWithAnimation:YES needClear:YES];
//    [self.longPressView removeFromSuperview];
//    [self resetCellLongPressStatus:_currentLongPressCell];
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
//    [self.view endEditing:YES];
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    NSString *to = self.currentConversation.conversationId;
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:to from:from to:to body:aBody ext:aExt];
    //Whether a reading receipt needs to be sent
    if([aExt objectForKey:MSG_EXT_READ_RECEIPT]) {
        message.isNeedGroupAck = YES;
    }
    message.chatType = (AgoraChatType)self.conversationType;
    message.isChatThreadMessage = self.isChatThread;
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
    BOOL sendRefresh = NO;
    if (self.isChatThread == NO) {
        sendRefresh = YES;
    } else if (self.isChatThread == YES && self.cursor.list.count < chatThreadPageSize) {
        sendRefresh = YES;
    }
    if (!self.moreMsgId) {
        //The first message of a new session
        self.moreMsgId = message.messageId;
    }
    if (sendRefresh == YES) {
        NSArray *formated = [self formatMessages:@[message]];
        [self.dataArray addObjectsFromArray:formated];
        [self.messageList addObject:message];
        [self refreshTableView:YES];
    }
    
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself msgStatusDidChange:message error:error];
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(didSendMessage:error:)]) {
            [weakself.delegate didSendMessage:message error:error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakself.view endEditing:YES];
                [weakself showHint:error.errorDescription];
            }
        });
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
- (void)setEditingStatusVisible:(BOOL)typingIndicator{}

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
            if (weakself.isChatThread == YES) {
                if ( weakself.cursor.list.count < chatThreadPageSize) {
                    [weakself scrollToBottomRow];
                }
            } else [weakself scrollToBottomRow];
        } else {
            if (weakself.isChatThread == YES && weakself.dataArray.count < chatThreadPageSize) {
                [weakself scrollToTopRow];
            }
        }
    });
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 130;
        _tableView.scrollsToTop = NO;
        if (self.isChatThread != YES) {
            [_tableView enableRefresh:@"Refreshing this conversation" color:UIColor.systemGrayColor];
            [_tableView.refreshControl addTarget:self action:@selector(dropdownRefreshTableViewWithData) forControlEvents:UIControlEventValueChanged];
        }
        _tableView.tableFooterView = [[UIView alloc] init];
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
