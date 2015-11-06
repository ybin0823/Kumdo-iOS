//
//  DetailViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    YBWriting *mWriting;
    UIScrollView *scrollView;
    YBImageManager *imageManager;
}

- (instancetype)initWithWriting:(YBWriting *)writing
{
    self = [super init];
    
    if (self) {
        mWriting = writing;
        
        imageManager = [[YBImageManager alloc] init];
        [imageManager setDelegate:self];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setDelegate:self];
    [self.view addSubview:scrollView];

    // Load image from server and add Contents
    [imageManager loadImageWithURL:[mWriting imageUrl] receiveMainThread:YES withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    mWriting = nil;
    scrollView = nil;
    imageManager = nil;
}


#pragma mark - Image manager delegate

- (void)imageDidLoad:(UIImage *)image withObject:(id)object
{
    UIImage *scaledImage = [imageManager scaleImage:image toSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)
                                         isMaintain:YES];
    [self addContents:scaledImage];
}

- (void)addContents:(UIImage *)image
{
    float width = self.view.frame.size.width;
    float height = width;
    CGSize size;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, image.size.width > image.size.height ? height : image.size.height)];

    if (image.size.width > image.size.height) {
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setBackgroundColor:[UIColor blackColor]];
        size.width = width;
        size.height = width;
    } else {
        size.width = width;
        size.height = image.size.height;
    }
    
    [imageView setImage:image];
    
    [scrollView setContentSize:CGSizeMake(image.size.width, image.size.height + 100)];
    [scrollView addSubview:imageView];

    // Add sentence, words label
    [self addSentenceLabelWithFrame:CGRectMake(0, 0, size.width, size.height - 50)];
    [self addWordsLabelWithFrameh:CGRectMake(0, size.height - 50, size.width, 50)];
    
    // 작성자는 Image 왼쪽 아래, 작성날짜는 Image 오른쪽 아래에 표시된다
    [self addNameLabelWithFrame:CGRectMake(0, size.height + 10, 100, 20)];
    [self addDateLabelWithFrame:CGRectMake(width - 150, size.height + 10, 150, 20)];
}


#pragma mark - Add label on the image

- (void)addSentenceLabelWithFrame:(CGRect)frame
{
    UILabel *sentenceLabel = [[UILabel alloc] initWithFrame:frame];
    [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
    [sentenceLabel setTextColor:[UIColor whiteColor]];
    [sentenceLabel setFont:[UIFont systemFontOfSize:22 weight:2]];
    [sentenceLabel setAttributedText:[self attributedString:[mWriting sentence]]];
    [sentenceLabel setNumberOfLines:0];
    
    [scrollView addSubview:sentenceLabel];
}

- (void)addWordsLabelWithFrameh:(CGRect)frame
{
    UILabel *wordsLabel = [[UILabel alloc] initWithFrame:frame];
    [wordsLabel setTextAlignment:NSTextAlignmentCenter];
    [wordsLabel setTextColor:[UIColor whiteColor]];
    [wordsLabel setFont:[UIFont systemFontOfSize:14 weight:2]];
    [wordsLabel setAttributedText:[self attributedString:[mWriting stringWithCommaFromWords]]];
    
    [scrollView addSubview:wordsLabel];
}

- (NSAttributedString *)attributedString:(NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.3]
                             range:NSMakeRange(0, [attributedString length])];
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

#pragma mark - Add label under the image

- (void)addNameLabelWithFrame:(CGRect)frame
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
    [nameLabel setText:[mWriting name]];
    
    [scrollView addSubview:nameLabel];
}

- (void)addDateLabelWithFrame:(CGRect)frame
{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateLabel setText:[dateFormat stringFromDate:[mWriting date]]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    
    [scrollView addSubview:dateLabel];
}


@end
