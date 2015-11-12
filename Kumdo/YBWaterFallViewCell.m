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
        imageView = [[UIImageView alloc] init];
        
        label = [[UILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:imageView];
    
    [label setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:label];
}

- (void)setDefaultImage
{
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.imageView setImage:[UIImage imageNamed:@"defaultImage"]];
}

- (void)setImageWithAnimation:(UIImage *)image
{
    [UIView transitionWithView:self.imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.imageView setContentMode:UIViewContentModeScaleToFill];
        [self.imageView setImage:image];
    } completion:nil];
}

@end
