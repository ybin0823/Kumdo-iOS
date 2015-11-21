//
//  YBFlowContentView.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 2..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBFlowContentViewDelegate <NSObject>

@optional

- (void)contentDidReachMaxLength;

@end

@interface YBFlowContentView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id <YBFlowContentViewDelegate> delegate;
@property (nonatomic) NSUInteger maxLength;

- (void)addTextField;
- (void)addLabelWithText:(NSString *)text;
- (void)removeLastSubview;

@end
