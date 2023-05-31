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
    AgoraChatMessageTypeExtAddGroup,
    AgoraChatMessageTypeExtURLPreview,
};


NS_ASSUME_NONNULL_BEGIN
@class EaseMessageCell;
@interface EaseMessageModel : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic) id<EaseUserProfile> userDataProfile;

@property (nonatomic) id<EaseUserProfile> threadUserProfile;

@property (nonatomic, weak) EaseMessageCell *weakMessageCell;

@property (nonatomic, strong) AgoraChatMessage *message;

@property (nonatomic) AgoraChatMessageDirection direction;

@property (nonatomic) AgoraChatMessageType type;

@property (nonatomic) AgoraChatThread *thread;

@property (nonatomic) BOOL isPlaying;

@property (nonatomic) BOOL isHeader;

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)aMsg;

@end

NS_ASSUME_NONNULL_END
