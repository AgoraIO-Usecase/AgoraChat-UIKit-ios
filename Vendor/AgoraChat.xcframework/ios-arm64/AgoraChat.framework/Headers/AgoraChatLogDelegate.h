//
//  AgoraChatLogDelegate.h
//  AgoraChat
//
//  Created by li xiaoming on 2022/7/29.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  \
 *  The delegate protocol of log callback.
 */
@protocol AgoraChatLogDelegate <NSObject>
@optional

/*!
 *  \
 *  Occurs when the sdk output logs.
 *
 *  @param log  The log to output.
 */
- (void) logDidOutput:(NSString* _Nonnull)log;

@end
