//
//  MyListViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBCollectionViewWaterFallLayout.h"

@interface MyListViewController : UIViewController <UICollectionViewDataSource, YBCollectionViewDelegateWaterFallLayout>

@property (strong, nonatomic) UICollectionView *mCollectionView;

@end
