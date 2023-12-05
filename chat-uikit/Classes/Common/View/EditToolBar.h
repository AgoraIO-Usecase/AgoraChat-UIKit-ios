//
//  EditToolBar.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/8/10.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditBarOperationType) {
    EditBarOperationTypeDelete = 0,
    EditBarOperationTypeForward
};

NS_ASSUME_NONNULL_BEGIN

@interface EditToolBar : UIView

- (instancetype)initWithFrame:(CGRect)frame operationClosure:(void(^)(EditBarOperationType))operationClosure;

- (void)hiddenWithOperation:(EditBarOperationType)type;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
