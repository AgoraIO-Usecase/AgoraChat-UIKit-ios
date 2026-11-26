/**
 *  \
 *  @header AgoraChatVideoMessageBody.h
 *  @abstract The video message body.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatFileMessageBody.h"

/**
 *  \
 *  The video message body.
 */
@interface AgoraChatVideoMessageBody : AgoraChatFileMessageBody

/**
 *  \
 *  The video duration, in seconds.
 */
@property (nonatomic) int duration;

/**
 *  \
 *  The local path of thumbnail.
 */
@property (nonatomic, copy) NSString *_Nullable thumbnailLocalPath;

/**
 *  \
 *  The URL of the thumbnail on the server.
 */
@property (nonatomic, copy) NSString *_Nullable thumbnailRemotePath;

/**
 *  \
 *  The secret key of the thumbnail, which is required for verification when downloading the thumbnail.
 */
@property (nonatomic, copy) NSString *_Nullable thumbnailSecretKey;

/**
 *  \
 *  The size of the video thumbnail.
 */
@property (nonatomic) CGSize thumbnailSize;

/**
 *  \
 *  The download status of the thumbnail.
 */
@property (nonatomic)AgoraChatDownloadStatus thumbnailDownloadStatus;

-(instancetype _Nonnull ) init NS_UNAVAILABLE;
@end
