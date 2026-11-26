/**
 *  \
 *  @header AgoraChatFileMessageBody.h
 *  @abstract The file message body.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"

/**
 *  \
 *  The status types for downloading the file message.
 */
typedef NS_ENUM(NSInteger, AgoraChatDownloadStatus) {
    AgoraChatDownloadStatusDownloading   = 0,  /** \ The SDK is downloading the file message. */
    AgoraChatDownloadStatusSucceed,            /** \ The SDK successfully downloads the file message. */
    AgoraChatDownloadStatusFailed,             /** \ The SDK fails to download the file message.*/
    AgoraChatDownloadStatusPending,            /** \ File message download is pending.*/
};

/**
 *  \
 *  The file message body.
 */
@interface AgoraChatFileMessageBody : AgoraChatMessageBody

/**
 *  \
 *  The display name of the attachment.
 */
@property (nonatomic, copy) NSString *displayName;

/**
 *  \
 *  The path of the attachment on the local device.
 */
@property (nonatomic, copy) NSString *localPath;

/**
 *  \
 *  The path of the attachment in the server.
 */
@property (nonatomic, copy) NSString *remotePath;

/**
 *  \
 *  The secret key for downloading the message attachment.
 */
@property (nonatomic, copy) NSString *secretKey;

/**
 *  \
 *  The data length (bytes) of the attachment.
 */
@property (nonatomic) long long fileLength;

/**
 *  \
 *  The downloading status of the attachment.
 */
@property (nonatomic) AgoraChatDownloadStatus downloadStatus;

/**
 *  \
 *  Initializes a file message instance.
 *
 *  @param aLocalPath   The path of the file attachment in the local device.
 *  @param aDisplayName The display name of the file attachment.
 *
 *  @result The file message instance.
 */
- (instancetype _Nonnull)initWithLocalPath:(NSString * _Nonnull)aLocalPath
                              displayName:(NSString * _Nonnull)aDisplayName;


@end
