//
//  CategoryCollectionViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "CategoryCollectionViewController.h"
#import "YBCollectionViewCell.h"
#import "DetailViewController.h"
#import "YBWriting.h"

@interface CategoryCollectionViewController ()

@end

@implementation CategoryCollectionViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    NSInteger mCategory;
    YBImageManager *imageManager;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_CATEGORY_BEST_FROM_SERVER = @"http://125.209.198.90:3000/best?category=";

- (instancetype)initWithCategory:(NSInteger)category
{
    self = [super init];
    
    if (self) {
        mCategory = category;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set collectionView and register cell classes
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [mCollectionView setDataSource:self];
    [mCollectionView setDelegate:self];
    
    [mCollectionView registerClass:[YBCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:mCollectionView];
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [mCollectionView reloadData];
        });
    }] resume];
    
    // init imageManger for using image load, image scale
    imageManager = [[YBImageManager alloc] init];
    [imageManager setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    writings = nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return writings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[[writings objectAtIndex:indexPath.row] imageUrl]];
    [imageManager loadImageWithURL:imageUrl receiveMainThread:YES withObject:cell];
    
    [cell setSentenceWithAttributedText:writing.sentence];
    [cell setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell.nameLabel setText:writing.name];
    [cell setFormattedDate:writing.date];
    
    return cell;
}

- (void)imageDidLoad:(UIImage *)image withObject:(id)object
{
    YBCollectionViewCell *cell = object;
    [cell.imageView setImage:[imageManager centerCroppingImage:image toSize:CGSizeMake(self.view.frame.size.width, 250.0)]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 350);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIImage *)centerCropImage:(UIImage *)image toSize:(CGSize)size
{
    float x = (image.size.width - size.width) / 2;
    float y = (image.size.height - size.height) / 2;
    
    CGRect cropRect = CGRectMake(x, y, size.width, size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *ceterCroppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return ceterCroppedImage;
}

- (UIImage *)scaleImage:(UIImage *)image
{
    float resizeWidth = self.view.frame.size.width;
    float resizeHeight = 250.0;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resizeWidth, resizeHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
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
