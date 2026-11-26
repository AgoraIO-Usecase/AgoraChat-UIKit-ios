/**
 *  \
 *  @header AgoraChatImageMessageBody.h
 *  @abstract Image message body class
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatFileMessageBody.h"

/**
 *  \
 *  The image message body.
 * 
 *  You can create an image message body by calling `(instancetype)initWithLocalPath:displayName:`.
 *
 *  Note: SDK will compress the image based on the `compressRatio` attribute when delivering the image.
 */
@interface AgoraChatImageMessageBody : AgoraChatFileMessageBody

/**
 *  \
 *  The image dimensions.
 */
@property (nonatomic) CGSize size;

/**
 *  \
 *  The compression ratio of the image file.
 *  
 *  When sending the image message, the SDK compresses the image file according to the value of this parameter. The value range is (0.0, 1.0], and the default value is 0.6. 1.0 means that the SDK does not compress the image file, and 0.6 means that the SDK compresses the file size to 60% of the original. If you set this parameter to a value lower than 0 (included), the SDK uses the default value.
 */
@property (nonatomic) CGFloat compressionRatio;

/**
 *  \
 *  The display name of thumbnail.
 */
@property (nonatomic, copy) NSString *thumbnailDisplayName;

/**
 *  \
 *  The local path of the thumbnail.
 * 
 *  The sender can obtain the local path of the thumbnail via this property, and read the thumbnail data by calling the `imageWithContentsOfFile:` method and passing `thumbnailLocalPath`.
 * 
 *  UIImage *image = [UIImage imageWithContentsOfFile:thumbnailLocalPath];
 */
@property (nonatomic, copy) NSString *thumbnailLocalPath;

/**
 *  \
 *  The URL path of the thumbnail of the server.
 *  
 *  The message recipient can obtain the remote path of the thumbnail with this property.
 */
@property (nonatomic, copy) NSString *thumbnailRemotePath;

/**
 *  \
 *  The secret key for the thumbnail. 
 * 
 *  A key is required for verification when downloading thumbnail.
 */
@property (nonatomic, copy) NSString *thumbnailSecretKey __deprecated_msg("Use secretKey instead for original image");

/**
 *  \
 *  The thumbnail dimensions.
 */
@property (nonatomic) CGSize thumbnailSize;

/**
 *  \
 *  The thumbnail file size (in bytes).
 */
@property (nonatomic) long long thumbnailFileLength;

/**
 *  \
 *  The download status of the thumbnail.
 */
@property (nonatomic)AgoraChatDownloadStatus thumbnailDownloadStatus;
/**
 *  \
 *  The local path of the large image. 
 * 
 * The sender can obtain the local path of the large image via this property and read image data using `imageWithContentsOfFile`.
 */
@property (nonatomic, copy) NSString *bigImageLocalPath;
/**
 *  \
 *  The URL of the large image on the server. 
 * 
 *  The recipient can get the remote URL of the large image via this property.
 */
@property (nonatomic, copy, readonly) NSString *bigImageRemotePath;
/**
 *  \
 *  The download status of the large image.
 */
@property(nonatomic)AgoraChatDownloadStatus bigImageDownloadStatus;

/**
 *  \
 *  Whether the image is a GIF file.
 */
@property (nonatomic) BOOL isGif;
/**
 *  \
 *  Whether the sender sends the original image. 
 * 
 *  - `true`：The sender sends the original image.
 *  - `false`：The sender sends the large image that is a compressed image.
 * 
 *  For the sender, this property specifies whether to send the original image or large image (compressed image).
 * 
 *  For the recipient, it indicates whether remotePath refers to the original image or the large image (compressed image).
 */
@property (nonatomic) BOOL isOriginalImage;

/**
 *  \
 *  Initializes a GIF message instance.
 *
 *  @param aLocalPath   The path of the GIF file attachment in the local device.
 *  @param aDisplayName The display name (excluding the path) of the GIF file attachment.
 *
 *  @result The GIF file message instance.
 */
- (instancetype)initWithGifFilePath:(NSString*)aGifFilePath
                        displayName:(NSString*)aDisplayName;

@end
