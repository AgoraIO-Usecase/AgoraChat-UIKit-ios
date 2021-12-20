//
//  EMMsgRecordCell.h
//  EaseIM
//
//  Created by zhangchong on 2019/12/9.
//  Copyright © 2019 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 chat record
*/
@protocol EMMsgRecordCellDelegate;
@interface EMMsgRecordCell : UITableViewCell

@property (nonatomic, weak) id<EMMsgRecordCellDelegate> delegate;

@property (nonatomic, strong) NSArray<EaseMessageModel *> *models;

@end

@protocol EMMsgRecordCellDelegate <NSObject>

@optional

- (void)imageViewDidTouch:(EaseMessageModel *)aModel;

- (void)videoViewDidTouch:(EaseMessageModel *)aModel;

@end

NS_ASSUME_NONNULL_END
