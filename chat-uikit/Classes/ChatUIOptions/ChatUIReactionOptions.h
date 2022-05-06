//
//  ChatUIReactionOptions.h
//  AgoraChatCallKit
//
//  Created by 冯钊 on 2022/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatUIReactionOptions : NSObject

/// 是否开启reaction功能
@property (nonatomic, assign, getter=isOpen) BOOL open;
@property (nonatomic, strong) UIColor *reactionDetailViewBackgroundColor;
@property (nonatomic, strong) UIColor *reactionDetailViewReactionItemSelectedBackgroundColor;

@end

NS_ASSUME_NONNULL_END
