//
//  EaseExtendMenuModel.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/24.
//

#import "EaseExtendMenuModel.h"

@implementation EaseExtendMenuModel

- (instancetype)initWithData:(UIImage *)icon funcDesc:(NSString *)funcDesc handle:(menuItemDidSelectedHandle)menuItemHandle
{
    if (self = [super init]) {
        if (icon) {
            _icon = icon;
        }
        if (funcDesc) {
            _funcDesc = funcDesc;
        }
        if (menuItemHandle) {
            _itemDidSelectedHandle = menuItemHandle;
        }
    }
    return self;
}

@end
