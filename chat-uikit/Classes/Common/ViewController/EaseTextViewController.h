//
//  EaseTextViewController.h
//  EaseChatKit
//
//  Created by XieYajie on 2019/1/17.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseTextViewController : UIViewController

@property (nonatomic, copy) BOOL (^doneCompletion)(NSString *aString);

- (instancetype)initWithString:(NSString *)aString
                   placeholder:(NSString *)aPlaceholder
                    isEditable:(BOOL)aIsEditable;

@end

NS_ASSUME_NONNULL_END
