//
//  EMStreamChunk.h
//  AgoraChat
//
//  Created by 朱继超 on 12/25/25.
//  Copyright © 2025 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,EMStreamChunkStatus) {
    /**
     * \ Stream started.
     */
    EMStreamChunkStatusStart = 0,          // Stream started
    /**
     * \ Stream started and completed in one chunk (single fragment).
     */
    EMStreamChunkStatusStartAndComplete, // Stream started and completed in one chunk (single fragment)
    /**
     * \ Stream in progress.
     */
    EMStreamChunkStatusProgress,       // Stream in progress
    /**
     * \ Stream completed.
     */
    EMStreamChunkStatusComplete,       // Stream completed
    /**
     * \ Stream ended with error.
     */
    EMStreamChunkStatusError           // Stream ended with error
};

NS_ASSUME_NONNULL_BEGIN

@interface EMStreamChunk : NSObject
/**
 * \ Stream chunk status of the stream chunk.
 */
@property (nonatomic) EMStreamChunkStatus status;
/**
 * \ Stream chunk error code of the stream chunk. Default value is 0, which indicates no error. If the value is not 0, please refer to the AgoraChatErrorCode error code table for details.
 */
@property (nonatomic) int16_t errorCode;
/**
 * \ Stream chunk finish reason of the stream chunk. Passed through by the user. `0` indicates no exception.
 */
@property (nonatomic) int16_t finishReason;
/**
 * \ Text content of the stream chunk.
 */
@property (nonatomic, copy) NSString* text;
/**
 * \ Custom type of the stream chunk.
 */
@property (nonatomic, copy) NSString *_Nullable customType;
/**
 * \ Whether the stream message is completed. YES when status is Complete or StartAndComplete.
 */
@property (nonatomic, readonly) BOOL isComplete;

@end

NS_ASSUME_NONNULL_END
