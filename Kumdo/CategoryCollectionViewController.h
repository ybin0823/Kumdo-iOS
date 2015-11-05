//
//  CategoryCollectionViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBImageManager.h"

@interface CategoryCollectionViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, YBImageManagerDelegate>

- (instancetype)initWithCategory:(NSInteger)category;

@end
