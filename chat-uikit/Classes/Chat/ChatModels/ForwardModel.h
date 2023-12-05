//
//  ForwardModel.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/26.
//

#import <Foundation/Foundation.h>
#import "EasePublicHeaders.h"
#import "EaseUserProfile.h"


NS_ASSUME_NONNULL_BEGIN

@interface ForwardModel : NSObject

@property (nonatomic, weak) id<EaseUserProfile> userDataProfile;

@property (nonatomic, strong) AgoraChatMessage *message;

@property (nonatomic, strong) NSString *date;

@property (nonatomic) BOOL isPlaying;

@property (nonatomic, strong, readonly,nullable) NSAttributedString *contentAttributeText;

@property (nonatomic, assign, readonly) CGFloat contentHeight;

@property (nonatomic) void(^reloadHeight)(NSString *messageId);

- (instancetype)initWithAgoraChatMessage:(AgoraChatMessage *)forwardMessage;

@end

NS_ASSUME_NONNULL_END
