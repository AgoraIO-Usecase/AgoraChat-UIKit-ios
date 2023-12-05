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

#define ImageQuoteSize CGSizeMake(36, 36)
#define CompositeStyleSize CGSizeMake(16, 16)

typedef NS_ENUM(NSInteger, AgoraChatMessageType) {
    AgoraChatMessageTypeText = 1,
    AgoraChatMessageTypeImage,
    AgoraChatMessageTypeVideo,
    AgoraChatMessageTypeLocation,
    AgoraChatMessageTypeVoice,
    AgoraChatMessageTypeFile,
    AgoraChatMessageTypeCmd,
    AgoraChatMessageTypeCustom,
    AgoraChatMessageTypeCombine,
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

@property (nonatomic) BOOL isUrl;

@property (nonatomic) BOOL selected;

@property (nonatomic) BOOL editMode;

@property (nonatomic, strong,nullable) NSAttributedString *quoteContent;

@property (nonatomic, assign, readonly) CGFloat quoteHeight;

@property (nonatomic, strong) NSAttributedString *editSymbol;

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)aMsg;

@end

NS_ASSUME_NONNULL_END
