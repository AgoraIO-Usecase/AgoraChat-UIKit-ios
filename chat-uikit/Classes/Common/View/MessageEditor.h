//
//  TextMessageEditor.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"
#import <AgoraChat/AgoraChatMessage.h>


NS_ASSUME_NONNULL_BEGIN

@interface MessageEditor : UIView

@property (nonatomic) UIView *background;

@property (nonatomic) UIView *container;

@property (nonatomic) UIButton *cancel;

@property (nonatomic) UIButton *done;

@property (nonatomic) UILabel *title;

@property (nonatomic) PlaceHolderTextView *textView;

/// Description initialize method
/// - Parameters:
///   - frame: frame
///   - message: AgoraChat message
///   - doneClosure: Returns a content string, the text message is text, otherwise it is the file path.
- (instancetype)initWithFrame:(CGRect)frame message:(AgoraChatMessage *)message doneClosure:(void (^)(NSString *))doneClosure;

- (void)showWithVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
