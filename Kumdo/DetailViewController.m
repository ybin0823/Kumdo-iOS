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
}

- (instancetype)initWithWriting:(YBWriting *)writing
{
    self = [super init];
    
    if (self) {
        mWriting = writing;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    float width = self.view.frame.size.width;
    float height = width;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setDelegate:self];
    [self.view addSubview:scrollView];
    
    // Load image from server and add Contents
    [self loadImageFrom:[NSURL URLWithString:[mWriting imageUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    mWriting = nil;
}

- (void)loadImageFrom:(NSURL *)url
{
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        [self performSelectorOnMainThread:@selector(addContents:) withObject:image waitUntilDone:NO];
 
    }] resume];
}

- (void)addContents:(UIImage *)image
{
    float width = self.view.frame.size.width;
    float height = width;
    
    UIImage *scaledImage = [self scaleImage:image];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.width > scaledImage.size.height ? scaledImage.size.width : scaledImage.size.height)];
    if ( scaledImage.size.width > scaledImage.size.height) {
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [imageView setImage:scaledImage];
    
    [scrollView setContentSize:CGSizeMake(scaledImage.size.width, scaledImage.size.height + 100)];
    [scrollView addSubview:imageView];

    [imageView setBackgroundColor:[UIColor blackColor]];
    // Add sentence, words label
    [self addSentenceLabelWithWidth:width Height:scaledImage.size.width > scaledImage.size.height ? scaledImage.size.width : scaledImage.size.height];
    [self addWordsLabelWithWidth:width Height:scaledImage.size.width > scaledImage.size.height ? scaledImage.size.width : scaledImage.size.height];
    
    // 작성자는 Image 왼쪽 아래, 작성날짜는 Image 오른쪽 아래에 표시된다
    [self addNameLabelWithHeight:scaledImage.size.width > scaledImage.size.height ? scaledImage.size.width : scaledImage.size.height];
    [self addDateLabelWithWidth:width Height:scaledImage.size.width > scaledImage.size.height ? scaledImage.size.width : scaledImage.size.height];
}

- (void)addSentenceLabelWithWidth:(float)width Height:(float)height
{
    UILabel *sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height - 50)];
    [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
    [sentenceLabel setTextColor:[UIColor whiteColor]];
    [sentenceLabel setFont:[UIFont systemFontOfSize:22 weight:2]];
    [sentenceLabel setAttributedText:[self attributedString:[mWriting sentence]]];
    [sentenceLabel setNumberOfLines:0];
    
    [scrollView addSubview:sentenceLabel];
}

- (void)addWordsLabelWithWidth:(float)width Height:(float)height
{
    NSLog(@"%lf", height);
    UILabel *wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 50, width, 50)];
    [wordsLabel setTextAlignment:NSTextAlignmentCenter];
    [wordsLabel setTextColor:[UIColor whiteColor]];
    [wordsLabel setFont:[UIFont systemFontOfSize:14 weight:2]];
    [wordsLabel setAttributedText:[self attributedString:[mWriting stringWithCommaFromWords]]];
    
    [scrollView addSubview:wordsLabel];
}

- (void)addNameLabelWithHeight:(float)height
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, 100, 20)];
    [nameLabel setText:[mWriting name]];
    
    [scrollView addSubview:nameLabel];
}

- (void)addDateLabelWithWidth:(float)width Height:(float)height
{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 150, height + 10, 150, 20)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateLabel setText:[dateFormat stringFromDate:[mWriting date]]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    
    [scrollView addSubview:dateLabel];
}

- (NSAttributedString *)attributedString:(NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:0.3]
                             range:NSMakeRange(0, [attributedString length])];
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedString];
}

- (UIImage *)scaleImage:(UIImage *)image
{
    float originWidth = image.size.width;
    float resizeWidth = self.view.frame.size.width;
    float scaleFactor = resizeWidth / originWidth;
    float resizeHeight = image.size.height * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resizeWidth, resizeHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
