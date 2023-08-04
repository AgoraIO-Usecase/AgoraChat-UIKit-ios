//
//  ForwardContainer.h
//  chat-uikit
//
//  Created by 朱继超 on 2023/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForwardContainer : UILabel

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UILabel *content;

/// Description start imageView animationImages animation
/// - Parameter images: animationImages
- (void)starAnimation:(NSArray <UIImage*>*)images;

/// Description stop imageView animation
- (void)stopAnimation;

/// Description update subviews.ext: imageView&content
/// - Parameters:
///   - content: content label text
///   - image: imageView's fill image
- (void)updateContent:(NSString *)content image:(UIImage *)image;

/// Description update `self` attributeText
/// - Parameter string: NSAttributedString instance
- (void)updateAttribute:(NSAttributedString *)string;

@end

NS_ASSUME_NONNULL_END
