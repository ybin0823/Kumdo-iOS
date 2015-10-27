//
//  YBSegmentedControl.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 23..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, YBSegmentedControlType) {
    YBSegmentedControlTypeText,
    YBSegmentedControlTypeImage,
    YBSegmentedControlTypeTextImage
};

@interface YBSegmentedControl : UIControl

- (instancetype)initWithImages:(NSArray *)images;

@property (nonatomic) YBSegmentedControlType type;

@end
