//
//  AgoraChatMessage+EaseUIExt.m
//  EaseIMKit
//
//  Created by 冯钊 on 2023/4/26.
//

#import "AgoraChatMessage+EaseUIExt.h"
#import "EaseDefines.h"

@implementation AgoraChatMessage (EaseUIExt)

- (NSString *)easeUI_quoteShowText
{
    switch (self.body.type) {
        case AgoraChatMessageBodyTypeText: {
            return ((AgoraChatTextMessageBody *)self.body).text;
        }
        case AgoraChatMessageBodyTypeLocation:
            return @"[location]";
        case AgoraChatMessageBodyTypeImage:
            return @"[image]";
            
        case AgoraChatMessageBodyTypeCombine:
        case AgoraChatMessageBodyTypeFile:
            return [NSString stringWithFormat:@"%@%@", @"[file]", ((AgoraChatFileMessageBody *)self.body).displayName];
        case AgoraChatMessageBodyTypeVoice:
            return [NSString stringWithFormat:@"%@%d”", @"[audio]", ((AgoraChatVoiceMessageBody *)self.body).duration];
        case AgoraChatMessageBodyTypeVideo:
            return @"[video]";
        default:
            return @"unknow message";
    }
}

@end
