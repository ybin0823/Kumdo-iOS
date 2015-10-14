//
//  WriteViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WriteViewController;

@protocol WriteViewControllerDelegate
- (void)writeViewControllerDidCancle:(WriteViewController *)controller;
@end

@interface WriteViewController : UIViewController

@property (weak, nonatomic) id <WriteViewControllerDelegate> delegate;

@end
