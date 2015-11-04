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
}

@synthesize mCollectionView = mCollectionView;

static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set collectionView and register cell classes
    YBCollectionViewWaterFallLayout *waterFallLayout = [[YBCollectionViewWaterFallLayout alloc] init];
    [waterFallLayout setDelegate:self];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:waterFallLayout];
    [mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [mCollectionView setDataSource:self];
    [mCollectionView setDelegate:self];
    
    [self.mCollectionView registerClass:[YBWaterFallViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:mCollectionView];
    
    // Load user info
    user = [YBUser sharedInstance];
    
    // Load data from server
    
    NSMutableString *url = [NSMutableString stringWithString:@"http://125.209.198.90:3000/mylist/"];
    [url appendString:[user email]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    [[defaultSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Got response %@ with error %@. \n", response, error);
        
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        writings = [[NSMutableArray alloc] init];
        for (id json in jsonData) {
            @autoreleasepool {
                YBWriting *writing = [YBWriting writingWithJSON:json];
                NSLog(@"mylist : %@", [writing description]);
                
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
    NSURL *imageUrl = [NSURL URLWithString:[writing imageUrl]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
    [[defaultSession dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:[self scaleImage:image]];
        });
    }] resume];
    
    [cell.label setText:[writing stringWithCommaFromWords]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *imageUrl = [NSURL URLWithString:[[writings objectAtIndex:indexPath.row] imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:data];
    
    float originWidth = image.size.width;
    float frameWidth = self.view.frame.size.width / 2;
    float scaleFactor = frameWidth / originWidth;
    
    float frameHeight = image.size.height * scaleFactor;
    
    return CGSizeMake(frameWidth, frameHeight);
}

- (UIImage *)scaleImage:(UIImage *)image
{
    float originWidth = image.size.width;
    float resizeWidth = self.view.frame.size.width / 2;
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
