//
//  CategoryViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "CategoryViewCell.h"

@implementation CategoryViewCell
{
    UILabel *label;
    UIImageView *imageView;
}

@synthesize label = label;
@synthesize imageView = imageView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, self.frame.size.height / 2 - 20, 200, 40)];
        imageView = [[UIImageView alloc] initWithImage:nil];
        
        [self addSubview:label];
        [self addSubview:imageView];
    }
    
    return self;
}
@end
