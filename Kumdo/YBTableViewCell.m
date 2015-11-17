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
    ContentsView *contentsView;     // image, sentence, words 주요 내용
    SubInfoView *subInfoView;       // name, date. 작성자와 작성날짜
    SubFuncView *subFuncView;       // like, comment, more. 추가 기능
}

@synthesize contentsView = contentsView;
@synthesize subInfoView = subInfoView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        contentsView = [[ContentsView alloc] init];
        subInfoView = [[SubInfoView alloc] init];
        subFuncView = [[SubFuncView alloc] init];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [contentsView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    [self addSubview:contentsView];
    
    [subInfoView setFrame:CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, 30)];
    [self addSubview:subInfoView];
    
    [subFuncView setFrame:CGRectMake(0, self.frame.size.height - 70, self.frame.size.width, 70)];
    [self addSubview:subFuncView];
}

@end
