//
//  EaseBaseTableViewModel.m
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/11.
//

#import "EaseBaseTableViewModel.h"

@implementation EaseBaseTableViewModel
- (instancetype)init {
    if( self = [super init]) {
        _canRefresh = YES;
    }
    
    return self;
}
@end
