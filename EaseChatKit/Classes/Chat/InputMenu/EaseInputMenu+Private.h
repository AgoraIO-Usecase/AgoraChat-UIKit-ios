//
//  EaseInputMenu+Private.h
//  EaseChatKit
//
//  Created by zhangchong on 2021/12/9.
//

#import "EaseInputMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseInputMenu (Private)

- (void)clearInputViewText;

- (void)inputViewAppendText:(NSString *)aText;

- (BOOL)deleteTailText;

- (void)clearMoreViewAndSelectedButton;

@end

NS_ASSUME_NONNULL_END
