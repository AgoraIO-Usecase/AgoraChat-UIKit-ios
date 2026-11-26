//
//  AgoraChatTranslateLanguage.h
//  AgoraChat
//
//  Created by lixiaoming on 2022/2/28.
//  Copyright © 2022 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  \
 *  The translate language class
 */
@interface AgoraChatTranslateLanguage : NSObject

/**
 *  \
 *  Language code.
 */
@property (nonatomic,strong) NSString* languageCode;

/**
 *  \
 *  Language name.
 */
@property (nonatomic,strong) NSString* languageName;

/**
 *  \
 *  Language native name.
 */
@property (nonatomic,strong) NSString* languageNativeName;
@end

NS_ASSUME_NONNULL_END
