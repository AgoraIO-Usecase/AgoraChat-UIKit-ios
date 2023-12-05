//
//  ForwardList.h
//  AgoraChatCallKit
//
//  Created by 朱继超 on 2023/7/27.
//

#import <UIKit/UIKit.h>
@class AgoraChatMessage;
@class ForwardModel;
@class ForwardMessageCell;
NS_ASSUME_NONNULL_BEGIN

@interface ForwardList : UITableView

@property (nonatomic, copy) void (^selectBlock)(ForwardModel *model,ForwardMessageCell *cell);

@property (nonatomic, strong) NSMutableArray <ForwardModel *>*forwards;

/// Description Forward message list init method.When you wanna custom UI,can conform `self`'s delegate&dataSource.
/// - Parameters:
///   - frame: Axis position
///   - style: UITableViewStyle
///   - messages: Data of ForwardModel.

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style models:(NSArray <ForwardModel *>*)models;

@end

NS_ASSUME_NONNULL_END
