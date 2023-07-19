//
//  EaseURLPreviewManager.h
//  EaseIMKit
//
//  Created by 冯钊 on 2023/5/23.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AgoraURLPreviewState) {
    EaseURLPreviewStateLoading,
    EaseURLPreviewStateSuccess,
    EaseURLPreviewStateFaild,
};

NS_ASSUME_NONNULL_BEGIN

@interface AgoraURLPreviewResult: NSObject

@property (nonatomic, assign) AgoraURLPreviewState state;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageUrl;

@end

typedef void(^AgoraURLPreviewSuccessBlock)(AgoraURLPreviewResult *result);
typedef void(^AgoraURLPreviewFailedBlock)(void);

@interface AgoraURLPreviewManager : NSObject

+ (instancetype)shared;

- (void)preview:(NSURL *)url successHandle:(AgoraURLPreviewSuccessBlock)successHandle faieldHandle:(nullable AgoraURLPreviewFailedBlock)faieldHandle;

- (nullable AgoraURLPreviewResult *)resultWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
