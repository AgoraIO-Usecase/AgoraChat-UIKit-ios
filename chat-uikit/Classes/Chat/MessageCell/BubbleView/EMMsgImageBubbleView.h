//
//  EMMsgImageBubbleView.h
//  EaseChat
//
//  Created by XieYajie on 2019/2/14.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import "EaseChatMessageBubbleView.h"
#import "EaseHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMMsgImageBubbleView : EaseChatMessageBubbleView

@property (nonatomic, strong) UIImageView *photo;

- (void)setThumbnailImageWithLocalPath:(NSString *)aLocalPath
                            remotePath:(NSString *)aRemotePath
                          thumbImgSize:(CGSize)aThumbSize
                               imgSize:(CGSize)aSize;

@end

NS_ASSUME_NONNULL_END
