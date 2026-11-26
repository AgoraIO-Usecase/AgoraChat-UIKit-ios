//
//  AgoraChatUserInfo.h
//  libHyphenateSDK.a
//
//  Created by lixiaoming on 2021/3/17.
//  Copyright © 2021 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  \
 *  The user information type.
 */
typedef NS_ENUM(NSInteger, AgoraChatUserInfoType) {
    AgoraChatUserInfoTypeNickName = 0, /** \ The user nickname. */
    AgoraChatUserInfoTypeAvatarURL,    /** \ The user avatar address.*/
    AgoraChatUserInfoTypePhone,        /** \ The user contact. */
    AgoraChatUserInfoTypeMail,         /** \ The user email address. */
    AgoraChatUserInfoTypeGender,       /** \ The user gender. */
    AgoraChatUserInfoTypeSign,         /** \ The user signature. */
    AgoraChatUserInfoTypeBirth,        /** \ The user birthday. */
    AgoraChatUserInfoTypeExt = 100,    /** \ The extension field. */
};
/**
 *  \
 *  The userInfo class.
 */
@interface AgoraChatUserInfo : NSObject<NSCopying>

/**
 *  \ The user ID.
 */
@property (nonatomic,copy) NSString * _Nullable userId;

/**
 *  \ The user's nickname.
 */
@property (nonatomic,copy) NSString * _Nullable nickname;

/**
 *  \ The user's avatar file uri.
 */
@property (nonatomic,copy) NSString * _Nullable avatarUrl;

/**
 *  \ The user's mail address.
 */
@property (nonatomic,copy) NSString * _Nullable mail;

/**
 *  \ The user's phone number.
 */
@property (nonatomic,copy) NSString * _Nullable phone;

/**
 *  \ The user's gender. If you didn't set, the default value is 0.  For example you can set 1 for male and 2 for female.
 */
@property (nonatomic) NSInteger gender;

/**
 *  \ The user's personal status.
 */
@property (nonatomic,copy) NSString* _Nullable sign;

/**
 *  \ The user's birth date.
 */
@property (nonatomic,copy) NSString* _Nullable birth;

/**
 *  \ The extention information.
 */
@property (nonatomic,copy) NSString * _Nullable ext;

@end
