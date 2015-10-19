//
//  BestCollectionViewCell.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "BestCollectionViewCell.h"

@implementation BestCollectionViewCell
{
    UIImageView *imageView;
    UILabel *sentenceLabel;
    UILabel *wordsLabel;
}

@synthesize imageView = imageView;
@synthesize sentenceLabel = sentenceLabel;
@synthesize wordsLabel = wordsLabel;

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
        [sentenceLabel setFont:[UIFont systemFontOfSize:20 weight:2]];
        [self addSubview:sentenceLabel];
        
        // Add words
        wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, self.frame.size.width, 20)];
        [wordsLabel setTextAlignment:NSTextAlignmentCenter];
        [wordsLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:wordsLabel];
    }
    
    return self;
}
@end
