/**
 *  \
 *  @header AgoraChatDeviceConfig.h
 *  @abstract The information of the device.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/**
 *  \
 *  The configurations of the device that the user logs into.
 */
@interface AgoraChatDeviceConfig : NSObject

/**
 *  \
 *  The device resources.
 */
@property (nonatomic, readonly) NSString * _Nullable resource;

/**
 *  \
 *  The device UUID.
 */
@property (nonatomic, readonly) NSString * _Nullable deviceUUID;

/**
 *  \
 *  The device name.
 */
@property (nonatomic, readonly) NSString * _Nullable deviceName;

@end
