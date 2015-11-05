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
    
    // Load image from server and add Contents
    [self loadImageFrom:[NSURL URLWithString:[mWriting imageUrl]]];

    // 작성자는 Image 왼쪽 아래, 작성날짜는 Image 오른쪽 아래에 표시된다
    [self addNameLabelWithHeight:height];
    [self addDateLabelWithWidth:width Height:height];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    // Add sentence, words label
    [self addSentenceLabelWithWidth:width Height:height];
    [self addWordsLabelWithWidth:width Height:height];
}

- (void)addSentenceLabelWithWidth:(float)width Height:(float)height
{
    UILabel *sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height - 50)];
    [sentenceLabel setText:[mWriting sentence]];
    [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
    [sentenceLabel setTextColor:[UIColor whiteColor]];
    [sentenceLabel setFont:[UIFont systemFontOfSize:20 weight:2]];
    
    [self.view addSubview:sentenceLabel];
}

- (void)addWordsLabelWithWidth:(float)width Height:(float)height
{
    UILabel *wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 50, width, 50)];
    [wordsLabel setText:[mWriting stringWithCommaFromWords]];
    [wordsLabel setTextAlignment:NSTextAlignmentCenter];
    [wordsLabel setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:wordsLabel];
}

- (void)addNameLabelWithHeight:(float)height
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, 100, 20)];
    [nameLabel setText:[mWriting name]];
    
    [self.view addSubview:nameLabel];
}

- (void)addDateLabelWithWidth:(float)width Height:(float)height
{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 150, height + 10, 150, 20)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateLabel setText:[dateFormat stringFromDate:[mWriting date]]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.view addSubview:dateLabel];
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
