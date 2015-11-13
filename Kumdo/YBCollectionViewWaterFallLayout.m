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
    CGFloat minimumInteritemSpacing;
    CGFloat minimumLineSpacing;
}


@synthesize delegate = delegate;
@synthesize minimumInteritemSpacing;
@synthesize minimumLineSpacing;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        sectionInset = UIEdgeInsetsZero;
        minimumInteritemSpacing = 1.5f;
        minimumLineSpacing = 3.0f;
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
            
            /* 
             * 가로 이미지의 경우 오론쪽 이미지는 interitemSpacing만큼 옮겨진 다음, 왼쪽 이미지, 오른쪽 이미지가 interitemSpaing 만큼 width가 줄어든다.
             * 따라서 interitemSpacing은 lineSpacing의 1/2이어야 같은 크기만큼 spacing이 생긴다
             */
            if (item % 2 == 1) {
               itemPosition.x = itemSize.width * (item % 2) + minimumInteritemSpacing; // 오른쪽 column(1)이면 item width + interitemSpacing 만큼 x가 옮겨진다
            } else {
                itemPosition.x = itemSize.width * (item % 2); // 왼쪽 column(0)이면 item width만큼 x가 옮겨진다
            }
            
            attributes.frame = CGRectMake(itemPosition.x, itemPosition.y, itemSize.width - minimumInteritemSpacing, itemSize.height);
            [cellInformation setObject:attributes forKey:indexPath];
            
            itemPosition.y += itemSize.height + minimumLineSpacing;
            itemPositions[item % 2] = [NSValue valueWithCGPoint:itemPosition];
        }
    }
    [layoutInformation setObject:cellInformation forKey:@"MyCellKind"];
    mLayoutInformation = layoutInformation;
}

- (CGSize)collectionViewContentSize
{
    CGFloat height = 0;
    
    // 맨 아래까지 스크롤 시 마지막 이미지가 짤리지 않도록 height를 120만큼 더 준다
    if ([itemPositions[0] CGPointValue].y > [itemPositions[1] CGPointValue].y) {
        height = [itemPositions[0] CGPointValue].y + 120;
    } else {
        height = [itemPositions[1] CGPointValue].y + 120;
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
