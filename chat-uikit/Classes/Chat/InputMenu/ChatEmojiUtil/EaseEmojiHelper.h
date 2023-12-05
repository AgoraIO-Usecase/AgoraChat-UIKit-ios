//
//  EaseEmojiHelper.h
//  EaseChat
//
//  Created by XieYajie on 2019/1/31.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseEmojiHelper : NSObject

@property (nonatomic, strong) NSDictionary *convertEmojiDic;

+ (instancetype)sharedHelper;

+ (NSArray<NSString *> *)getAllEmojis;

+ (NSString *)convertEmoji:(NSString *)aString;

+ (NSString *)convertFromEmoji:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
