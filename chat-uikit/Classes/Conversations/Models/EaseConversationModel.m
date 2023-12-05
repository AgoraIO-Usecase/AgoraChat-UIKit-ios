//
//  EaseConversationModel.m
//  EaseChatKit
//
//  Created by zhangchong on 2020/11/10.
//

#import "EaseConversationModel.h"
#import "EaseDefines.h"
#import "UIImage+EaseUI.h"
#import "AgoraChatConversation+EaseUI.h"
#import "EaseEmojiHelper.h"

@interface EaseConversationModel()

{
    AgoraChatConversation *_conversation;
    NSString *_showName;
    long long _latestUpdateTime;
    NSMutableAttributedString *_showInfo;
}

@end

@implementation EaseConversationModel


- (instancetype)initWithConversation:(AgoraChatConversation *)conversation
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _showInfo = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    return self;
}

- (AgoraChatConversationType)type
{
    return _conversation.type;
}

- (void)setIsTop:(BOOL)isTop {
    [_conversation setTop:isTop];
}

- (BOOL)isTop {
    return [_conversation isTop];
}

- (void)setDraft:(NSString *)draft {
    [_conversation setDraft:draft];
}

- (NSString *)draft {
    return [_conversation draft];
}

- (int)unreadMessagesCount {
    return _conversation.unreadMessagesCount;
}

- (NSAttributedString *)showInfo {
    
    if (_latestUpdateTime == _conversation.latestMessage.timestamp) {
        return _showInfo;
    }
    
    AgoraChatMessage *msg = _conversation.latestMessage;
    _latestUpdateTime = msg.timestamp;
    NSString *msgStr = @"";
    switch (msg.body.type) {
        case AgoraChatMessageBodyTypeText:
        {
            AgoraChatTextMessageBody *body = (AgoraChatTextMessageBody *)msg.body;
            msgStr = [EaseEmojiHelper convertEmoji:body.text];

            AgoraChatMessage *lastMessage = [_conversation latestMessage];
            if ([msgStr isEqualToString:EaseCOMMUNICATE_CALLER_MISSEDCALL]) {
                msgStr = @"no answer, call back";
                if ([lastMessage.from isEqualToString:[AgoraChatClient sharedClient].currentUsername])
                    msgStr = @"has been cancelled";
            }
            if ([msgStr isEqualToString:EaseCOMMUNICATE_CALLED_MISSEDCALL]) {
                msgStr = @"the other party has cancelled";
                if ([lastMessage.from isEqualToString:[AgoraChatClient sharedClient].currentUsername])
                    msgStr = @"the other party refuses to talk";
            }
            if (lastMessage.ext && [lastMessage.ext objectForKey:EaseCOMMUNICATE_TYPE]) {
                NSString *communicateStr = @"";
                if ([[lastMessage.ext objectForKey:EaseCOMMUNICATE_TYPE] isEqualToString:EaseCOMMUNICATE_TYPE_VIDEO])
                    communicateStr = @"[video call]";
                if ([[lastMessage.ext objectForKey:EaseCOMMUNICATE_TYPE] isEqualToString:EaseCOMMUNICATE_TYPE_VOICE])
                    communicateStr = @"[voice call]";
                msgStr = [NSString stringWithFormat:@"%@ %@", communicateStr, msgStr];
            }
        }
            break;
        case AgoraChatMessageBodyTypeLocation:
        {
            msgStr = @"[Location]";
        }
            break;
        case AgoraChatMessageBodyTypeCustom:
        {
            msgStr = @"[Custom Message]";
        }
            break;
        case AgoraChatMessageBodyTypeImage:
        {
            msgStr = @"[Image]";
        }
            break;
        case AgoraChatMessageBodyTypeFile:
        {
            msgStr = @"[File]";
        }
            break;
        case AgoraChatMessageBodyTypeCombine:
        {
            msgStr = @"[Chat History]";
        }
            break;
        case AgoraChatMessageBodyTypeVoice:
        {
            msgStr = @"[Audio]";
        }
            break;
        case AgoraChatMessageBodyTypeVideo:
        {
            msgStr = @"[Video]";
        }
            break;
            
        default:
            msgStr = @"";
            break;
    }
    
    _showInfo = [[NSMutableAttributedString alloc] initWithString:msgStr];
    /*
    if ([_conversation draft] && ![[_conversation draft] isEqualToString:@""]) {
        msgStr = [NSString stringWithFormat:@"%@ %@", @"[draft]", [_conversation draft]];
        _showInfo = [[NSMutableAttributedString alloc] initWithString:msgStr];
        [_showInfo setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0 green:43/255.0 blue:43/255.0 alpha:1.0]} range:NSMakeRange(0, msgStr.length)];
    }*/
    if ([_conversation remindALL]) {
        NSString *atStr = @"[@All]";
        msgStr = [NSString stringWithFormat:@"%@ %@", atStr, msgStr];
        _showInfo = [[NSMutableAttributedString alloc] initWithString:msgStr];
        [_showInfo setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:95/255.0 blue:255/255.0 alpha:1.0]} range:NSMakeRange(0, atStr.length)];
    } else
    if ([_conversation remindMe]) {
        NSString *atStr = @"[Someone@You]";
        msgStr = [NSString stringWithFormat:@"%@ %@", atStr, msgStr];
        _showInfo = [[NSMutableAttributedString alloc] initWithString:msgStr];
        [_showInfo setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:95/255.0 blue:255/255.0 alpha:1.0]} range:NSMakeRange(0, atStr.length)];
    }
    return _showInfo;
}

- (BOOL)remindMe {
    return [_conversation remindMe];
}

- (void)markAllAsRead {
    [_conversation markAllMessagesAsRead:nil];
}

- (long long)lastestUpdateTime {
    return _conversation.latestUpdateTime;
}

- (NSString*)easeId
{
    if (_userProfile && [_userProfile respondsToSelector:@selector(easeId)]) {
        return _userProfile.easeId;
    }
    
    return _conversation.conversationId;
}


- (UIImage *)defaultAvatar {
    if (_userProfile && [_userProfile respondsToSelector:@selector(defaultAvatar)]) {
        if (_userProfile.defaultAvatar) {
            return _userProfile.defaultAvatar;
        }
    }
    if (self.type == AgoraChatConversationTypeChat) {
        if ([self.easeId isEqualToString:EaseSYSTEMNOTIFICATIONID]) {
            return [UIImage easeUIImageNamed:@"systemNoti"];;
        }
        return [UIImage easeUIImageNamed:@"default_avatar"];
    }
    if (self.type == AgoraChatConversationTypeGroupChat) {
        return [UIImage easeUIImageNamed:@"groupConversation"];
    }
    if (self.type == AgoraChatConversationTypeChatRoom) {
        return [UIImage easeUIImageNamed:@"chatroomConversation"];
    }
    return nil;
}

- (NSString *)avatarURL {
    if (_userProfile && [_userProfile respondsToSelector:@selector(avatarURL)]) {
        return _userProfile.avatarURL ?: @"";
    }
    
    return nil;
}

- (NSString *)showName {
    if (_userProfile && [_userProfile respondsToSelector:@selector(showName)] && _userProfile.showName) {
        return _userProfile.showName;
    }
    
    if (self.type == AgoraChatConversationTypeGroupChat) {
        NSString *str = [AgoraChatGroup groupWithId:_conversation.conversationId].groupName;
        return str.length != 0 ? str : _conversation.showName;
    }
    
    if (self.type == AgoraChatConversationTypeChatRoom) {
        NSString *str = [AgoraChatroom chatroomWithId:_conversation.conversationId].subject;
        return str.length != 0 ? str : _conversation.showName;
    }
    
    if ([self.easeId isEqualToString:EaseSYSTEMNOTIFICATIONID]) {
        return @"system notification";
    }
    return _conversation.showName;
}

@end
