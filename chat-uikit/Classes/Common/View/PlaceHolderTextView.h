//
//  PlaceHolderTextView.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
