//
//  MyListViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "MyListViewController.h"
#import "DetailViewController.h"
#import "YBWaterFallViewCell.h"
#import "YBWriting.h"
#import "YBUser.h"
#import "YBEmptyView.h"

@interface MyListViewController ()

@end

@implementation MyListViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    YBUser *user;
    YBImageManager *imageManager;
    YBEmptyView *emptyView;
    NSCache *cache;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_MYLIST_FROM_SERVER = @"http://125.209.198.90:3000/mylist/";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.title = @"내 목록";
        
        user = [YBUser sharedInstance];
        
        imageManager = [[YBImageManager alloc] init];
        [imageManager setDelegate:self];
        
        cache = [[NSCache alloc] init];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set collectionView and register cell classes
    YBCollectionViewWaterFallLayout *waterFallLayout = [[YBCollectionViewWaterFallLayout alloc] init];
    [waterFallLayout setDelegate:self];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:waterFallLayout];
    [mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [mCollectionView setDataSource:self];
    [mCollectionView setDelegate:self];
    
    [mCollectionView registerClass:[YBWaterFallViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:mCollectionView];
    
    // Load data from server
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableString *url = [NSMutableString stringWithString:GET_MYLIST_FROM_SERVER];
    [url appendString:[user email]];
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mCollectionView reloadData];
        });
    }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    writings = nil;
    imageManager = nil;
    emptyView = nil;
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBWaterFallViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    if ([cache objectForKey:[writing imageUrl]] != nil) {
        [cell.imageView setImage:[cache objectForKey:[writing imageUrl]]];
    } else {
        [cell setDefaultImage];
        [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withArray:[NSArray arrayWithObjects:cell, writing, nil]];
    }

    [cell.label setText:[writing stringWithCommaFromWords]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - Waterfall layout delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    CGFloat width = [[[writing imageSize] objectAtIndex:0] floatValue];
    CGFloat height = [[[writing imageSize] objectAtIndex:1] floatValue];
    CGFloat scaleFactor = (self.view.frame.size.width / 2) / width;
    
    return CGSizeMake(self.view.frame.size.width / 2, height * scaleFactor);
}


#pragma mark - Image manager delegate

- (void)didLoadImage:(UIImage *)image withArray:(nullable NSArray *)array
{
    YBWaterFallViewCell *cell = [array objectAtIndex:0];
    YBWriting *writing = [array objectAtIndex:1];
    UIImage *resizedImage = [imageManager maintainScaleRatioImage:image withWidth:self.view.frame.size.width / 2];
    
    [cache setObject:resizedImage forKey:[writing imageUrl]];
    
    [cell setImageWithAnimation:resizedImage];
}

@end
