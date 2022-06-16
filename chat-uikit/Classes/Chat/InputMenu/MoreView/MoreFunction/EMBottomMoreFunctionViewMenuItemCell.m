//
//  EMBottomMoreFunctionViewMenuItemCell.m
//  EaseIMKit
//
//  Created by 冯钊 on 2022/2/22.
//

#import "EMBottomMoreFunctionViewMenuItemCell.h"
#import "EaseExtendMenuModel.h"
#import "UIImage+EaseUI.h"

@interface EMBottomMoreFunctionViewMenuItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation EMBottomMoreFunctionViewMenuItemCell

- (void)setMenuItem:(EaseExtendMenuModel *)menuItem {
    _menuItem = menuItem;
    if (menuItem.showMore == YES) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    _iconImageView.image = menuItem.icon;
    _descLabel.text = menuItem.funcDesc;
    _descLabel.textColor = menuItem.funcDescColor;

}

@end
