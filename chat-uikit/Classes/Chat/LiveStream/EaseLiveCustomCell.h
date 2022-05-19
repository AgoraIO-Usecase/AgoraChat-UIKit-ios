//
//  EaseLiveCustomCell.h
//  chat-uikit
//
//  Created by liu001 on 2022/5/12.
//

#import <UIKit/UIKit.h>
#import "EaseHeaders.h"

#define EaseAvatarHeight 32.0f


NS_ASSUME_NONNULL_BEGIN

@interface EaseLiveCustomCell : UITableViewCell

@property (nonatomic, copy) void (^tapCellBlock)(void);
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UIView* bottomLine;
@property (nonatomic, strong, readonly)UITapGestureRecognizer *tapGestureRecognizer;


//set cell contentview backgroud color
@property (nonatomic, strong) UIColor *cellBgColor;
//set whether display avatarImageView
@property (nonatomic, assign) BOOL    isShowAvatar;
//set nameLabel text font size
@property (nonatomic, assign) CGFloat nameLabelFontSize;
//set nameLabel text color
@property (nonatomic, strong) UIColor *nameLabelColor;
//set messageLabel font size
@property (nonatomic, assign) CGFloat messageLabelSize;
//set messageLabel text color
@property (nonatomic, strong) UIColor *messageLabelColor;


+ (NSString *)reuseIdentifier;
+ (CGFloat)height;
- (void)prepare;
- (void)placeSubViews;
- (void)updateWithObj:(id)obj;

// fetch userInfo update cell with userId
- (void)fetchUserInfoWithUserId:(NSString *)userId;



@end

NS_ASSUME_NONNULL_END

