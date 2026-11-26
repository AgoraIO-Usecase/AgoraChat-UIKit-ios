/**
 *  \
 *  @header AgoraChatGroupSharedFile.h
 *  @abstract Group share file
 *  @author Hyphenate
 *  @version 3.00
 */
#import <Foundation/Foundation.h>

/**
 *  \
 *  The group shared file object.
 */
@interface AgoraChatGroupSharedFile : NSObject

/**
 *  \
 *  The file ID, which is the unique identifier of a file.
 */
@property (nonatomic, copy, readonly) NSString *fileId;

/**
 *  \
 *  The name of the file.
 */
@property (nonatomic, copy, readonly) NSString *fileName;

/**
 *  \
 *  The owner of the file.
 */
@property (nonatomic, copy, readonly) NSString *fileOwner;

/**
 *  \
 *  The Unix timestamp for creating the file, in ms.
 */
@property (nonatomic) long long createdAt;

/**
 *  \
 *  The data length (bytes) of the file. 
 */
@property (nonatomic) long long fileSize;

/**
 *  \
 *  Gets the shared file instance.
 *
 *  @param aFileId  The file ID.
 *
 *  @result The shared file instance.
 */
+ (instancetype)sharedFileWithId:(NSString*)aFileId;

@end
