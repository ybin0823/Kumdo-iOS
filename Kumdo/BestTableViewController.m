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
#import "YBCacheManager.h"

@interface BestTableViewController ()

@end

@implementation BestTableViewController
{
    NSMutableArray *writings;
    YBImageManager *imageManager;
    YBEmptyView *emptyView;

    YBCacheManager *cacheManager;
    
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
        
        imageManager = [[YBImageManager  alloc] init];
        [imageManager setDelegate:self];
        
        cacheManager = [YBCacheManager sharedInstance];
        
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
    imageManager = nil;
    emptyView = nil;
    defaultSessionConfiguration = nil;
    defaultSession = nil;
    [[cacheManager cache] removeAllObjects];
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
    
    if ([[cacheManager cache] objectForKey:[writing imageUrl]] != nil) {
        UIImage *image = [[cacheManager cache] objectForKey:[writing imageUrl]];
        [cell.contentsView setImage:image animation:NO];
    } else {
        // Set default image
        [cell.contentsView setDefaultImage];
        
         //If cache don't have image, then download from remote
        [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withArray:[NSArray arrayWithObjects:cell, writing, nil]];
    }
    
    [cell.contentsView setSentenceWithAttributedText:writing.sentence];
    [cell.contentsView setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell.subInfoView setNameLabelText:writing.name];
    [cell.subInfoView setFormattedDate:writing.date];
    
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
    
    [[cacheManager cache] setObject:resizedImage forKey:[writing imageUrl]];
    
    [cell.contentsView setImage:resizedImage animation:YES];
}


@end
