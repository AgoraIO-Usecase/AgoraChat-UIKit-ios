//
//  EaseChatViewCustomOption.h
//  chat-uikit
//
//  Created by liu001 on 2022/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseChatViewCustomOption : NSObject
+ (EaseChatViewCustomOption *)customOption;

//set custom tableview message cell
@property (nonatomic, strong) UITableViewCell *customMessageCell;
//set custom user join cell
@property (nonatomic, strong) UITableViewCell *customJoinCell;


//set tableView backgroud color
@property (nonatomic, strong) UIColor *tableViewBgColor;
//set right margin of EaseChatView
@property (nonatomic, assign) CGFloat tableViewRightMargin;
//set right margin of EaseChatView
@property (nonatomic, assign) CGFloat tableViewBottomMargin;
//set sendTextButton right margin of EaseChatView
@property (nonatomic, assign) CGFloat sendTextButtonRightMargin;

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


@end

NS_ASSUME_NONNULL_END
