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
    
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100)];
    [self addSubview:imageView];
    
    [sentenceLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 120)];
    [self addSubview:sentenceLabel];
    
    [wordsLabel setFrame:CGRectMake(0, self.frame.size.height - 120, self.frame.size.width, 20)];
    [self addSubview:wordsLabel];
    
    [nameLabel setFrame:CGRectMake(10, self.frame.size.height - 100, 100, 20)];
    [self addSubview:nameLabel];
    
    [dateLabel setFrame:CGRectMake(self.frame.size.width - 160, self.frame.size.height - 100, 150, 20)];
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
    YBTimeManager *timeManager = [[YBTimeManager alloc] init];
    [dateLabel setText:[timeManager stringWithDate:date]];
}

- (void)setDefaultImage
{
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.imageView setImage:[UIImage imageNamed:@"defaultImage"]];
}

- (void)setImageWithAnimation:(UIImage *)image
{
    [UIView transitionWithView:self.imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.imageView setContentMode:UIViewContentModeScaleToFill];
        [self.imageView setImage:image];
    } completion:nil];
}

@end
