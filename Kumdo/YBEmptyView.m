//
//  YBEmptyView.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBEmptyView.h"
#import "UIColor+YBColorAdditions.h"

@implementation YBEmptyView
{
    UILabel *label;
    UILabel *subLabel;
    UIImageView *imageView;
    UIButton *button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 50, 70, 100, 100)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[UIImage imageNamed:@"Empty_Box"]];
        [self addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, frame.size.width, 50)];
        [label setText:@"데이터가 없습니다"];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:30 weight:2]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        
        subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, frame.size.width, 100)];
        [subLabel setText:@"새로 고침을 하고 싶으시면 아래로 당겨주세요."];
        [subLabel setNumberOfLines:0];
        [subLabel setTextColor:[UIColor grayColor]];
        [subLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:subLabel];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
