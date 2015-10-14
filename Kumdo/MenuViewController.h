//
//  MenuController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteViewController.h"

@interface MenuViewController : UIViewController <WriteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@end
