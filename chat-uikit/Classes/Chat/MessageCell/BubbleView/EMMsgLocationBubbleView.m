//
//  EMMsgLocationBubbleView.m
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EMMsgLocationBubbleView.h"

@implementation EMMsgLocationBubbleView

- (instancetype)initWithDirection:(AgoraChatMessageDirection)aDirection
                             type:(AgoraChatMessageType)aType
                        viewModel:(EaseChatViewModel*)viewModel;
{
    self = [super initWithDirection:aDirection type:aType viewModel:viewModel];
    if (self) {
        if (self.direction == AgoraChatMessageDirectionSend) {
            self.iconView.image = [UIImage easeUIImageNamed:@"msg_location_white"];
        } else {
            self.iconView.image = [UIImage easeUIImageNamed:@"locationMsg"];
        }
    }
    
    return self;
}

#pragma mark - Setter

- (void)setModel:(EaseMessageModel *)model
{
    AgoraChatMessageType type = model.type;
    if (type == AgoraChatMessageTypeLocation) {
        AgoraChatLocationMessageBody *body = (AgoraChatLocationMessageBody *)model.message.body;
        self.textLabel.text = body.address;
        self.detailLabel.text = [NSString stringWithFormat:@"latitude:%.2lf°, longitude:%.2lf°", body.latitude, body.longitude];
    }
}

@end
