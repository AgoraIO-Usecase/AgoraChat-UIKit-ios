//
//  EaseMessageModel.h
//  EaseChat
//
//  Created by XieYajie on 2019/1/18.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasePublicHeaders.h"
#import "EaseUserProfile.h"

typedef NS_ENUM(NSInteger, AgoraChatMessageType) {
    AgoraChatMessageTypeText = 1,
    AgoraChatMessageTypeImage,
    AgoraChatMessageTypeVideo,
    AgoraChatMessageTypeLocation,
    AgoraChatMessageTypeVoice,
    AgoraChatMessageTypeFile,
    AgoraChatMessageTypeCmd,
    AgoraChatMessageTypeCustom,
    AgoraChatMessageTypeExtCall,
    AgoraChatMessageTypeExtGif,
    AgoraChatMessageTypeExtRecall,
    AgoraChatMessageTypeExtNewFriend,
    AgoraChatMessageTypeExtAddGroup
};


NS_ASSUME_NONNULL_BEGIN
@class EaseMessageCell;
@interface EaseMessageModel : NSObject

@property (nonatomic) id<EaseUserProfile> userDataProfile;

@property (nonatomic, weak) EaseMessageCell *weakMessageCell;

@property (nonatomic, strong) AgoraChatMessage *message;

@property (nonatomic) AgoraChatMessageDirection direction;

@property (nonatomic) AgoraChatMessageType type;

@property (nonatomic) BOOL isPlaying;

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)aMsg;

@end

NS_ASSUME_NONNULL_END
