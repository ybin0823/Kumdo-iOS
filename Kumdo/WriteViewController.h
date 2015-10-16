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
- (void)writeViewControllerDidCancel:(WriteViewController *)controller;
@end

@interface WriteViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id <WriteViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;

@property (weak, nonatomic) IBOutlet UIButton *changePictureButton;

@end
