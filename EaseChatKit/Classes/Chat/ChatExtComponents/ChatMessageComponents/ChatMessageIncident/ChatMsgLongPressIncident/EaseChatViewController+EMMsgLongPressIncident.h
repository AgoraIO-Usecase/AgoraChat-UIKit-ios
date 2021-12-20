//
//  EaseChatViewController+EMMsgLongPressIncident.h
//  EaseIM
//
//  Created by zhangchong on 2020/7/9.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "EaseChatViewController.h"
#import "EaseMessageModel.h"
#import "EaseMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatViewController (EMMsgLongPressIncident)

@property (strong, nonatomic) NSIndexPath *__nullable longPressIndexPath;

- (void)deleteLongPressAction:(void (^)(AgoraChatMessage *deleteMsg))aCompletionBlock;
- (void)recallLongPressAction;
- (void)copyLongPressAction;

- (void)resetCellLongPressStatus:(EaseMessageCell *)aCell;

@end

NS_ASSUME_NONNULL_END
