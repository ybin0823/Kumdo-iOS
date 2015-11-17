//
//  DetailViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "DetailViewController.h"
#import "ContentsView.h"
#import "SubInfoView.h"
#import "SubFuncView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    YBWriting *mWriting;
    UIScrollView *scrollView;
    YBImageManager *imageManager;
    
    ContentsView *contentsView;
    SubInfoView *subInfoView;
    SubFuncView *subFuncView;
}

- (instancetype)initWithWriting:(YBWriting *)writing
{
    self = [super init];
    
    if (self) {
        mWriting = writing;
        
        imageManager = [[YBImageManager alloc] init];
        [imageManager setDelegate:self];
        
        contentsView = [[ContentsView alloc] init];
        subInfoView = [[SubInfoView alloc] init];
        subFuncView = [[SubFuncView alloc] init];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGSize size = [self frameSize];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setDelegate:self];
    [scrollView setContentSize:size];
    [self.view addSubview:scrollView];
    
    [contentsView setFrame:CGRectMake(0, 0, size.width, size.height - 150)];
    [contentsView setSentenceWithAttributedText:[mWriting sentence]];
    [contentsView setWordsWithAttributedText:[mWriting stringWithCommaFromWords]];
    [scrollView addSubview:contentsView];
    
    [subInfoView setFrame:CGRectMake(0, size.height - 150, size.width, 30)];
    [subInfoView setNameLabelText:[mWriting name]];
    [subInfoView setFormattedDate:[mWriting date]];
    [scrollView addSubview:subInfoView];
    
    // 스크롤 시 맨 아래 view가 짤리는 것을 막기 위해 height 50정도 여유를 둔다
    [subFuncView setFrame:CGRectMake(0, size.height - 120, size.width, 70)];
    [scrollView addSubview:subFuncView];

    // Load image from server and add Contents
    [imageManager loadImageWithURL:[mWriting imageUrl] receiveMainThread:YES withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    mWriting = nil;
    scrollView = nil;
    imageManager = nil;
    
    contentsView = nil;
    subInfoView = nil;
    subFuncView = nil;
}

- (CGSize)frameSize
{
    CGFloat width = [[mWriting.imageSize objectAtIndex:0] floatValue];
    CGFloat height = [[mWriting.imageSize objectAtIndex:1] floatValue];
    CGFloat scale = self.view.frame.size.width / width;

    return CGSizeMake(self.view.frame.size.width, height * scale + 150);
}

#pragma mark - Image manager delegate

- (void)didLoadImage:(UIImage *)image withObject:(id)object
{
    UIImage *scaledImage = [imageManager maintainScaleRatioImage:image withWidth:self.view.frame.size.width];
    [contentsView setImage:scaledImage animation:NO];
}

@end
