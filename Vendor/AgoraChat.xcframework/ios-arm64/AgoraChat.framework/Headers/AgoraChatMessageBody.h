/**
 *  \
 *  @header AgoraChatMessageBody.h
 *  @abstract Base class of message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

/**
 *  \
 *  The enum of message body types.
 */
typedef NS_ENUM(NSInteger, AgoraChatMessageBodyType) {
    /** \ A text message.*/
    AgoraChatMessageBodyTypeText   = 1,
    /** \ An image message.*/
    AgoraChatMessageBodyTypeImage,
    /** \ A video message.*/
    AgoraChatMessageBodyTypeVideo,
    /** \ A location message.*/
    AgoraChatMessageBodyTypeLocation,
    /** \ A voice message.*/
    AgoraChatMessageBodyTypeVoice,
    /** \ A file message.*/
    AgoraChatMessageBodyTypeFile,
    /** \ A command message.*/
    AgoraChatMessageBodyTypeCmd,
    /** \ A custom message.*/
    AgoraChatMessageBodyTypeCustom,
    /** \ A combine message.*/
    AgoraChatMessageBodyTypeCombine,
    /** \ A multi-body (composite) message. Only used by the contentType property of AgoraChatMessage to indicate that a message carries multiple bodies. It is not a concrete message body type and has no counterpart in the Core message body type enum.*/
    AgoraChatMessageBodyTypeMultiBody,
};

/**
 *  \
 *  The message body.
 */
@interface AgoraChatMessageBody : NSObject

-(instancetype _Nonnull ) init NS_UNAVAILABLE;

/**
 *  \
 *  The message body type.
 */
@property (nonatomic, readonly) AgoraChatMessageBodyType type;
/**
 *  \
 *  Get the UNIX timestamp of the last message modification, in milliseconds.
 */
@property (nonatomic, assign,readonly) NSUInteger operationTime;
/**
 *  \
 *  Get the user ID of the operator that modified the message last time.
 */
@property (nonatomic,nullable,readonly) NSString *operatorId;
/**
 *  \
 *  Get the number of times a message is modified.
 */
@property (nonatomic, assign,readonly) NSUInteger operatorCount;

@end
