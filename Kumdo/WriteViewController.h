//
//  WriteViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBFlowContentView.h"

@class WriteViewController;

@protocol WriteViewControllerDelegate
- (void)writeViewControllerDidCancel:(WriteViewController *)controller;
@end

@interface WriteViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, YBFlowContentViewDelegate>

@property (nonatomic, weak) id <WriteViewControllerDelegate> delegate;

@end
