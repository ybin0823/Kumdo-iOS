//
//  YBTableViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBTableViewCell.h"
#import "UIColor+YBColorAdditions.h"
#import "YBTimeManager.h"

@implementation YBTableViewCell
{
    ContentsView *contentsView;
    SubInfoView *subInfoView;
}

@synthesize contentsView = contentsView;
@synthesize subInfoView = subInfoView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        contentsView = [[ContentsView alloc] init];
        subInfoView = [[SubInfoView alloc] init];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [contentsView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    [self addSubview:contentsView];
    
    [subInfoView setFrame:CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, 100)];
    [self addSubview:subInfoView];
}

@end
