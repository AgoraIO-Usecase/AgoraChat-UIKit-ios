/**
 *  \
 *  @header   AgoraChatOptions+PrivateDeploy.h
 *  @abstract The SDK setting options of private deployment.
 *  @author   Hyphenate
 *  @version  3.0
 */

#import "AgoraChatOptions.h"

@interface AgoraChatOptions (PrivateDeploy)

/**
 *  \
 *  Whether to allow using DNS. The default value is YES.
 *
 *  Can only be set when initializing the SDK  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime.
 */
@property (nonatomic, assign) BOOL enableDnsConfig;

/**
 *  \
 *  The chat server port.
 *
 *  This property is effective only when `enableDnsConfig` is `NO`.
 *  Can only be set when initializing the SDK with  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime.
 */
@property (nonatomic, assign) int chatPort;

/**
 *  \
 *  The chat server.
 *
 *  This property is effective only when `enableDnsConfig` is `NO`.
 *  Can only be set when initializing the SDK with  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime.
 */
@property (nonatomic, copy) NSString *chatServer;

/**
 *  \
 *  The REST server.
 *
 *  This property is effective only when `enableDnsConfig` is `NO`.
 *  Can only be set when initializing the SDK with  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime
 */
@property (nonatomic, copy) NSString *restServer;

/**
 *  \
 *  Whether to enable TLS encryption when connecting to chatServer or webSocketServer.The default value is NO.
 *
 *  This property is effective only when `enableDnsConfig` is `NO`.
 *  Can only be set when initializing the SDK with  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime
 */
@property (nonatomic, assign) BOOL enableTLSConnection;

/**
 *  \
 *  The DNS url.
 *
 *  This property is effective only when `enableDnsConfig` is `YES`.
 *  Can only be set when initializing the SDK with  {@link AgoraChatClient initializeSDKWithOptions:} , cannot be altered in runtime.
 */
@property (nonatomic, copy) NSString *dnsURL;

/**
 *  \
 *  The WebSocket server address
 *
 * This property takes effect only when `enableDnsConfig` is set to `NO`.
 * 
 * This property can only be set during SDK initialization via {@link AgoraChatClient initializeSDKWithOptions:} and cannot be changed dynamically during application runtime.
 */
@property (nonatomic, copy) NSString* _Nullable webSocketServer;

/**
 *  \
 *  The WebSocket server port.
 * 
 *  This property takes effect only when `enableDnsConfig` is set to `NO`.
 * 
 *  This property can only be set during SDK initialization via {@link AgoraChatClient initializeSDKWithOptions:} and cannot be changed dynamically during application runtime.
*/
@property (nonatomic, assign) int webSocketPort;

@end
