//
//  SubFuncView.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 17..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "SubFuncView.h"

@implementation SubFuncView
{
    UIButton *likeButton;
    UILabel *likeCount;
    
    UIButton *commentButton;
    UILabel *commentCount;
    
    UIButton *moreButton;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        likeButton = [[UIButton alloc] init];
        likeCount = [[UILabel alloc] init];
        
        commentButton = [[UIButton alloc] init];
        commentCount = [[UILabel alloc] init];
        
        moreButton = [[UIButton alloc] init];
    }

    return self;
}

- (void)layoutSubviews
{
    [likeButton setFrame:CGRectMake(10, 0, 32, 32)];
    [likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self addSubview:likeButton];
    
    [likeCount setFrame:CGRectMake(45, 0, 32, 32)];
    [likeCount setText:@"0"];
    [self addSubview:likeCount];
    
    [commentButton setFrame:CGRectMake(80, 0, 32, 32)];
    [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self addSubview:commentButton];
    
    [commentCount setFrame:CGRectMake(115, 0, 32, 32)];
    [commentCount setText:@"0"];
    [self addSubview:commentCount];
    
    [moreButton setFrame:CGRectMake(self.frame.size.width - 45, 0, 32, 32)];
    [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self addSubview:moreButton];
}

@end
