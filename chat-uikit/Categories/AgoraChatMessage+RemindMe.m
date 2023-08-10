//
//  AgoraChatMessage+RemindMe.m
//  chat-uikit
//
//  Created by li xiaoming on 2023/8/2.
//

#import "AgoraChatMessage+RemindMe.h"

@implementation AgoraChatMessage (RemindMe)
- (BOOL)remindMe
{
    if(self.body.type == AgoraChatMessageBodyTypeText && self.isChatThreadMessage != YES && self.direction == AgoraChatMessageDirectionReceive) {
        AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:self.conversationId type:AgoraChatConversationTypeGroupChat createIfNotExist:NO];
        
        if(conversation.type == AgoraChatConversationTypeGroupChat && self.isChatThreadMessage != YES) {
            //群聊@“我”提醒
            NSDictionary* ext = self.ext;
            if (ext && [ext objectForKey:@"em_at_list"]) {
                id atList = [ext objectForKey:@"em_at_list"];
                if ([atList isKindOfClass:[NSString class]]) {
                    if ([atList isEqualToString:@"ALL"]) {
                        return YES;
                    }
                } else {
                    if (AgoraChatClient.sharedClient.currentUsername.length > 0 && [(NSArray*)atList containsObject:AgoraChatClient.sharedClient.currentUsername]) {
                        return YES;
                    }
                }
            }
        };
    }
    return NO;
}
@end
