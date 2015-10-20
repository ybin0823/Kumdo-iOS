//
//  FlowContentViewController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowContentViewController : UIViewController <UITextFieldDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

- (void)addTextField;
- (void)addLabelWithText:(NSString *)text;

@end
