//
//  YBFlowContentView.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 2..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBFlowContentView : UIView <UITextFieldDelegate>

- (void)addTextField;
- (void)addLabelWithText:(NSString *)text;

@end
