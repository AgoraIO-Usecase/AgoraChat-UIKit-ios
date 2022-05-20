//
//  EaseChatView.h
//
//  Created by EaseMob on 16/5/9.
//  Copyright © 2016年 zilong.li All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseCustomMessageHelper.h"
#import "EaseChatViewCustomOption.h"

@class AgoraChatMessage;
@class EaseLiveRoom;
@protocol EaseChatViewDelegate <NSObject>

@optional

//- (void)easeChatKeyboardWillShowWithHeight:(CGFloat)height
//                             animationTime:(NSInteger)animationTime;
//
//- (void)easeChatKeyboardWillHidden;

- (void)didSelectUserWithMessage:(AgoraChatMessage*)message;

- (void)textViewWillShow:(BOOL)isShow;

@end

@interface EaseChatView : UIView

@property (nonatomic, weak) id<EaseChatViewDelegate> delegate;

@property (nonatomic,strong) AgoraChatroom *chatroom;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *sendTextButton;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,assign) BOOL isMuted;


- (instancetype)initWithFrame:(CGRect)frame
                   chatroomId:(NSString*)chatroomId
              customMsgHelper:(EaseCustomMessageHelper*)customMsgHelper
                 customOption:(EaseChatViewCustomOption *)customOption;

- (void)sendGiftAction:(NSString *)giftId num:(NSInteger)num completion:(void (^)(BOOL success))aCompletion;

- (void)updateChatViewWithHidden:(BOOL)isHidden;

@end
