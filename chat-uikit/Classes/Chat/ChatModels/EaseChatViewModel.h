//
//  EaseChatViewModel.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EaseChatEnums.h"
#import "EaseExtendMenuViewModel.h"

/*!
 *  Input menu style
 */
typedef NS_ENUM(NSInteger, EaseInputMenuStyle) {
    EaseInputMenuStyleAll = 1,          //All functions
    EaseInputMenuStyleNoAudio,          //No Audio
    EaseInputMenuStyleNoEmoji,          //No Emoji
    EaseInputMenuStyleNoAudioAndEmoji,  //No Audio And Emoji
    EaseInputMenuStyleOnlyText,         //Only Text
};

/*!
 *  Message alignment
 */
typedef NS_ENUM(NSInteger, EaseAlignmentStyle) {
    EaseAlignmentLeft_Right = 1,     //Left Right alignment
    EaseAlignmentlAll_Left,          //The left alignment
};

typedef struct BubbleCornerRadius {
    float topLeft;
    float topRight;
    float bottomLeft;
    float bottomRight;
} BubbleCornerRadius;

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatViewModel : NSObject

// Chat view background color
@property (nonatomic, strong) UIColor *chatViewBgColor;

// Timeline background color
@property (nonatomic, strong) UIColor *msgTimeItemBgColor;

// Timeline font
@property (nonatomic, strong) UIFont *msgTimeItemFont;

// Timeline font color
@property (nonatomic, strong) UIColor *msgTimeItemFontColor;

// Bubble background image of received message
@property (nonatomic, strong) UIImage *receiverBubbleBgImage;

// Bubble background image of sent message
@property (nonatomic, strong) UIImage *senderBubbleBgImage;

// Bubble background image of message contain thread
@property (nonatomic, strong) UIImage *threadBubbleBgImage;

// Right align image/video/attachment message bubble cornerRadius
@property (nonatomic) BubbleCornerRadius rightAlignmentCornerRadius;

// Left align image/video/attachment message bubble cornerRadius
@property (nonatomic) BubbleCornerRadius leftAlignmentCornerRadius;

// thread bubble cornerRadius
@property (nonatomic) BubbleCornerRadius threadCornerRadius;

// Message bubble background protected area
@property (nonatomic) UIEdgeInsets bubbleBgEdgeInsets;

// Sent message font color
@property (nonatomic, strong) UIColor *sentFontColor;

// Receiver message font Color
@property (nonatomic, strong) UIColor *reveivedFontColor;

// Text message font
@property (nonatomic) UIFont *textMessaegFont;

// Input menu background color and input menu gradient color mutually exclusive. display background color first
@property (nonatomic, strong) UIColor *inputMenuBgColor;

// Input menu type
@property (nonatomic) EaseInputMenuStyle inputMenuStyle;

// Input menu extend view model
@property (nonatomic) EaseExtendMenuViewModel *extendMenuViewModel;

// Display sent avatar
@property (nonatomic) BOOL displaySentAvatar;

// Display received avatar
@property (nonatomic) BOOL displayReceivedAvatar;

// Display sent name
@property (nonatomic) BOOL displaySentName;

// Display received name
@property (nonatomic) BOOL displayReceiverName;

// Avatar style
@property (nonatomic) EaseChatAvatarStyle avatarStyle;

// Avatar cornerRadius Default: 0 (Only avatar type RoundedCorner)
@property (nonatomic) CGFloat avatarCornerRadius;

// Chat view message alignment
@property (nonatomic) EaseAlignmentStyle msgAlignmentStyle;

@end

NS_ASSUME_NONNULL_END
