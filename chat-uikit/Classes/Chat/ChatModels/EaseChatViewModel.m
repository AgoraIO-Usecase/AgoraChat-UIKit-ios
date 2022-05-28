//
//  EaseChatViewModel.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/17.
//

#import "EaseChatViewModel.h"
#import "UIImage+EaseUI.h"
#import "UIColor+EaseUI.h"

@implementation EaseChatViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _chatViewBgColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
        _inputMenuBgColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _extendMenuViewModel = [[EaseExtendMenuViewModel alloc]init];
        _msgTimeItemBgColor = [UIColor whiteColor];
        _msgTimeItemFont = [UIFont fontWithName:@"PingFang SC" size:12.0];
        _msgTimeItemFontColor = [UIColor colorWithHexString:@"#999999"];
        _receiverBubbleBgImage = [UIImage easeUIImageNamed:@"msg_bg_recv"];
        _senderBubbleBgImage = [UIImage easeUIImageNamed:@"msg_bg_send"];
        _threadBubbleBgImage = [UIImage easeUIImageNamed:@"threading_bubble"];
        BubbleCornerRadius right = {16, 16, 16, 4};
        BubbleCornerRadius left = {16, 16, 4, 16};
        BubbleCornerRadius thread = {8, 8, 8, 8};
        _rightAlignmentCornerRadius = right;
        _leftAlignmentCornerRadius = left;
        _threadCornerRadius = thread;
        _bubbleBgEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16);
        _sentFontColor = [UIColor whiteColor];
        _reveivedFontColor = [UIColor blackColor];
        _textMessaegFont = [UIFont fontWithName:@"PingFang SC" size:16.0];
        _inputMenuStyle = EaseInputMenuStyleAll;
        _avatarStyle = Circular;
        _avatarCornerRadius = 0;
        _displayReceivedAvatar = YES;
        _displayReceiverName = YES;
        _displaySentName = YES;
        _displaySentAvatar = YES;
    }
    return self;
}

- (void)setChatViewBgColor:(UIColor *)chatViewBgColor
{
    if (chatViewBgColor) {
        _chatViewBgColor = chatViewBgColor;
    }
}

- (void)setInputMenuBgColor:(UIColor *)inputMenuBgColor
{
    if (inputMenuBgColor) {
        _inputMenuBgColor = inputMenuBgColor;
    }
}

- (void)setInputMenuStyle:(EaseInputMenuStyle)inputMenuStyle
{
    if (inputMenuStyle >= 1 && inputMenuStyle <= 5) {
        _inputMenuStyle = inputMenuStyle;
    }
}

- (void)setExtendMenuViewModel:(EaseExtendMenuViewModel *)extendMenuViewModel
{
    if (extendMenuViewModel) {
        _extendMenuViewModel = extendMenuViewModel;
    }
}

- (void)setMsgTimeItemBgColor:(UIColor *)msgTimeItemBgColor
{
    if (msgTimeItemBgColor) {
        _msgTimeItemBgColor = msgTimeItemBgColor;
    }
}

- (void)setMsgTimeItemFontColor:(UIColor *)msgTimeItemFontColor
{
    if (msgTimeItemFontColor) {
        _msgTimeItemFontColor = msgTimeItemFontColor;
    }
}

- (void)setMsgTimeItemFont:(UIFont *)msgTimeItemFont
{
    if (msgTimeItemFont) {
        _msgTimeItemFont = msgTimeItemFont;
    }
}

- (void)setReceiverBubbleBgImage:(UIImage *)receiverBubbleBgImage
{
    if (receiverBubbleBgImage) {
        _receiverBubbleBgImage = receiverBubbleBgImage;
    } else {
        _receiverBubbleBgImage = [UIImage easeUIImageNamed:@""];
    }
}

- (void)setSenderBubbleBgImage:(UIImage *)senderBubbleBgImage
{
    if (senderBubbleBgImage) {
        _senderBubbleBgImage = senderBubbleBgImage;
    } else {
        _senderBubbleBgImage = [UIImage easeUIImageNamed:@"“"];
    }
}

- (void)setBubbleBgEdgeInsets:(UIEdgeInsets)bubbleBgEdgeInsets
{
    _bubbleBgEdgeInsets = bubbleBgEdgeInsets;
}

- (void)setSentFontColor:(UIColor *)sentFontColor
{
    if (sentFontColor) {
        _sentFontColor = sentFontColor;
    }
}

- (void)setReveivedFontColor:(UIColor *)reveivedFontColor
{
    if (reveivedFontColor) {
        _reveivedFontColor = reveivedFontColor;
    }
}

- (void)setTextMessaegFont:(UIFont *)textMessaegFont
{
    if (textMessaegFont) {
        _textMessaegFont = textMessaegFont;
    }
}

- (void)setAvatarStyle:(EaseChatAvatarStyle)avatarStyle
{
    if (avatarStyle >= 1 && avatarStyle <= 3) {
        _avatarStyle = avatarStyle;
    }
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius
{
    if (avatarCornerRadius > 0) {
        _avatarCornerRadius = avatarCornerRadius;
    }
}

@end
