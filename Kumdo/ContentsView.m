//
//  ContentsView.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 17..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "ContentsView.h"
#import "UIColor+YBColorAdditions.h"

@implementation ContentsView
{
    UIImageView *imageView;
    UILabel *sentenceLabel;
    UILabel *wordsLabel;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        imageView = [[UIImageView alloc] init];
        
        sentenceLabel = [[UILabel alloc] init];
        [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
        [sentenceLabel setTextColor:[UIColor whiteColor]];
        [sentenceLabel setFont:[UIFont systemFontOfSize:22 weight:2]];
        
        wordsLabel = [[UILabel alloc] init];
        [wordsLabel setTextAlignment:NSTextAlignmentCenter];
        [wordsLabel setTextColor:[UIColor whiteColor]];
        [wordsLabel setFont:[UIFont systemFontOfSize:16 weight:2]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    [imageView setFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:imageView];
    
    [sentenceLabel setFrame:CGRectMake(0, 0, width, height - 20)];
    [self addSubview:sentenceLabel];
    
    [wordsLabel setFrame:CGRectMake(0, height - 20, width, 20)];
    [self addSubview:wordsLabel];
}

- (void)setSentenceWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor transParentColor]
                             range:NSMakeRange(0, [attributedString length])];
    [sentenceLabel setAttributedText:[[NSAttributedString alloc] initWithAttributedString:attributedString]];
}

- (void)setWordsWithAttributedText:(NSString *)text
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor transParentColor]
                             range:NSMakeRange(0, [attributedString length])];
    [wordsLabel setAttributedText:[[NSAttributedString alloc] initWithAttributedString:attributedString]];
}

- (void)setDefaultImage
{
    [imageView setContentMode:UIViewContentModeCenter];
    [imageView setImage:[UIImage imageNamed:@"defaultImage"]];
}

- (void)setImage:(UIImage *)image animation:(BOOL)isAnimation
{
    if (isAnimation) {
        [UIView transitionWithView:imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setImage:image];
        } completion:nil];
    } else {
        [imageView setImage:image];
    }
}

@end
