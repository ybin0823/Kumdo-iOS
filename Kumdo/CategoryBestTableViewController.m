//
//  CategoryBestTableViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "CategoryBestTableViewController.h"
#import "YBTableViewCell.h"
#import "DetailViewController.h"
#import "YBCategory.h"
#import "YBWriting.h"
#import "YBEmptyView.h"

@interface CategoryBestTableViewController ()

@end

@implementation CategoryBestTableViewController
{
    NSMutableArray *writings;
    NSInteger mCategory;
    YBImageManager *imageManager;
    YBEmptyView *emptyView;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_CATEGORY_BEST_FROM_SERVER = @"http://125.209.198.90:3000/best?category=";

- (instancetype)initWithCategory:(NSInteger)category
{
    self = [super init];
    
    if (self) {
        mCategory = category;
        
        imageManager = [[YBImageManager alloc] init];
        [imageManager setDelegate:self];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[YBTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    // Load data from server
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableString *url = [NSMutableString stringWithString:GET_CATEGORY_BEST_FROM_SERVER];
    [url appendFormat:@"%ld", (long)mCategory];
    
    [[defaultSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
    return [writings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withObject:cell];
    
    [cell setSentenceWithAttributedText:writing.sentence];
    [cell.nameLabel setText:writing.name];
    [cell setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell setFormattedDate:writing.date];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350.0f;
}


#pragma mark - Image manager Delegate

- (void)didLoadImage:(UIImage *)image withObject:(nullable id)object
{
    YBTableViewCell *cell = object;
    [cell.imageView setImage:[imageManager centerCroppingImage:image toSize:CGSizeMake(self.view.frame.size.width, 250.0)]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
