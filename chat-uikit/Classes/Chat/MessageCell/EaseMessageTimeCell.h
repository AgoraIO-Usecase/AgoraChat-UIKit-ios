//
//  EaseMessageTimeCell.h
//  EaseChat
//
//  Created by XieYajie on 2019/2/20.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseChatViewModel.h"
#import "EaseChatEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseMessageTimeCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

- (instancetype)initWithViewModel:(EaseChatViewModel *)viewModel remindType:(EaseChatWeakRemind)remidType;

- (NSAttributedString *)cellAttributeText:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
