//
//  AgoraChatThreadListNavgation.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/14.
//

#import <UIKit/UIKit.h>

@interface AgoraChatThreadListNavgation : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *detail;

@property (nonatomic, copy) void (^backBlock)(void);

@end

