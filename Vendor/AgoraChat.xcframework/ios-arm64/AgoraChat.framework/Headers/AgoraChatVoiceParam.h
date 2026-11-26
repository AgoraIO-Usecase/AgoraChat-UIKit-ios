/**
 *  \
 *  @header AgoraChatVoiceParam.h
 *  @abstract Voice parameters for local voice file recognition.
 *  @author Hyphenate
 *  @version 4.20
 */

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioTypes.h>

/**
 *  \
 *  Supported formats of voice files.
 */
typedef NS_ENUM(UInt32, AgoraChatVoiceFormat) {
    AgoraChatVoiceFormatPCM = kAudioFormatLinearPCM,  /** \ PCM. */
    AgoraChatVoiceFormatAMR = kAudioFormatAMR,        /** \ AMR. */
    AgoraChatVoiceFormatMP3 = kAudioFormatMPEGLayer3, /** \ MP3. */
};

/**
 *  \
 *   Voice parameters for local voice file recognition.
 */
@interface AgoraChatVoiceParam : NSObject

/**
 *  \
 *  The format of the voice file.
 */
@property (nonatomic, assign) AgoraChatVoiceFormat format;

/**
 *  \
 *  The sampling rate of the voice file (in Hz).
 * 
 *  You can directly use the value configured for AVSampleRateKey, for example, 16000.
 */
@property (nonatomic, assign) NSInteger sampleRate;

/**
 *  \
 *  The bit depth of the voice file (in bits), for example, 16.
 */
@property (nonatomic, assign) NSInteger bitsPerSample;

/**
 *  \
 *  The number of channels of the voice file. For example, 1 indicates a mono voice file.
 */
@property (nonatomic, assign) NSInteger channels;

@end
