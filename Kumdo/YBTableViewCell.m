//
//  YBTableViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBTableViewCell.h"
#import "UIColor+YBColorAdditions.h"

@implementation YBTableViewCell
{
    UIImageView *imageView;
    UILabel *sentenceLabel;
    UILabel *wordsLabel;
    UILabel *nameLabel;
    UILabel *dateLabel;
}

@synthesize imageView = imageView;
@synthesize sentenceLabel = sentenceLabel;
@synthesize wordsLabel = wordsLabel;
@synthesize nameLabel = nameLabel;
@synthesize dateLabel = dateLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        imageView = [[UIImageView alloc] init];
        
        sentenceLabel = [[UILabel alloc] init];
        [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
        [sentenceLabel setTextColor:[UIColor whiteColor]];
        [sentenceLabel setFont:[UIFont systemFontOfSize:22 weight:2]];
        
        wordsLabel = [[UILabel alloc] init];
        [wordsLabel setTextAlignment:NSTextAlignmentCenter];
        [wordsLabel setTextColor:[UIColor whiteColor]];
        [wordsLabel setFont:[UIFont systemFontOfSize:16 weight:2]];
        
        nameLabel = [[UILabel alloc] init];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    [self addSubview:imageView];
    
    [sentenceLabel setFrame:CGRectMake(0, 0, self.frame.size.width, 230)];
    [self addSubview:sentenceLabel];
    
    [wordsLabel setFrame:CGRectMake(0, 230, self.frame.size.width, 20)];
    [self addSubview:wordsLabel];
    
    [nameLabel setFrame:CGRectMake(0, 250, 100, 20)];
    [self addSubview:nameLabel];
    
    [dateLabel setFrame:CGRectMake(self.frame.size.width - 150, 250, 150, 20)];
    [self addSubview:dateLabel];
    
    
}

- (void)setSentenceWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor transParentColor]
                             range:NSMakeRange(0, [attributedString length])];
    [self.sentenceLabel setAttributedText:[[NSAttributedString alloc] initWithAttributedString:attributedString]];
}

- (void)setWordsWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor transParentColor]
                             range:NSMakeRange(0, [attributedString length])];
    [self.wordsLabel setAttributedText:[[NSAttributedString alloc] initWithAttributedString:attributedString]];
}

- (void)setFormattedDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    [dateLabel setText:[dateFormat stringFromDate:date]];
}

@end
