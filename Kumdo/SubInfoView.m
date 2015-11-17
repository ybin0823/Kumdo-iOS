//
//  SubInfoView.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 17..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "SubInfoView.h"
#import "UIColor+YBColorAdditions.h"
#import "YBTimeManager.h"

@implementation SubInfoView
{
    UILabel *nameLabel;
    UILabel *dateLabel;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor navyColor]];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextColor:[UIColor grayColor]];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat margin = 10;
    
    [nameLabel setFrame:CGRectMake(margin, 0, 100, 20)];
    [self addSubview:nameLabel];
    
    [dateLabel setFrame:CGRectMake(width - 150 - margin, 0, 150, 20)];
    [self addSubview:dateLabel];
}

-(void)setNameLabelText:(NSString *)text
{
    [nameLabel setText:text];
}

- (void)setFormattedDate:(NSDate *)date
{
    YBTimeManager *timeManager = [[YBTimeManager alloc] init];
    [dateLabel setText:[timeManager stringWithDate:date]];
}

@end
