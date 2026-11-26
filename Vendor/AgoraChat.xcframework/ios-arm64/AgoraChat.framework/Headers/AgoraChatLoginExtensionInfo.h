//
//  AgoraChatLoginInfo.h
//  AgoraChat
//
//  Created by 朱继超 on 2024/5/23.
//  Copyright © 2024 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgoraChatLoginExtensionInfo : NSObject

/**
 *  \
 *  The device name.
 */
@property (nonatomic, copy) NSString *deviceName;

/**
 *  \
 * The extension information contained in the notification sent to device A that is kicked offline due to the user's login to device B.
 */
@property (nonatomic, copy) NSString *extensionInfo;

@end

NS_ASSUME_NONNULL_END
