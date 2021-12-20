//
//  EaseInputMenuRecordAudioView.h
//  EaseChat
//
//  Created by XieYajie on 2019/1/29.
//  Copyright © 2019 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EaseInputMenuRecordAudioViewDelegate;
@interface EaseInputMenuRecordAudioView : UIView

@property (nonatomic, weak) id<EaseInputMenuRecordAudioViewDelegate> delegate;

- (instancetype)initWithRecordPath:(NSString *)aPath;

@end

@protocol EaseInputMenuRecordAudioViewDelegate <NSObject>

@optional
- (void)chatBarRecordAudioViewStartRecord;

- (void)chatBarRecordAudioViewStopRecord:(NSString *)aPath
                              timeLength:(NSInteger)aTimeLength;

- (void)chatBarRecordAudioViewCancelRecord;

@end

NS_ASSUME_NONNULL_END
