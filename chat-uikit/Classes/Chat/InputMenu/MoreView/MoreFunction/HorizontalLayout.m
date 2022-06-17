//
//  HorizontalLayout.m
//  EaseIM
//
//  Created by zhangchong on 2020/5/7.
//  Copyright © 2020 zhangchong. All rights reserved.
//

#import "HorizontalLayout.h"

@interface HorizontalLayout()
{
    CGFloat _xOffset;
    CGFloat _yOffset;
}

@property (nonatomic,strong) NSMutableArray *attrs;
@property (nonatomic,strong) NSMutableDictionary *pageDict;

@end

@implementation HorizontalLayout

#pragma mark - life cycle
- (instancetype)initWithOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xOffset = xOffset;
        _yOffset = yOffset;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < items; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrs addObject:attr];
        }
    }
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self resetItemLocation:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrs;
}

- (CGSize)collectionViewContentSize {
   
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += [self.pageDict[page] integerValue];
    }
    CGFloat width = allPagesCount * self.collectionView.bounds.size.width;
    CGFloat hegith = self.collectionView.bounds.size.height;
    return CGSizeMake(width, hegith);
}

#pragma mark - private method

- (void)resetItemLocation:(UICollectionViewLayoutAttributes *)attr {
    if(attr.representedElementKind != nil) {
        return;
    }
    
    CGFloat itemW = self.itemSize.width;
    CGFloat itemH = self.itemSize.height;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:attr.indexPath.section];
    
    CGFloat width = self.collectionView.bounds.size.width;
    
    
    NSInteger index = attr.indexPath.item;
    
    NSInteger allCount = self.rowCount * self.columCount;
    if (self.itemCountSum > 0) {
        allCount = self.itemCountSum;
    }
   
    NSInteger page = index / allCount;
    
    NSInteger xIndex = index % self.rowCount;
    NSInteger yIndex = (index - page * allCount)/self.rowCount;
    
    CGFloat xOffset = xIndex * (itemW) + _xOffset*(xIndex+1);
    CGFloat yOffset = yIndex * (itemH) + _yOffset*(yIndex+1);
    
    NSInteger sectionPage = (itemCount % allCount == 0) ? itemCount/allCount : (itemCount/allCount + 1);
   
    [self.pageDict setObject:@(sectionPage) forKey:[NSString stringWithFormat:@"%lu",attr.indexPath.section]];
    
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += [self.pageDict[page] integerValue];
    }
    
    NSInteger lastIndex = self.pageDict.allKeys.count - 1;
    allPagesCount -= [self.pageDict[[NSString stringWithFormat:@"%lu",lastIndex]] integerValue];
    xOffset += page * width + allPagesCount * width;
    
    attr.frame = CGRectMake(xOffset, yOffset, itemW, itemH);
}
#pragma mark - getter and setter
- (NSMutableArray *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

- (NSMutableDictionary *)pageDict {
    if (!_pageDict) {
        _pageDict = [NSMutableDictionary dictionary];
    }
    return _pageDict;
}
@end
