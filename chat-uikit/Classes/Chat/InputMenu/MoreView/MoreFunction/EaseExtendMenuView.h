//
//  EaseExtendMenuView.h
//  EaseIM
//
//  Created by zhangchong on 2019/10/23.
//  Copyright © 2019 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageCell.h"
#import "EaseExtendMenuModel.h"
#import "EaseExtendMenuViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ExtType) {
    ExtTypeChatBar = 1, // Input component extension functional areas
    ExtTypeLongPress, //Long press the extension area extension functional
    ExtTypeCustomCellLongPress, // Custom cell long press the functional area
};
@interface EaseExtMenuViewModel : NSObject
@property (nonatomic, assign) CGFloat cellLonger;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger columCount;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, strong) UIColor *iconBgColor;
@property (nonatomic, assign) ExtType type;
- (instancetype)initWithType:(ExtType)type itemCount:(NSInteger)itemCount extendMenuModel:(EaseExtendMenuViewModel*)extendMenuModel;
@end

@protocol EaseMoreFunctionViewDelegate <NSObject>
@optional
- (void)menuExtItemDidSelected:(EaseExtendMenuModel*)menuItemModel extType:(ExtType)extType;
@end

@interface EaseExtendMenuView : UIView
@property (nonatomic, weak) id<EaseMoreFunctionViewDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray<EaseExtendMenuModel*> *extMenuModelArray;
- (instancetype)initWithextMenuModelArray:(NSMutableArray<EaseExtendMenuModel*>*)extMenuModelArray menuViewModel:(EaseExtMenuViewModel*)menuViewModel ;
// View size
- (CGSize)getExtViewSize;
@end


@protocol SessionToolbarCellDelegate <NSObject>
@required
- (void)toolbarCellDidSelected:(EaseExtendMenuModel*)menuItemModel;
@end

@interface SessionToolbarCell : UICollectionViewCell
@property (nonatomic) CGFloat cellLonger;
@property (nonatomic, strong) UIButton *toolBtn;
@property (nonatomic, strong) UILabel *toolLabel;

@property (nonatomic, weak) id<SessionToolbarCellDelegate> delegate;

- (void)setupToolbar;
- (void)personalizeToolbar:(EaseExtendMenuModel*)menuItemModel menuViewMode:(EaseExtMenuViewModel*)menuViewModel;//Personalized toolbar function description
@end

NS_ASSUME_NONNULL_END
