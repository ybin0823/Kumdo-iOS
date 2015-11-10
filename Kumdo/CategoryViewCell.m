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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        imageView = [[UIImageView alloc] init];
        
        label = [[UILabel alloc] init];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:35]];
        [label setTextAlignment:NSTextAlignmentCenter];
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

- (void)setAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, attributedText.length)];
    [label setAttributedText:attributedText];
}

@end
