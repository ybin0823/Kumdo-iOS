//
//  BestCollectionViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBCollectionViewCell.h"

@implementation YBCollectionViewCell
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Add imageView
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
        [self addSubview:imageView];
        
        // Add sentence
        sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 230)];
        [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
        [sentenceLabel setTextColor:[UIColor whiteColor]];
        [sentenceLabel setFont:[UIFont systemFontOfSize:22 weight:2]];
        [self addSubview:sentenceLabel];
        
        // Add words
        wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, self.frame.size.width, 20)];
        [wordsLabel setTextAlignment:NSTextAlignmentCenter];
        [wordsLabel setTextColor:[UIColor whiteColor]];
        [wordsLabel setFont:[UIFont systemFontOfSize:16 weight:2]];
        [self addSubview:wordsLabel];
        
        // Add name
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 100, 20)];
        [self addSubview:nameLabel];
        
        // Add date
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 150, 250, 150, 20)];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:dateLabel];
    }
    
    return self;
}

- (void)setSentenceWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.3]
                             range:NSMakeRange(0, [attributedString length])];
    [self.sentenceLabel setAttributedText:[[NSAttributedString alloc] initWithAttributedString:attributedString]];
}

- (void)setWordsWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.3]
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
