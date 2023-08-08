//
//  EMAudioPlayerUtil.h
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/17.
//

#import <Foundation/Foundation.h>


@interface EMAudioPlayerUtil : NSObject

@property (nonatomic, strong) id _Nullable model;

@property (nonatomic) BOOL isPlaying;

+ (instancetype _Nonnull )sharedHelper;

- (void)startPlayerWithPath:(NSString * _Nonnull)aPath
                      model:(id _Nonnull)aModel
                 completion:(void(^_Nullable)(NSError * _Nullable error))aCompleton;

- (void)stopPlayer;

@end
