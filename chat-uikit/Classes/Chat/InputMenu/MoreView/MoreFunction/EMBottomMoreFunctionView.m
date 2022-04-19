//
//  EMBottomMoreFunctionView.m
//  EaseIMKit
//
//  Created by 冯钊 on 2022/2/22.
//

#import "EMBottomMoreFunctionView.h"
#import "EMBottomMoreFunctionViewEmojiCell.h"
#import "EMBottomMoreFunctionViewMenuItemCell.h"
#import "EaseExtendMenuModel.h"

typedef struct PanData {
    CGFloat beiginY;
    CGFloat beiginBottom;
    CGFloat step[3];
    uint8_t currentStep;
} PanData;

@interface EMBottomMoreFunctionView () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *emojiCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiCollectionBottomSpaceConstraint;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *bgMaskLayer;

@property (nonatomic, strong) NSArray <NSString *>*emojiDataList;
@property (nonatomic, strong) NSArray <EaseExtendMenuModel *>*menuItems;
@property (nonatomic, strong) NSArray <UIBezierPath *>*bgMaskPaths;


@property (nonatomic, strong) void(^didSelectedMenuItem)(EaseExtendMenuModel *);
@property (nonatomic, strong) void(^didSelectedEmoji)(NSString *);

@property (nonatomic, assign) EMBottomMoreFunctionType contentType;

@property (nonatomic, assign) BOOL isShowEmojiList;

@property (nonatomic, assign) PanData panData;

@end

@implementation EMBottomMoreFunctionView

static EMBottomMoreFunctionView *shareView;

+ (instancetype)share {
    if (!shareView) {
        shareView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].firstObject;
    }
    return shareView;
}

+ (void)showMenuItems:(NSArray <EaseExtendMenuModel *>*)menuItems
          contentType:(EMBottomMoreFunctionType)type
            animation:(BOOL)animation
  didSelectedMenuItem:(nonnull void (^)(EaseExtendMenuModel * _Nonnull))didSelectedMenuItem
     didSelectedEmoji:(nonnull void (^)(NSString * _Nonnull))didSelectedEmoji {
    [self showMenuItems:menuItems contentType:type animation:animation maskPaths:nil didSelectedMenuItem:didSelectedMenuItem didSelectedEmoji:didSelectedEmoji];
}

+ (void)showMenuItems:(NSArray <EaseExtendMenuModel *>*)menuItems
          contentType:(EMBottomMoreFunctionType)type
            animation:(BOOL)animation
            maskPaths:(NSArray<UIBezierPath *> *)maskPaths
  didSelectedMenuItem:(void(^)(EaseExtendMenuModel *menuItem))didSelectedMenuItem
     didSelectedEmoji:(void(^)(NSString *emoji))didSelectedEmoji {

    EMBottomMoreFunctionView *shareView = EMBottomMoreFunctionView.share;
    shareView.contentType = type;
    [UIApplication.sharedApplication.keyWindow addSubview:shareView];
    shareView.frame = UIApplication.sharedApplication.keyWindow.bounds;
    shareView.menuItems = menuItems;
    shareView.didSelectedEmoji = didSelectedEmoji;
    shareView.didSelectedMenuItem = didSelectedMenuItem;
    shareView.bgView.alpha = 1;
    shareView.isShowEmojiList = NO;
    [shareView.itemTableView reloadData];
    shareView.emojiCollectionView.hidden = (type == EMBottomMoreFunctionTypeChat);
    if (type != EMBottomMoreFunctionTypeChat) {
        [shareView.emojiCollectionView reloadData];
    }
    
    shareView.itemTableView.scrollEnabled = NO;
    shareView.itemTableView.allowsMultipleSelection = NO;
    shareView.emojiCollectionViewHeightConstraint.constant = (type == EMBottomMoreFunctionTypeChat ? 0:30);
    shareView.emojiCollectionBottomSpaceConstraint.constant = (type == EMBottomMoreFunctionTypeChat ? -15:12);
    shareView.itemTableViewHeightConstraint.constant = 54 * menuItems.count;
    shareView.bgView.alpha = 0;
    
    shareView.bgMaskPaths = maskPaths;
    if (maskPaths.count > 0) {
        if (!shareView.bgMaskLayer) {
            shareView.bgMaskLayer = [CAShapeLayer layer];
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 1000, 1000)];
        for (UIBezierPath *item in maskPaths) {
            [path appendPath:[item bezierPathByReversingPath]];
        }
        shareView.bgMaskLayer.path = path.CGPath;
        shareView.bgView.layer.mask = shareView.bgMaskLayer;
    } else {
        shareView.bgView.layer.mask = nil;
    }
    
    if (animation) {
        [shareView layoutIfNeeded];
        shareView.contentViewBottomConstraint.constant = -shareView.mainView.bounds.size.height;
        [shareView layoutIfNeeded];
        if (type == EMBottomMoreFunctionTypeMessage && menuItems.count > 3) {
            shareView.contentViewBottomConstraint.constant = -54 * (CGFloat)(menuItems.count - 3) - EMBottomMoreFunctionView.share.bottomContainerHeightConstraint.constant;
        } else {
            shareView.contentViewBottomConstraint.constant = 0;
        }
        [UIView animateWithDuration:0.25 animations:^{
            [shareView layoutIfNeeded];
            shareView.bgView.alpha = 1;
        } completion:^(BOOL finished) {
            [shareView resetPanData];
        }];
    } else {
        shareView.bgView.alpha = 1;
        shareView.contentViewBottomConstraint.constant = -350 - shareView.bottomContainerHeightConstraint.constant;
        [shareView layoutIfNeeded];
        [shareView resetPanData];
    }
}

+ (void)hideWithAnimation:(BOOL)animation needClear:(BOOL)needClear {
    void(^clearFunc)(void) = ^{
        [shareView removeFromSuperview];
        if (needClear) {
            shareView = nil;
        }
    };
    if (animation) {
        shareView.contentViewBottomConstraint.constant = -shareView.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            [shareView layoutIfNeeded];
            shareView.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            clearFunc();
        }];
    } else {
        clearFunc();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        _bottomContainerHeightConstraint.constant = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    
    _emojiDataList = @[@"ee_40", @"ee_43", @"ee_37", @"ee_36", @"ee_15", @"ee_10", @"add_reaction"];
    CGFloat spacing = (UIScreen.mainScreen.bounds.size.width - 40 - _emojiDataList.count * 30) / (_emojiDataList.count - 1);
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_emojiCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(30, 30);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [_emojiCollectionView registerNib:[UINib nibWithNibName:@"EMBottomMoreFunctionViewEmojiCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [_itemTableView registerNib:[UINib nibWithNibName:@"EMBottomMoreFunctionViewMenuItemCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    CGFloat radius = 24;
    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_mainView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    _shapeLayer = [[CAShapeLayer alloc] init];
    _shapeLayer.frame = _mainView.bounds;
    _shapeLayer.path = path.CGPath;
    _mainView.layer.mask = _shapeLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _shapeLayer.frame = _mainView.bounds;
    _bgMaskLayer.frame = self.bounds;
}

- (void)resetPanData {
    _panData.step[0] = 0;
    if (_menuItems.count > 3) {
        _panData.step[1] = (_menuItems.count - 3) * 54 + shareView.bottomContainerHeightConstraint.constant;
    } else {
        _panData.step[1] = 0;
    }
    _panData.step[2] = shareView.mainView.bounds.size.height;
}

- (void)switchEmojiListView {
    CGFloat spacing = (UIScreen.mainScreen.bounds.size.width - 24 - _emojiDataList.count * 30) / (_emojiDataList.count - 1);

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_emojiCollectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(30, 30);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [_emojiCollectionView setCollectionViewLayout:layout animated:YES];
    
    _isShowEmojiList = YES;
    [_emojiCollectionView reloadData];
    
    _emojiCollectionViewHeightConstraint.constant = 344;
    self.contentViewBottomConstraint.constant -= 344 - 36 - self.itemTableViewHeightConstraint.constant;
    _itemTableViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.panData.step[2] = self.mainView.bounds.size.height;
    }];
}

- (IBAction)onBgViewTap:(UITapGestureRecognizer *)sender {
    [EMBottomMoreFunctionView hideWithAnimation:YES needClear:NO];
}

- (IBAction)onContentViewPan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _panData.beiginY = [sender locationInView:self].y;
        _panData.beiginBottom = _contentViewBottomConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        CGFloat currentY = [sender locationInView:self].y;
        CGFloat offset = currentY - _panData.beiginY;
        CGFloat newBottom = _panData.beiginBottom - offset;
        if (newBottom > 0) {
            newBottom = 0;
        }

        CGFloat minDistance = 0;
        int index = -1;
        for (int i = 0; i < 3; i ++) {
            CGFloat distance = fabs(_panData.step[i] + newBottom);
            if (index < 0 || minDistance > distance) {
                index = i;
                minDistance = distance;
            }
        }
        _panData.currentStep = index;
        _contentViewBottomConstraint.constant = -_panData.step[index];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            if (index == 2) {
                self.bgView.alpha = 0;
            } else {
                self.bgView.alpha = 1;
            }
        } completion:^(BOOL finished) {
            if (index == 2) {
                [self removeFromSuperview];
            }
            self.itemTableView.scrollEnabled = index == 0 && self.panData.step[1] != 0;
        }];
    } else {
        CGFloat currentY = [sender locationInView:self].y;
        CGFloat offset = currentY - _panData.beiginY;
        CGFloat newBottom = _panData.beiginBottom - offset;
        if (newBottom > -_panData.step[0]) {
            newBottom = -_panData.step[0];
        } else if (newBottom < -_panData.step[2]) {
            newBottom = -_panData.step[2];
        }
        _contentViewBottomConstraint.constant = newBottom;
        if (-newBottom >= _panData.step[1] && -newBottom <= _panData.step[2]) {
            _bgView.alpha = 1 - ((-newBottom - _panData.step[1]) / (_panData.step[2] - _panData.step[1]));
        } else {
            _bgView.alpha = 1;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isShowEmojiList) {
        return 49;
    } else {
        return _emojiDataList.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EMBottomMoreFunctionViewEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (_isShowEmojiList) {
        cell.imageName = [NSString stringWithFormat:@"ee_%ld", (long)indexPath.item + 1];
    } else {
        cell.imageName = _emojiDataList[indexPath.item];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectedEmoji) {
        if (_isShowEmojiList) {
            _didSelectedEmoji([NSString stringWithFormat:@"ee_%ld", (long)indexPath.item + 1]);
        } else {
            if (indexPath.item < _emojiDataList.count - 1) {
                _didSelectedEmoji(_emojiDataList[indexPath.item]);
            } else {
                [self switchEmojiListView];
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMBottomMoreFunctionViewMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.menuItem = _menuItems[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_didSelectedMenuItem) {
        _didSelectedMenuItem(_menuItems[indexPath.row]);
    }
}

@end
