//
//  YBCollectionViewWaterFallLayout.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 23..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBCollectionViewDelegateWaterFallLayout <UICollectionViewDelegate>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YBCollectionViewWaterFallLayout : UICollectionViewLayout

@property (nonatomic, weak) id <YBCollectionViewDelegateWaterFallLayout> delegate;

@end
