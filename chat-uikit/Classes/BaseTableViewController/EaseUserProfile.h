//
//  EaseUserProfile.h
//  EaseChatKit
//
//  Created by dujiepeng on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EaseUserProfile <NSObject>
@required
@property (nonatomic, copy, readonly) NSString *easeId;           // Ease id
@optional
@property (nonatomic, copy, readonly) NSString *showName;         // Displayed nickname
@property (nonatomic, copy, readonly) NSString *avatarURL;        // Displays the URL of the avatar
@property (nonatomic, copy, readonly) UIImage *defaultAvatar;     // The default avatar

@end

NS_ASSUME_NONNULL_END
