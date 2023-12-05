//
//  EaseEmojiHelper.m
//  EaseChat
//
//  Created by XieYajie on 2019/1/31.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseEmojiHelper.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

static EaseEmojiHelper *helper = nil;
@implementation EaseEmojiHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _convertEmojiDic = @{
            @"[):]":@"😀", @"[:D]":@"😟", @"[;)]":@"😍", @"[:-o]":@"😳", @"[:p]":@"😎", @"[(H)]":@"😭", @"[:@]":@"😊",
            @"[:s]":@"🤐", @"[:$]":@"😴", @"[:(]":@"😢", @"[:'(]":@"😝", @"[:|]":@"😫", @"[(a)]":@"😜", @"[8o|]":@"😁",
            @"[8-|]":@"🤔", @"[+o(]":@"☹️", @"[<o)]":@"😡", @"[|-)]":@"😓", @"[*-)]":@"🤢", @"[:-#]":@"😵", @"[:-*]":@"🙄",
            @"[^o)]":@"😊", @"[8-)]":@"😠", @"[(|)]":@"😪", @"[(u)]":@"🤥", @"[(S)]":@"😄", @"[(*)]":@"🤡", @"[(#)]":@"🤤",
            @"[(R)]":@"😱", @"[({)]":@"🤧", @"[(})]":@"😑", @"[(k)]":@"😬", @"[(F)]":@"😯", @"[(W)]":@"😧", @"[(D)]":@"🤑",
            @"[(E)]":@"😂", @"[(T)]":@"🤗", @"[(G)]":@"👏", @"[(Y)]":@"🤝", @"[(I)]":@"👍", @"[(J)]":@"👎", @"[(K)]":@"👌",
            @"[(L)]":@"❤️", @"[(M)]":@"💔", @"[(N)]":@"💣", @"[(O)]":@"💩", @"[(P)]":@"🌹", @"[(U)]":@"🙏", @"[(Z)]":@"🎉"};
    }
    
    return self;
}

+ (instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[EaseEmojiHelper alloc] init];
    });
    
    return helper;
}

+ (NSString *)emojiWithCode:(int)aCode
{
    int sym = EMOJI_CODE_TO_SYMBOL(aCode);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}

+ (NSArray<NSString *> *)getAllEmojis
{
    NSArray *emojis = @[@"😀", @"😟", @"😍", @"😳", @"😎", @"😭", @"😊",
                        @"🤐", @"😴", @"😢", @"😝", @"😫", @"😜", @"😁",
                        @"🤔", @"☹️", @"😡", @"😓", @"🤢", @"😵", @"🙄",
                        @"😊", @"😠", @"😪", @"🤥", @"😄", @"🤡", @"🤤",
                        @"😱", @"🤧", @"😑", @"😬", @"😯", @"😧", @"🤑",
                        @"😂", @"🤗", @"👏", @"🤝", @"👍", @"👎", @"👌",
                        @"❤️", @"💔", @"💣", @"💩", @"🌹", @"🙏", @"🎉"];

    return emojis;
}

+ (NSString *)convertEmoji:(NSString *)aString
{
    NSDictionary *emojisDic = [EaseEmojiHelper sharedHelper].convertEmojiDic;
    NSRange range;
    range.location = 0;
    
    NSMutableString *retStr = [NSMutableString stringWithString:aString];
    for (NSString *key in emojisDic) {
        range.length = retStr.length;
        NSString *value = emojisDic[key];
        [retStr replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:range];
    }
    
    return retStr;
}

+ (NSString *)convertFromEmoji:(NSString *)aString
{
    NSMutableString* tmp = [aString mutableCopy];
    [EaseEmojiHelper.sharedHelper.convertEmojiDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSRange range;
            range.location = 0;
            range.length = tmp.length;
            [tmp replaceOccurrencesOfString:obj withString:key options:NSLiteralSearch range:range];
    }];
    
    return tmp;
}

@end
