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
//display custom message cell at indexpath
- (UITableViewCell *)easeMessageCellForRowAtIndexPath:(NSIndexPath *)indexPath;

//height for custom message cell at indexpath
- (CGFloat)easeMessageCellHeightAtIndexPath:(NSIndexPath *)indexPath;

//display custom join cell at indexpath
- (UITableViewCell *)easeJoinCellForRowAtIndexPath:(NSIndexPath *)indexPath;

//height for custom join cell at indexpath
- (CGFloat)easeJoinCellHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectUserWithMessage:(AgoraChatMessage*)message;

- (void)chatViewDidBottomOffset:(CGFloat)offset;

- (void)chatViewDidSendMessage:(AgoraChatMessage *)message
                         error:(AgoraChatError *)error;

@end

@interface EaseChatView : UIView

@property (nonatomic, weak) id<EaseChatViewDelegate> delegate;

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
