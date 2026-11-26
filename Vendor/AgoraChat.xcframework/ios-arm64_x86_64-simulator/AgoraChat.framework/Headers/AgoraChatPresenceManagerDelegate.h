//
//  AgoraChatPresenceManagerDelegate.h
//  AgoraChat
//
//  Created by lixiaoming on 2022/1/14.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraChatPresence.h"

/*!
 *  \
 *  The delegate protocol that defines presence callbacks.
 */
@protocol AgoraChatPresenceManagerDelegate <NSObject>
@optional

/*!
 *  \
 *  Occurs when the presence state of a subscribed user changes.
 *
 *  @param presences The new presence state of a subscribed user.
 */
- (void) presenceStatusDidChanged:(NSArray<AgoraChatPresence*>* _Nonnull)presences;

@end
