//
//  EaseChatView.m
//
//  Created by EaseMob on 16/5/9.
//  Copyright © 2016年 zilong.li All rights reserved.
//

#import "EaseChatView.h"
#import "EaseInputTextView.h"
#import "EaseChatroomMessageCell.h"
#import "EaseCustomSwitch.h"
#import "EaseChatroomJoinCell.h"
#import "EaseHeaders.h"


#define kSendTextButtonWitdh 190.0
#define kSendTextButtonHeight 32.0
#define kButtonHeight 40
#define kDefaultSpace 8.f
#define kDefaulfLeftSpace 10.f
#define kTextViewHeight 30.f


@interface EaseChatView () <AgoraChatManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSString *_chatroomId;
    
    long long _curtime;
    CGFloat _previousTextViewContentHeight;
    
    BOOL _isBarrageInfo;//弹幕消息
    
    NSTimer *_timer;
    NSInteger _praiseInterval;//点赞间隔
    NSInteger _praiseCount;//点赞计数
    
    EaseCustomMessageHelper* _customMsgHelper;
}


@property (nonatomic,strong) AgoraChatConversation *conversation;

//底部功能按钮
//@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *bottomSendMsgView;
@property (nonatomic,strong) EaseInputTextView *textView;
//@property (nonatomic,strong) EaseCustomSwitch *barrageSwitch;//弹幕开关
@property (nonatomic,strong) UIButton *sendButton;//发送按钮

@property (nonatomic,strong) UIView *activityView;
@property (nonatomic,assign) CGFloat height;

//set tableView backgroud color
@property (nonatomic, strong) UIColor *tableViewBgColor;
//set right margin of EaseChatView
@property (nonatomic, assign) CGFloat tableViewRightMargin;
//set right margin of EaseChatView
@property (nonatomic, assign) CGFloat tableViewBottomMargin;
//set sendTextButton right margin of EaseChatView
@property (nonatomic, assign) CGFloat sendTextButtonRightMargin;

@end

@implementation EaseChatView
#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame
                   chatroomId:(NSString*)chatroomId
{
    return [self initWithFrame:frame chatroomId:chatroomId isPublish:NO];
}

- (instancetype)initWithFrame:(CGRect)frame
                   chatroomId:(NSString*)chatroomId
                    isPublish:(BOOL)isPublish
                customMsgHelper:(EaseCustomMessageHelper*)customMsgHelper
{
    self = [self initWithFrame:frame chatroomId:chatroomId isPublish:isPublish];
    if (self) {
        _customMsgHelper = customMsgHelper;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
                   chatroomId:(NSString*)chatroomId
                    isPublish:(BOOL)isPublish
              
{
    self = [super initWithFrame:frame];
    if (self) {
        _chatroomId = chatroomId;
        _isBarrageInfo = false;
        _praiseInterval = 0;
        _praiseCount = 0;
        _curtime = (long long)([[NSDate date] timeIntervalSince1970]*1000);
        self.height = self.frame.size.height;
        
        [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];

        self.datasource = [NSMutableArray array];
        self.conversation = [[AgoraChatClient sharedClient].chatManager getConversation:_chatroomId type:AgoraChatConversationTypeChatRoom createIfNotExist:NO];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        [self placeAndLayoutSubviews];

    }
    return self;
}


- (void)dealloc {
    [[AgoraChatClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self stopTimer];
}


- (void)placeAndLayoutSubviews {
    [self addSubview:self.tableView];
    [self addSubview:self.sendTextButton];
    
    self.sendTextButton.backgroundColor = UIColor.yellowColor;
    
    [self.tableView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self).offset(-self.tableViewRightMargin);
        make.bottom.equalTo(self.sendTextButton.ease_top);
    }];

    [self.sendTextButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.equalTo(self).offset(12.0);
        make.width.equalTo(@(kSendTextButtonWitdh));
        make.height.equalTo(@(kSendTextButtonHeight));
        make.bottom.equalTo(self).offset(-EaseKitBottomSafeHeight-self.tableViewBottomMargin);
    }];
    
    //底部消息发送按钮
    [self placeAndLayoutBottomSendView];
}

- (void)placeAndLayoutBottomSendView {
    [self addSubview:self.bottomSendMsgView];
    [self.bottomSendMsgView addSubview:self.textView];
    [self.bottomSendMsgView addSubview:self.sendButton];
    
    [self.bottomSendMsgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(kSendTextButtonHeight));
        make.bottom.equalTo(self).offset(-EaseKitBottomSafeHeight-self.tableViewBottomMargin);
    }];
    
    [self.textView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.top.equalTo(self.bottomSendMsgView);
        make.left.equalTo(self.bottomSendMsgView).offset(5);
        make.right.equalTo(self.sendButton.ease_left).offset(-5);
        make.bottom.equalTo(self.bottomSendMsgView);
    }];
    
    [self.sendButton Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerY.equalTo(self.textView);
        make.width.equalTo(@(40.0));
        make.right.equalTo(self.bottomSendMsgView).offset(-5);
        make.height.equalTo(self.textView);
    }];

}


//- (void)setHidden:(BOOL)hidden
//{
//    [super setHidden:hidden];
//    if (!hidden) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
//            CGFloat toHeight = self.frame.size.height;
//            [self.delegate easeChatViewDidChangeFrameToHeight:toHeight];
//        }
//    }
//}


#pragma mark - AgoraChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    for (AgoraChatMessage *message in aMessages) {
        if ([message.conversationId isEqualToString:_chatroomId]) {

            //filter custom gift message
            if (message.body.type == AgoraChatMessageBodyTypeCustom) {
                AgoraChatCustomMessageBody* customBody = (AgoraChatCustomMessageBody*)message.body;
                if ([customBody.event isEqualToString:kCustomMsgChatroomGift]) {
                    continue;
                }
            }
                
            if ([self.datasource count] >= 200) {
                [self.datasource removeObjectsInRange:NSMakeRange(0, 190)];
            }
            [self.datasource addObject:message];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.datasource count] - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    for (AgoraChatMessage *message in aCmdMessages) {
        if ([message.conversationId isEqualToString:_chatroomId]) {
            if (message.timestamp < _curtime) {
                continue;
            }
        }
    }
}


#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AgoraChatMessage *message = [self.datasource objectAtIndex:indexPath.section];
    if ([message.ext objectForKey:EaseKit_chatroom_join]) {
        return 44.0;
    }
    return [EaseChatroomMessageCell heightForMessage:message];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blank = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 5)];
    blank.backgroundColor = [UIColor clearColor];
    return blank;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datasource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *messageCell = nil;
//    UITableViewCell *joinCell = nil;
//
//    if (self.customOption.customMessageCell) {
//        messageCell = [tableView dequeueReusableCellWithIdentifier:@"customMessageCell"];
//        if (messageCell == nil) {
//            messageCell = [[[self.customOption.customMessageCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customMessageCell"];
//        }
//    }else {
//        messageCell = [tableView dequeueReusableCellWithIdentifier:[EaseChatroomMessageCell reuseIdentifier]];
//    }
//
//    if (self.customOption.customJoinCell) {
//        joinCell = [tableView dequeueReusableCellWithIdentifier:@"customJoinCell"];
//        if (joinCell == nil) {
//            joinCell = [[[self.customOption.customJoinCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customJoinCell"];
//        }
//    }else {
//        joinCell = [tableView dequeueReusableCellWithIdentifier:[EaseChatroomJoinCell reuseIdentifier]];
//    }
//
//
//    if (!self.datasource || [self.datasource count] < 1)
//        return nil;
//    AgoraChatMessage *message = [self.datasource objectAtIndex:indexPath.section];
//    if ([message.ext objectForKey:EaseKit_chatroom_join]) {
//        [joinCell updateWithObj:message];
//        return joinCell;
//    }else {
//        [messageCell setMesssage:message chatroom:self.chatroom];
//    }
//    return messageCell;
    
    
    EaseChatroomMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[EaseChatroomMessageCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[EaseChatroomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[EaseChatroomMessageCell reuseIdentifier]];
    }

    EaseChatroomJoinCell *joinCell = [tableView dequeueReusableCellWithIdentifier:[EaseChatroomJoinCell reuseIdentifier]];

    if (!self.datasource || [self.datasource count] < 1)
        return nil;
    AgoraChatMessage *message = [self.datasource objectAtIndex:indexPath.section];
    if ([message.ext objectForKey:EaseKit_chatroom_join]) {
        [joinCell updateWithObj:message];
        return joinCell;
    }else {
        [cell setMesssage:message chatroom:self.chatroom];
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AgoraChatMessage *message = [self.datasource objectAtIndex:indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectUserWithMessage:)]) {
        [self.delegate didSelectUserWithMessage:message];
    }
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 0 && [text isEqualToString:@"\n"]) {
        if (_isBarrageInfo) {
            [self sendBarrageMsg:self.textView.text];
        } else {
            [self sendText];
        }
        [self textViewDidChange:self.textView];
        return NO;
    }
    [self textViewDidChange:self.textView];
    return YES;
}

//#pragma mark - EaseEmoticonViewDelegate
//
//- (void)didSelectedEmoticonModel:(EMEmoticonModel *)aModel
//{
//    if (aModel.type == EMEmotionTypeEmoji) {
//        [self inputViewAppendText:aModel.name];
//    }
//}
//
//- (void)didChatBarEmoticonViewSendAction
//{
//    [self sendFace];
//    [self sendTextAction];
//    [self textViewDidChange:self.textView];
//}
/*
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.textView.text;
    
    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    } else {
        if (chatText.length > 0) {
            NSInteger length = 1;
            if (chatText.length >= 2) {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([EaseEmoji stringContainsEmoji:subStr]) {
                    length = 2;
                }
            }
            self.textView.text = [chatText substringToIndex:chatText.length-length];
        }
    }
    [self textViewDidChange:self.textView];
}*/

//- (void)inputViewAppendText:(NSString *)aText
//{
//    if ([aText length] > 0) {
//        self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, aText];
//        [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.textView] refresh:YES];
//    }
//}

//- (void)sendFace
//{
//    NSString *chatText = self.textView.text;
//    if (chatText.length > 0) {
//        if (_isBarrageInfo) {
//            [self sendBarrageMsg:self.textView.text];
//        } else {
//            [self sendText];
//        }
//        self.textView.text = @"";
//        [self textChangedExt];
//    }
//    [self textViewDidChange:self.textView];
//}


#pragma mark public method
- (void)updateChatViewWithHidden:(BOOL)isHidden {
    self.tableView.hidden = isHidden;
    self.sendTextButton.hidden = isHidden;
}


#pragma mark - UIKeyboardNotification
- (void)keyBoardWillShow:(NSNotification *)note
{
    // Obtaining User information
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // Get keyboard height
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    
    [self.bottomSendMsgView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-keyBoardHeight + 20.0);
    }];
    
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    [self.bottomSendMsgView Ease_updateConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.sendTextButton);
    }];
}

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    if (self.activityView) {
        [self _setSendState:NO];
        [self _willShowBottomView:nil];
    }
    
    //防止自定义数字键盘弹起导致本页面上移
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isEqual:self.textView]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
            CGFloat toHeight = endFrame.size.height + self.frame.size.height + (kTextViewHeight - 30);
            [self.delegate easeChatViewDidChangeFrameToHeight:toHeight];
        }
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self _setSendState:NO];
//    [self _willShowBottomView:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length > 0 && ![self.textView.text isEqualToString:@""]) {
        self.sendButton.backgroundColor = [UIColor colorWithRed:4/255.0 green:174/255.0 blue:240/255.0 alpha:1.0];
        self.sendButton.tag = 1;
    } else {
        self.sendButton.backgroundColor = [UIColor lightGrayColor];
        self.sendButton.tag = 0;
    }
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView] refresh:NO];
}

//
//- (void)textChangedExt
//{
//    if (self.textView.text.length > 0 && ![self.textView.text isEqualToString:@""]) {
//        self.sendButton.backgroundColor = [UIColor colorWithRed:4/255.0 green:174/255.0 blue:240/255.0 alpha:1.0];
//        self.sendButton.tag = 1;
//    } else {
//        self.sendButton.backgroundColor = [UIColor lightGrayColor];
//        self.sendButton.tag = 0;
//    }
//}


- (AgoraChatMessage *)_sendTextMessage:(NSString *)text
                             to:(NSString *)toUser
                    messageType:(AgoraChatType)messageType
                     messageExt:(NSDictionary *)messageExt

{
    AgoraChatMessageBody *body = [[AgoraChatTextMessageBody alloc] initWithText:text];
    NSString *from = [[AgoraChatClient sharedClient] currentUsername];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    return message;
}

- (void)_setSendState:(BOOL)state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewWillShow:)]) {
        [self.delegate textViewWillShow:state];
    }
    
    if (state) {
        self.bottomSendMsgView.hidden = NO;
        self.sendTextButton.hidden = YES;
        [self.textView becomeFirstResponder];
    } else {
        self.bottomSendMsgView.hidden = YES;
        self.sendTextButton.hidden = NO;
        [self.textView resignFirstResponder];
    }
}

- (void)_willShowBottomView:(UIView *)bottomView
{
    if (![self.activityView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        if (bottomView != nil) {
            self.height = bottomHeight + self.height + (kTextViewHeight - 30);
        } else {
            self.height = bottomHeight + self.height;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(easeChatViewDidChangeFrameToHeight:)]) {
            [self.delegate easeChatViewDidChangeFrameToHeight:self.height];
        }

        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.bottomSendMsgView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }

        if (self.activityView) {
            [self.activityView removeFromSuperview];
        }
        self.activityView = bottomView;
    }
}


/*
- (void)_setupEmotion
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *emotion = [emotions objectAtIndex:0];
 EaseEmotionManager *manager= [[EaseHttpManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
    [(EaseFaceView *)self.faceView setEmotionManagers:@[manager]];
}*/

- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight refresh:(BOOL)refresh
{
//    if (toHeight < 30.f) {
//        toHeight = 30.f;
//    }
//    if (toHeight > 90.f) {
//        toHeight = 90.f;
//    }
//
//    if (toHeight == _previousTextViewContentHeight && !refresh) {
//        return;
//    } else{
//        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
//
//        CGRect rect = self.frame;
//        rect.size.height += changeHeight;
//        rect.origin.y -= changeHeight;
//        self.frame = rect;
//
//        rect = self.bottomSendMsgView.frame;
//        rect.size.height += changeHeight;
//        self.bottomSendMsgView.frame = rect;
//
//        [self.textView setContentOffset:CGPointMake(0.0f, (self.textView.contentSize.height - self.textView.frame.size.height) / 2) animated:YES];
//
//        _previousTextViewContentHeight = toHeight;
//    }
    
}



#pragma mark - action

- (void)sendMsgAction
{
    if (self.sendButton.tag == 1) {
        if (_isBarrageInfo) {
            [self sendBarrageMsg:self.textView.text];
        } else {
            [self sendText];
        }
    }
}


- (void)sendTextAction
{
    [self _setSendState:YES];
//    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.textView] refresh:YES];
}

//普通文本消息
- (void)sendText
{
    if (self.textView.text.length > 0) {
        AgoraChatMessage *message = [self _sendTextMessage:self.textView.text to:_chatroomId messageType:AgoraChatTypeChatRoom messageExt:nil];
        __weak EaseChatView *weakSelf = self;
        [[AgoraChatClient sharedClient].chatManager sendMessage:message progress:NULL completion:^(AgoraChatMessage *message, AgoraChatError *error) {
            if (!error) {
                [weakSelf currentViewDataFill:message];
            } else {
//                [MBProgressHUD showError:@"消息发送失败" toView:weakSelf];
            }
        }];
        self.textView.text = @"";
//        [self textChangedExt];
    }
}


//发送弹幕消息
- (void)sendBarrageMsg:(NSString*)text
{
    __weak EaseChatView *weakSelf = self;
    [_customMsgHelper sendCustomMessage:text num:0 to:_chatroomId messageType:AgoraChatTypeChatRoom customMsgType:customMessageType_barrage completion:^(AgoraChatMessage * _Nonnull message, AgoraChatError * _Nonnull error) {
        if (!error) {
//            [_customMsgHelper barrageAction:message backView:self.superview];
            [weakSelf currentViewDataFill:message];
        } else {
//            [MBProgressHUD showError:@"弹幕消息发送失败" toView:weakSelf];
        }
    }];
//    self.textView.text = @"";
//    [self textChangedExt];
}


//- (void)faceAction
//{
//    _faceButton.selected = !_faceButton.selected;
//
//    if (_faceButton.selected) {
//        [self.textView resignFirstResponder];
//        [self _willShowBottomView:self.faceView];
//    } else {
//        [self.textView becomeFirstResponder];
//    }
//}

//发送礼物
- (void)sendGiftAction:(NSString *)giftId
                   num:(NSInteger)num
                    completion:(void (^)(BOOL success))aCompletion

{
     __weak EaseChatView *weakSelf = self;
    [_customMsgHelper sendCustomMessage:giftId num:num to:_chatroomId messageType:AgoraChatTypeChatRoom customMsgType:customMessageType_gift completion:^(AgoraChatMessage * _Nonnull message, AgoraChatError * _Nonnull error) {
        bool ret = false;
        if (!error) {
            ret = true;
        } else {
            ret = false;
        }
        aCompletion(ret);
    }];
}


////赞
//- (void)praiseAction
//{
//    [_customMsgHelper praiseAction:self];
//    ++_praiseCount;
//    if (_praiseInterval != 0) {
//        return;
//    }
//    [self startTimer];
//}
//
//- (void)_praiseOperate
//{
//    __weak EaseChatView *weakSelf = self;
//    [_customMsgHelper sendCustomMessage:@"" num:_praiseCount to:_chatroomId messageType:AgoraChatTypeChatRoom customMsgType:customMessageType_praise completion:^(AgoraChatMessage * _Nonnull message, AgoraChatError * _Nonnull error) {
//        if (!error) {
//            _praiseCount = 0;
//            [weakSelf currentViewDataFill:message];
//        } else {
////            [MBProgressHUD showError:@"点赞失败" toView:weakSelf];
//        }
//    }];
//}

//- (void)startTimer {
//    [self stopTimer];
//    _praiseInterval = 4 + (arc4random() % 3);
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setupPraiseInterval) userInfo:nil repeats:YES];
//    [_timer fire];
//}
//
//- (void)stopTimer {
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//}
//
//- (void)setupPraiseInterval{
//    if(_praiseInterval < 1){
//        [self _praiseOperate];
//        [self stopTimer];
//        return;
//    }
//    _praiseInterval -= 1;
//}

//- (void)changeCameraAction
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(didSelectChangeCameraButton)]) {
//        [_delegate didSelectChangeCameraButton];
//        _changeCameraButton.selected = !_changeCameraButton.selected;
//    }
//}
//
//- (void)chatListShowButtonAction:(id)sender {
//  
//    self.isHiddenChatListView = !self.isHiddenChatListView;
//    
//    if (self.isHiddenChatListView) {
//        [_chatListShowButton setImage:ImageWithName(@"live_chatlist_normal") forState:UIControlStateNormal];
//    }else {
//        [_chatListShowButton setImage:ImageWithName(@"live_chatlist_hidden") forState:UIControlStateNormal];
//    }
//    
//    self.tableView.hidden = self.isHiddenChatListView;
//    self.sendTextButton.hidden = self.isHiddenChatListView;
//  
//}
//
//- (void)exitAction
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedExitButton)]) {
//        [self.delegate didSelectedExitButton];
//    }
//}
//
//- (void)giftAction
//{
//    if ([self.chatroom.owner isEqualToString:AgoraChatClient.sharedClient.currentUsername]) {
//        //礼物列表
//        if (_delegate && [_delegate respondsToSelector:@selector(didSelectGiftButton:)]) {
//            [_delegate didSelectGiftButton:YES];
//        }
//    } else {
//        //送礼物
//        if (_delegate && [_delegate respondsToSelector:@selector(didSelectGiftButton:)]) {
//            [_delegate didSelectGiftButton:NO];
//        }
//    }
//}

#pragma mark - private
//当前视图数据填充
- (void)currentViewDataFill:(AgoraChatMessage*)message
{
    if ([self.datasource count] >= 200) {
        [self.datasource removeObjectsInRange:NSMakeRange(0, 190)];
    }
    [self.datasource addObject:message];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.datasource count] - 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - public

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    [self _setSendState:NO];
    [self _willShowBottomView:nil];
    return result;
}


#pragma mark getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.bounds) - 48.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollsToTop = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[EaseChatroomMessageCell class] forCellReuseIdentifier:[EaseChatroomMessageCell reuseIdentifier]];
        [_tableView registerClass:[EaseChatroomJoinCell class] forCellReuseIdentifier:[EaseChatroomJoinCell reuseIdentifier]];

        _tableView.backgroundColor = UIColor.redColor;
        
    }
    return _tableView;
}

//- (UIView*)bottomView
//{
//    if (_bottomView == nil) {
//        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.bounds), kButtonHeight)];
//        _bottomView.backgroundColor = [UIColor clearColor];
//    }
//    return _bottomView;
//}


- (UIButton*)sendTextButton
{
    if (_sendTextButton == nil) {
        _sendTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendTextButton.frame = CGRectMake(kDefaultSpace*1.5, 0, kSendTextButtonWitdh, kButtonHeight);
        _sendTextButton.layer.cornerRadius = kSendTextButtonHeight* 0.5;
        _sendTextButton.layer.borderWidth = 1.0;
        _sendTextButton.layer.borderColor = EaseKitTextLabelGrayColor.CGColor;
        _sendTextButton.titleLabel.font = EaseKitNFont(14.0f);
        _sendTextButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_sendTextButton setTitle:@"Say Hi to your Fans..." forState:UIControlStateNormal];
        [_sendTextButton setTitleColor:EaseKitTextLabelGrayColor forState:UIControlStateNormal];
        [_sendTextButton addTarget:self action:@selector(sendTextAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sendTextButton;
}


//
//
//- (UIButton*)changeCameraButton
//{
//    if (_changeCameraButton == nil) {
//        _changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _changeCameraButton.frame = CGRectMake(EaseKitScreenWidth - kDefaultSpace*2 - 2*kSendTextButtonWitdh, 0, kSendTextButtonWitdh, kButtonHeight);
//        [_changeCameraButton setImage:[UIImage imageNamed:@"flip_camera_ios"] forState:UIControlStateNormal];
//        [_changeCameraButton addTarget:self action:@selector(changeCameraAction) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _changeCameraButton;
//}
//
//- (UIButton *)chatListShowButton {
//    if (_chatListShowButton == nil) {
//        _chatListShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _chatListShowButton.frame = CGRectMake(EaseKitScreenWidth - kDefaultSpace*2 - 2*kSendTextButtonWitdh, 0, kSendTextButtonWitdh, kButtonHeight);
//        [_chatListShowButton setImage:EaseKitImageWithName(@"live_chatlist_hidden") forState:UIControlStateNormal];
//        [_chatListShowButton addTarget:self action:@selector(chatListShowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _chatListShowButton;
//}
//
//- (UIButton*)exitButton
//{
//    if (_exitButton == nil) {
//        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _exitButton.frame = CGRectMake(EaseKitScreenWidth - kDefaultSpace*3 - 3*kSendTextButtonWitdh, 0, kSendTextButtonWitdh, kButtonHeight);
//        [_exitButton setImage:[UIImage imageNamed:@"stop_live"] forState:UIControlStateNormal];
//        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _exitButton;
//}
//
//- (UIButton*)likeButton
//{
//    if (_likeButton == nil) {
//        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _likeButton.frame = CGRectMake(EaseKitScreenWidth - kDefaultSpace*2 - 2*kSendTextButtonWitdh, 0, kSendTextButtonWitdh, kButtonHeight);
//        _likeButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
//        _likeButton.layer.cornerRadius = kSendTextButtonWitdh / 2;
//        [_likeButton setImage:[UIImage imageNamed:@"ic_praise"] forState:UIControlStateNormal];
//        [_likeButton setImage:[UIImage imageNamed:@"ic_praised"] forState:UIControlStateHighlighted];
//        [_likeButton addTarget:self action:@selector(praiseAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _likeButton;
//}
//
//- (UIButton*)giftButton
//{
//    if (_giftButton == nil) {
//        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _giftButton.frame = CGRectMake(EaseKitScreenWidth - kDefaultSpace - kSendTextButtonWitdh, 0, kSendTextButtonWitdh, kButtonHeight);
//        [_giftButton setImage:[UIImage imageNamed:@"live_gift"] forState:UIControlStateNormal];
//        [_giftButton addTarget:self action:@selector(giftAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _giftButton;
//}
//

- (UIView*)bottomSendMsgView
{
    if (_bottomSendMsgView == nil) {
//        _bottomSendMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.bounds), 50.f)];
        _bottomSendMsgView = [[UIView alloc] init];
        _bottomSendMsgView.backgroundColor = EaseKitRGBACOLOR(255, 255, 255, 1);
        _bottomSendMsgView.layer.borderWidth = 1;
        _bottomSendMsgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bottomSendMsgView.hidden = YES;
        _bottomSendMsgView.backgroundColor = UIColor.purpleColor;

    }
    return _bottomSendMsgView;
}

//- (EaseCustomSwitch*)barrageSwitch
//{
//    if (_barrageSwitch == nil) {
//        _barrageSwitch = [[EaseCustomSwitch alloc]initWithTextFont:[UIFont systemFontOfSize:12.f] OnText:@"弹" offText:@"弹" onBackGroundColor:EaseKitRGBACOLOR(4, 174, 240, 1) offBackGroundColor:EaseKitRGBACOLOR(191, 191, 191, 1) onButtonColor:EaseKitRGBACOLOR(255, 255, 255, 1) offButtonColor:EaseKitRGBACOLOR(255, 255, 255, 1) onTextColor:EaseKitRGBACOLOR(4, 174, 240, 1) andOffTextColor:EaseKitRGBACOLOR(191, 191, 191, 1) isOn:NO frame:CGRectMake(5.f, 13.f, 44.f, 24.f)];
//            _barrageSwitch.changeStateBlock = ^(BOOL isOn) {
//            _isBarrageInfo = isOn;
//        };
//    }
//    return _barrageSwitch;
//}

- (EaseInputTextView*)textView
{
    if (_textView == nil) {
        _textView = [[EaseInputTextView alloc] init];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.scrollEnabled = YES;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _textView.placeHolder = NSLocalizedString(@"chat.input.placeholder", @"input a new message");
        _textView.delegate = self;
        _textView.backgroundColor = EaseKitRGBACOLOR(236, 236, 236, 1);
        _textView.layer.cornerRadius = 4.0f;
        _previousTextViewContentHeight = [self _getTextViewContentH:_textView];
        _textView.backgroundColor = UIColor.yellowColor;
    }
    return _textView;
}

- (UIButton*)sendButton
{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = [UIColor lightGrayColor];
        _sendButton.tag = 0;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.layer.cornerRadius = 3;
        [_sendButton addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


//- (UIButton*)faceButton
//{
//    if (_faceButton == nil) {
//        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _faceButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - kDefaulfLeftSpace, 10.f, 30, 30);
//        [_faceButton setImage:[UIImage imageNamed:@"input_bar_1_icon_face"] forState:UIControlStateNormal];
//        [_faceButton setImage:[UIImage imageNamed:@"input_bar_1_icon_keyboard"] forState:UIControlStateSelected];
//        [_faceButton addTarget:self action:@selector(faceAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _faceButton;
//}

//- (UIView*)faceView
//{
//    if (_faceView == nil) {
//        _faceView = [[EaseEmoticonView alloc] initWithOutlineFrame:CGRectMake(0, CGRectGetMaxY(_bottomSendMsgView.frame), self.frame.size.width, 180)];
//        [(EaseEmoticonView *)_faceView setDelegate:self];
//        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
//        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        //[self _setupEmotion];
//    }
//    return _faceView;
//}

- (void)setIsMuted:(BOOL)isMuted {
    _isMuted = isMuted;
    self.sendTextButton.enabled = !_isMuted;
}


- (void)setViewBgColor:(UIColor *)viewBgColor {
    self.tableView.backgroundColor = viewBgColor;
}



@end

#undef kSendTextButtonWitdh
#undef kSendTextButtonHeight
#undef kButtonHeight
#undef kDefaultSpace
#undef kDefaulfLeftSpace
#undef kTextViewHeight

