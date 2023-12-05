//
//  AgoraChatThreadCreateViewController.m
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/18.
//

#import "EaseThreadCreateViewController.h"
#import "UIViewController+ComponentSize.h"
#import "EaseHeaders.h"
#import "EMMsgTouchIncident.h"
#import "EaseInputMenu+Private.h"
#import "UIAlertAction+Custom.h"
#import "EaseThreadCreateViewController+ChatToolBarMeida.h"
#import "EMAudioPlayerUtil.h"
#import "EaseThreadChatViewController.h"
@interface EaseThreadCreateViewController ()<EaseInputMenuDelegate>

@property (nonatomic, strong) EaseInputMenu *inputBar;

@property (nonatomic, strong) EaseMessageModel *message;

@property (nonatomic) NSString *threadName;

@end

@implementation EaseThreadCreateViewController

- (instancetype)initWithType:(EMThreadHeaderType)type viewModel:(EaseChatViewModel *)viewModel message:(EaseMessageModel *)message {
    if ([super init]) {
        _viewModel = viewModel;
        _displayType = type;
        self.message = message;
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObject:message];
        [self _setupChatBarMoreViews];
    }
    return self;
}

- (void)setupInputMenu:(EaseInputMenu *)inputBar {
    _inputBar = inputBar;
}

- (void)setChatVCWithViewModel:(EaseChatViewModel *)viewModel {
    _viewModel = viewModel;
}

- (void)stopAudioPlayer {
    [[EMAudioPlayerUtil sharedHelper] stopPlayer];
}

- (void)dealloc {
    [[EMAudioPlayerUtil sharedHelper] stopPlayer];
    //Refreshing the session list
    [[NSNotificationCenter defaultCenter] postNotificationName:CONVERSATIONLIST_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = _viewModel.chatViewBgColor;
//    UIView *view = [self.parentViewController.view viewWithTag:-1999];
//    self.parentViewController.navigationController.navigationBar.hidden = YES;
    self.title = @"New Thread";
    [self.view addSubview:self.inputBar];
    [self.inputBar Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.inputBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView Ease_remakeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.inputBar.ease_top);
    }];
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

}

- (void)_setupChatBarMoreViews {
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
        [weakself chatToolBarComponentIncidentAction:AgoraChatToolBarPhotoAlbum];
    }];
    EaseExtendMenuModel *cameraExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"camera"] funcDesc:@"Camera" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself chatToolBarComponentIncidentAction:AgoraChatToolBarCamera];
    }];
    EaseExtendMenuModel *fileExtModel = [[EaseExtendMenuModel alloc]initWithData:[UIImage easeUIImageNamed:@"attachments"] funcDesc:@"Attachments" handle:^(NSString * _Nonnull itemDesc, BOOL isExecuted) {
        [weakself chatToolBarFileOpenAction];
    }];
    NSMutableArray<EaseExtendMenuModel*> *extMenuArray = [@[cameraExtModel,photoAlbumExtModel,fileExtModel] mutableCopy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarExtMenuItemArray:conversationType:)]) {
        extMenuArray = [self.delegate inputBarExtMenuItemArray:extMenuArray conversationType:AgoraChatConversationTypeGroupChat];
    }
    EaseExtendMenuView *moreFunction = [[EaseExtendMenuView alloc]initWithextMenuModelArray:extMenuArray menuViewModel:[[EaseExtMenuViewModel alloc]initWithType:ExtTypeChatBar itemCount:[extMenuArray count] extendMenuModel:_viewModel.extendMenuViewModel]];
    self.inputBar.extendMenuView = moreFunction;
}

//Sending message body
- (void)sendMessageWithBody:(AgoraChatMessageBody *)aBody ext:(NSDictionary * __nullable)aExt
{
    if (!self.threadName || [self.threadName isEqualToString:@""] || !self.message.message.messageId) {
        [self showHint:@"Please input your name or message!"];
        return;
    }
    __weak typeof(self) weakself = self;
    [[AgoraChatClient sharedClient].threadManager createChatThread:self.threadName messageId:self.message.message.messageId parentId:self.message.message.to completion:^(AgoraChatThread *thread, AgoraChatError *aError) {
        if (!aError) {
            [weakself sendMsgimpl:thread body:aBody ext:aExt];
        } else {
            [weakself showHint:aError.errorDescription];
        }
    }];
    
}

- (void)sendMsgimpl:(AgoraChatThread *)thread body:(AgoraChatMessageBody *)aBody ext:(NSDictionary * __nullable)aExt {
    if (!thread) {
        [self showHint:@"Thread create failed"];
        return;
    }
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    NSString *to = thread.threadId;
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:to from:from to:to body:aBody ext:aExt];
    message.chatType = AgoraChatTypeGroupChat;
    message.isChatThreadMessage = YES;
    __weak typeof(self) weakself = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendMessage:)]) {
        AgoraChatMessage *callbackMsg = [self.delegate willSendMessage:message];
        if (!callbackMsg || !callbackMsg.messageId || [callbackMsg.messageId isEqualToString:@""])
            return;
        [weakself sendMsgimpl:thread body:aBody ext:aExt];
    }
    [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:nil completion:^(AgoraChatMessage *message, AgoraChatError *error) {
        [weakself showHint:error.description];
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(didSendMessage:thread:error:)]) {
            [weakself.delegate didSendMessage:message thread:thread error:error];
            return;
        }
        if (!error) {
            [weakself pushThreadChat:thread];
        }
    }];
}

- (void)pushThreadChat:(AgoraChatThread *)thread {
    if (!thread.threadId.length) {
        [self showHint:@"conversationId can's empty!"];
        return;
    }
    self.message.thread = thread;
    EaseThreadChatViewController *VC = [[EaseThreadChatViewController alloc] initThreadChatViewControllerWithCoversationid:thread.threadId chatViewModel:_viewModel parentMessageId:self.message.message.messageId model:self.message];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Public

- (EaseInputMenu *)inputBar
{
    if (!_inputBar) {
        _inputBar = [[EaseInputMenu alloc] initWithViewModel:_viewModel];
        _inputBar.delegate = self;
    }
    return _inputBar;
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

#pragma mark - EaseInputMenuDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:ShouldChangeTextInRange:replacementText:)]) {
        BOOL isValid = [self.delegate textView:textView ShouldChangeTextInRange:range replacementText:text];
        return isValid;
    }
    return YES;
}

- (void)inputBarSendMsgAction:(NSString *)text
{
    if ((text.length > 0 && ![text isEqualToString:@""])) {
        [self sendTextAction:text ext:nil];
        [self.inputBar clearInputViewText];
        [self.view endEditing:YES];
    }
}

- (void)inputBarDidShowToolbarAction
{
    [self.tableView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.inputBar.ease_top);
    }];
    
}

- (void)didSelectExtFuncPopupView
{
    [self inputBarDidShowToolbarAction];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
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
    
    if (!self.inputBar.hidden) {
        [self keyBoardWillShow:note animations:animation completion:^(BOOL finished, CGRect keyBoardBounds) {
        }];
    }
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    void (^animation)(void) = ^void(void) {
        [self.inputBar Ease_updateConstraints:^(EaseConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    };
    
    if (!self.inputBar.hidden) {
        [self keyBoardWillHide:note animations:animation completion:nil];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellForItem:messageModel:)]) {
        UITableViewCell *customCell = [self.delegate cellForItem:tableView messageModel:model];
        if (customCell) {
            return customCell;
        }
    }
    NSString *identifier = [EaseThreadCreateCell cellIdentifierType:model.type];
    EaseThreadCreateCell *cell = (EaseThreadCreateCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseThreadCreateCell alloc] initWithMessageType:model.type displayType:_displayType viewModel:_viewModel];
    }
    cell.delegate = self;
    model.isHeader = YES;
    model.isPlaying = NO;
    if (cell.model.message.body.type == AgoraChatMessageTypeVoice) {
        cell.model.weakMessageCell = cell;
    }
    cell.model = model;
    return cell;
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


- (void)textFieldEndText:(NSString *)text {
    self.threadName = text;
}

- (void)textFieldShouldReturn:(NSString *)text
{
    self.inputBar.hidden = NO;
    [[self.inputBar viewWithTag:123] becomeFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)messageCellDidSelected:(EaseThreadCreateCell *)aCell
{
    BOOL isCustom = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMessageItem:userProfile:)]) {
        isCustom = [self.delegate didSelectMessageItem:aCell.model.message userProfile:aCell.model.userDataProfile];
        if (!isCustom) return;
    }
    //Message event policy classification
    AgoraChatMessageEventStrategy *eventStrategy = [AgoraChatMessageEventStrategyFactory getStratrgyImplWithMsgCell:aCell.model.type];
    eventStrategy.chatController = self;
    [eventStrategy messageCellEventOperation:aCell];
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
        _tableView.allowsSelection = NO;
        _tableView.allowsMultipleSelection = NO;
        _tableView.scrollsToTop = NO;
    }
    
    return _tableView;
}


- (void)setUserProfiles:(NSArray<id<EaseUserProfile>> *)userProfileAry
{
    if (!userProfileAry || userProfileAry.count == 0) return;
    
    //single chat
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.dataArray || self.dataArray.count == 0) return;

        //group chatroom
        for (int index = 0; index < self.dataArray.count; index++) {
            id obj = [self.dataArray objectAtIndex:index];
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

        [self.tableView reloadData];
    });
}


@end
