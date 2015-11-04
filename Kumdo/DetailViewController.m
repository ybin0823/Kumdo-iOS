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
    Writing *mWriting;
}

- (instancetype)initWithWriting:(Writing *)writing
{
    self = [super init];
    
    if (self) {
        mWriting = writing;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Image위에 Text, Word가 표시 된다
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    float width = self.view.frame.size.width;
    float height = width;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    // Load image from server
    NSURL *imageUrl = [NSURL URLWithString:[mWriting imageUrl]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    [[defaultSession dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }] resume];

    [self.view addSubview:imageView];
    
    UILabel *sentenceLabel = [self setSentenceLabelWithWidth:width Height:height];
    [self.view addSubview:sentenceLabel];
    
    UILabel *wordsLabel = [self setWordsLabelWithWidth:width Height:height];
    [self.view addSubview:wordsLabel];
    
    // 작성자는 Image 왼쪽 아래, 작성날짜는 Image 오른쪽 아래에 표시된다
    UILabel *nameLabel = [self setNameLabelWithHeight:height];
    [self.view addSubview:nameLabel];
    
    UILabel *dateLabel = [self setDateLabelWithWidth:width Height:height];
    [self.view addSubview:dateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    mWriting = nil;
}

- (UILabel *)setSentenceLabelWithWidth:(float)width Height:(float)height
{
    UILabel *sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height - 50)];
    [sentenceLabel setText:[mWriting sentence]];
    [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
    [sentenceLabel setTextColor:[UIColor whiteColor]];
    [sentenceLabel setFont:[UIFont systemFontOfSize:20 weight:2]];
    
    return sentenceLabel;
}

- (UILabel *)setWordsLabelWithWidth:(float)width Height:(float)height
{
    UILabel *wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 50, width, 50)];
    [wordsLabel setText:[mWriting stringWithCommaFromWords]];
    [wordsLabel setTextAlignment:NSTextAlignmentCenter];
    [wordsLabel setTextColor:[UIColor whiteColor]];
    
    return wordsLabel;
}

- (UILabel *)setNameLabelWithHeight:(float)height
{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, 100, 20)];
    [nameLabel setText:[mWriting name]];
    [self.view addSubview:nameLabel];
    
    return nameLabel;
}

- (UILabel *)setDateLabelWithWidth:(float)width Height:(float)height
{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 150, height + 10, 150, 20)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    [dateLabel setText:[dateFormat stringFromDate:[mWriting date]]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    
    return dateLabel;
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
