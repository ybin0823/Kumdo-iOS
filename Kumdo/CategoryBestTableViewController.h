//
//  CategoryBestTableViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBImageManager.h"

@interface CategoryBestTableViewController : UITableViewController <YBImageManagerDelegate>

- (instancetype)initWithCategory:(NSInteger)category;

@end
