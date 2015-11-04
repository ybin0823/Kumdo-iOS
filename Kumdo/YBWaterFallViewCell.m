//
//  YBWaterFallViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 4..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBWaterFallViewCell.h"

@implementation YBWaterFallViewCell
{
    UIImageView *imageView;
    UILabel *label;
}

@synthesize imageView = imageView;
@synthesize label = label;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
    }
    
    return self;
}

@end
