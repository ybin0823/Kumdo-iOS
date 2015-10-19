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
    Writing *_writing;
}

- (instancetype)initWithWriting:(Writing *)writing
{
    self = [super init];
    
    if (self) {
        _writing = writing;
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
    [imageView setImage:[UIImage imageNamed:[_writing imageUrl]]];
    [self.view addSubview:imageView];
    
    UILabel *sentenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height - 50)];
    [sentenceLabel setText:[_writing sentence]];
    [sentenceLabel setTextAlignment:NSTextAlignmentCenter];
    [sentenceLabel setTextColor:[UIColor whiteColor]];
    [sentenceLabel setFont:[UIFont systemFontOfSize:20 weight:2]];
    [self.view addSubview:sentenceLabel];
    
    UILabel *wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 50, width, 50)];
    [wordsLabel setText:[_writing words]];
    [wordsLabel setTextAlignment:NSTextAlignmentCenter];
    [wordsLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:wordsLabel];
    
    // 작성자는 Image 왼쪽 아래, 작성날짜는 Image 오른쪽 아래에 표시된다
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height + 10, 100, 20)];
    [nameLabel setText:[_writing name]];
    [nameLabel setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 100, height + 10, 100, 20)];
    NSString *date = [NSString stringWithFormat:@"%@", [_writing date]];
    [dateLabel setText:date];
    [dateLabel setBackgroundColor:[UIColor orangeColor]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:dateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _writing = nil;
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
