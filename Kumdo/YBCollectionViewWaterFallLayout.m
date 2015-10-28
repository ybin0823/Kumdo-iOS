//
//  YBCollectionViewWaterFallLayout.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 23..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBCollectionViewWaterFallLayout.h"


@implementation YBCollectionViewWaterFallLayout
{
    __weak id <YBCollectionViewDelegateWaterFallLayout> delegate;
    NSDictionary *mLayoutInformation;
    UIEdgeInsets sectionInset;
    NSMutableArray *itemPositions; // item position for left column, right column.
}


@synthesize delegate = delegate;


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        sectionInset = UIEdgeInsetsZero;
    }
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];

    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];

    itemPositions = [NSMutableArray array];
    itemPositions[0] = [NSValue valueWithCGPoint:CGPointMake(sectionInset.left, sectionInset.top)]; // 왼쪽 Column의 postion 초기화
    itemPositions[1] = [NSValue valueWithCGPoint:CGPointMake(sectionInset.left, sectionInset.top)]; // 오른쪽 Column의 position 초기화
    
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            // Store cell attributes
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath]; // each cell x, y, width, height
            
            CGPoint itemPosition = [[itemPositions objectAtIndex:(item % 2)] CGPointValue];
            itemPosition.x = itemSize.width * (item % 2); // 오른쪽 column(1)이면 item width만큼 x가 옮겨진다
            
            attributes.frame = CGRectMake(itemPosition.x, itemPosition.y, itemSize.width, itemSize.height);
            [cellInformation setObject:attributes forKey:indexPath];
            
            itemPosition.y += itemSize.height;
            itemPositions[item % 2] = [NSValue valueWithCGPoint:itemPosition];
        }
    }
    [layoutInformation setObject:cellInformation forKey:@"MyCellKind"];
    mLayoutInformation = layoutInformation;
}

- (CGSize)collectionViewContentSize
{
    CGFloat height = 0;
    if ([itemPositions[0] CGPointValue].y > [itemPositions[1] CGPointValue].y) {
        height = [itemPositions[0] CGPointValue].y;
    } else {
        height = [itemPositions[1] CGPointValue].y;
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:[mLayoutInformation count]];
    for (NSString *key in mLayoutInformation) {
        NSDictionary *attributesDict = [mLayoutInformation objectForKey:key];
        for (NSIndexPath *key in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = [attributesDict objectForKey:key];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes];
            }
        }
    }
    return [NSArray arrayWithArray:myAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return mLayoutInformation[@"MyCellKind"][indexPath];
}

@end
