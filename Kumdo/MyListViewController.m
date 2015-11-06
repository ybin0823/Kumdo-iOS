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

@interface MyListViewController ()

@end

@implementation MyListViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    YBUser *user;
    YBImageManager *imageManager;
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
    }
    
    return self;
}

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    writings = nil;
    imageManager = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [writings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBWaterFallViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withObject:cell];
    
    [cell.label setText:[writing stringWithCommaFromWords]];
    
    return cell;
}

- (void)imageDidLoad:(UIImage *)image withObject:(id)object
{
    YBWaterFallViewCell *cell = object;
    [cell.imageView setImage:[imageManager scaleImage:image toSize:CGSizeMake(self.view.frame.size.width / 2, 0) isMaintain:YES]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Frame Size를 잡기 위해 image를 한 번 받아옴.
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    NSData *data = [NSData dataWithContentsOfURL:[writing imageUrl]];
    UIImage *image = [UIImage imageWithData:data];

    CGFloat scaleFactor = (self.view.frame.size.width / 2) / image.size.width;
    
    return CGSizeMake(self.view.frame.size.width / 2, image.size.height * scaleFactor);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
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
