//
//  EaseExtendMenuModel.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseExtendMenuModel : NSObject

typedef void(^menuItemDidSelectedHandle)(NSString* itemDesc, BOOL isExecuted);

- (instancetype)initWithData:(UIImage *)icon funcDesc:(NSString *)funcDesc handle:(menuItemDidSelectedHandle)menuItemHandle;

// Icon
@property (nonatomic, strong) UIImage *icon;

// Function description
@property (nonatomic, strong) NSString *funcDesc;

@property (nonatomic, strong) UIColor *funcDescColor;

@property (nonatomic) BOOL showMore;

// Handle
@property (nonatomic, strong) menuItemDidSelectedHandle itemDidSelectedHandle;

@end

NS_ASSUME_NONNULL_END
