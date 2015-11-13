//
//  BestTableViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "BestTableViewController.h"
#import "YBTableViewCell.h"
#import "DetailViewController.h"
#import "YBWriting.h"
#import "YBEmptyView.h"

@interface BestTableViewController ()

@end

@implementation BestTableViewController
{
    NSMutableArray *writings;
    YBImageManager *imageManager;
    YBEmptyView *emptyView;
    NSCache *cache;
    
    NSURLSessionConfiguration *defaultSessionConfiguration;
    NSURLSession *defaultSession;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_BEST_FROM_SERVER = @"http://125.209.198.90:3000/best?category=-1";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.title = @"홈";
        
        imageManager = [YBImageManager  sharedInstance];
        [imageManager setDelegate:self];
        
        cache = [[NSCache alloc] init];
        
        defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[YBTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Load data from server
    [[defaultSession dataTaskWithURL:[NSURL URLWithString:GET_BEST_FROM_SERVER] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Got response %@ with error %@. \n", response, error);
        
        writings = [[NSMutableArray alloc] init];
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        for (id json in jsonData) {
            @autoreleasepool {
                YBWriting *writing = [YBWriting writingWithJSON:json];
                
                [writings addObject:writing];
            }
        }
        [self performSelectorOnMainThread:@selector(didReceiveData) withObject:nil waitUntilDone:NO];
    }] resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    writings = nil;
    emptyView = nil;
    defaultSessionConfiguration = nil;
    defaultSession = nil;
}

- (void)didReceiveData
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([writings count] == 0 && emptyView == nil) {
        emptyView = [[YBEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:emptyView];
    }
    
    if ([writings count] > 0) {
        [emptyView removeFromSuperview];
    }
    
    return [writings count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    if ([cache objectForKey:[writing imageUrl]] != nil) {
        [cell.imageView setImage:[cache objectForKey:[writing imageUrl]]];
    } else {
        // Set default image
        [cell setDefaultImage];
        
         //If cache don't have image, then download from remote
        [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withArray:[NSArray arrayWithObjects:cell, writing, nil]];
    }
    
    [cell setSentenceWithAttributedText:writing.sentence];
    [cell.nameLabel setText:writing.name];
    [cell setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell setFormattedDate:writing.date];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 이 부분의 값을 지정해두면 cell을 좀 더 빨리 그릴 수 있어서 성능 상 좋다
    return 350.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    CGFloat width = [[writing.imageSize objectAtIndex:0] floatValue];
    CGFloat height = [[writing.imageSize objectAtIndex:1] floatValue];
    CGFloat scale = self.view.frame.size.width / width;
    
    return height * scale + 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - Image manager Delegate

- (void)didLoadImage:(UIImage *)image withArray:(nullable NSArray *)array
{
    YBTableViewCell *cell = [array objectAtIndex:0];
    YBWriting *writing = [array objectAtIndex:1];
    UIImage *resizedImage = [imageManager maintainScaleRatioImage:image withWidth:self.view.frame.size.width];
    
    [cache setObject:resizedImage forKey:[writing imageUrl]];

    [cell setImageWithAnimation:resizedImage];
}


@end
