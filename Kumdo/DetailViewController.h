//
//  DetailViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBWriting.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate>

- (instancetype)initWithWriting:(YBWriting *)writing;

@end
