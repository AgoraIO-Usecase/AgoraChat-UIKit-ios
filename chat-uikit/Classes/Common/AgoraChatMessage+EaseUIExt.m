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
            return @"[Location]";
        case AgoraChatMessageBodyTypeImage:
            return @"[Image]";
        case AgoraChatMessageBodyTypeCombine:
            return [NSString stringWithFormat:@"%@%@", @"[Chat History]", ((AgoraChatCombineMessageBody *)self.body).title];
        case AgoraChatMessageBodyTypeFile:
            return [NSString stringWithFormat:@"%@%@", @"[File]", ((AgoraChatFileMessageBody *)self.body).displayName];
        case AgoraChatMessageBodyTypeVoice:
            return [NSString stringWithFormat:@"%@%d”", @"[Audio]", ((AgoraChatVoiceMessageBody *)self.body).duration];
        case AgoraChatMessageBodyTypeVideo:
            return @"[Video]";
        default:
            return @"unknow message";
    }
}

@end
