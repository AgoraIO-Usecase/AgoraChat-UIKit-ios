//
//  EaseThreadConversation.h
//  chat-uikit
//
//  Created by 朱继超 on 2022/3/29.
//

#import <Foundation/Foundation.h>

#import <AgoraChat/AgoraChatMessage.h>
#import "EaseUserProfile.h"

@interface EaseThreadConversation : NSObject

@property (nonatomic) id<EaseUserProfile> userDataProfile;

@property (nonatomic, strong) AgoraChatThread *threadInfo;

@property (nonatomic, strong) AgoraChatMessage *lastMessage;

@end

