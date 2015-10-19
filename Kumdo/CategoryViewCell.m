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
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imageView setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:35]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:label];
    }
    
    return self;
}

- (void)setAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, attributedText.length)];
    [label setAttributedText:attributedText];
}

@end
