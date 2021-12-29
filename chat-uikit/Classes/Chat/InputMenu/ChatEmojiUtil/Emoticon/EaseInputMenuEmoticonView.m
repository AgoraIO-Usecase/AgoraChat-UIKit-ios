//
//  EaseInputMenuEmoticonView.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/30.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseInputMenuEmoticonView.h"
#import "UIImage+EaseUI.h"
#import "EaseHeaders.h"
#import "EaseEmojiHelper.h"

@interface EaseInputMenuEmoticonView()<EMEmoticonViewDelegate>

@property (nonatomic, strong) EaseEmoticon *emoticon;
@property (nonatomic, strong) UIView *emotionBgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *sendBtn;


@end

@implementation EaseInputMenuEmoticonView

- (instancetype)initWithViewHeight:(CGFloat)viewHeight
{
    self = [super init];
    if (self) {
        _viewHeight = viewHeight;
        [self _initDataSource];
        [self _setupSubviews];
        [self _setupEmoticonView];
    }
    
    return self;
}

#pragma mark - Subviews

- (void)_setupSubviews
{
    [self _setupBtnAction];
    [self _setupEmotionViews];
}

- (void)_setupBtnAction
{
    self.sendBtn = [[UIButton alloc]init];
    self.sendBtn.backgroundColor = [UIColor clearColor];
    self.sendBtn.layer.cornerRadius = 21;
    [self.sendBtn setImage:[UIImage easeUIImageNamed:@"sendMsg"] forState:UIControlStateNormal];
    [self.sendBtn setImage:[UIImage easeUIImageNamed:@"sendMsgDisable"] forState:UIControlStateDisabled];
    [self.sendBtn setImageEdgeInsets:UIEdgeInsetsMake(-7, -7, -7, -7)];
    self.sendBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.sendBtn addTarget:self action:@selector(sendEmoticonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn = [[UIButton alloc]init];
    self.deleteBtn.backgroundColor = [UIColor clearColor];
    self.deleteBtn.layer.cornerRadius = 21;
    [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(-7, -7, -7, -7)];
    [self.deleteBtn setImage:[UIImage easeUIImageNamed:@"deleteEmoticon"] forState:UIControlStateNormal];
    [self.deleteBtn setImage:[UIImage easeUIImageNamed:@"deleteEmoticonDisable"] forState:UIControlStateDisabled];
    [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)_setupEmotionViews
{
    self.emotionBgView = [[UIView alloc] init];
    self.emotionBgView.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
    [self insertSubview:self.emotionBgView atIndex:0];
    [self.emotionBgView Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

}

#pragma mark - Data

- (void)_initDataSource
{
    NSArray *emojis = [EaseEmojiHelper getAllEmojis];
    NSMutableArray *models1 = [[NSMutableArray alloc] init];
    for (NSString *emoji in emojis) {
        EaseEmoticonModel *model = [[EaseEmoticonModel alloc] initWithType:EMEmotionTypeEmoji];
        model.eId = emoji;
        model.name = emoji;
        model.original = emoji;
        [models1 addObject:model];
    }
    NSString *tagImgName = [models1[0] name];
    _emoticon = [[EaseEmoticon alloc] initWithType:EMEmotionTypeEmoji dataArray:models1 icon:tagImgName rowCount:3 colCount:7];
}

#pragma mark - EMEmoticonViewDelegate

- (void)emoticonViewDidSelectedModel:(EaseEmoticonModel *)aModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedEmoticon:)]) {
        [self.delegate didSelectedEmoticon:aModel];
    }
}

#pragma mark - Action

- (void)sendEmoticonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChatBarEmoticonViewSendAction)]) {
        [self.delegate didChatBarEmoticonViewSendAction];
    }
}

- (void)_setupEmoticonView
{
    [self addSubview:self.sendBtn];
    [self.sendBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.ease_bottom).offset(-25);
        make.right.equalTo(self.ease_right).offset(-19);
        make.width.height.Ease_equalTo(@42);
    }];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.bottom.equalTo(self.ease_bottom).offset(-25);
        make.right.equalTo(self.sendBtn.ease_left).offset(-12);
        make.width.height.Ease_equalTo(@42);
    }];
    
    EMEmoticonView *view = [[EMEmoticonView alloc] initWithEmotion:_emoticon viewHeight:_viewHeight];
    view.delegate = self;
    [self.emotionBgView addSubview:view];
    [view Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.edges.equalTo(self.emotionBgView);
    }];
}

- (void)deleteAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTextDetele)]) {
        BOOL isEditing = [self.delegate didSelectedTextDetele];
        [self textDidChange:isEditing];
    }
}

- (void)textDidChange:(BOOL)isEditing
{
    if (!isEditing) {
        self.sendBtn.enabled = NO;
        self.deleteBtn.enabled = NO;
    } else {
        self.sendBtn.enabled = YES;
        self.deleteBtn.enabled = YES;
    }
}

@end
