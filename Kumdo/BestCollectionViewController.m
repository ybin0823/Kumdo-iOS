//
//  BestCollectionViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "BestCollectionViewController.h"
#import "BestCollectionViewCell.h"

@interface BestCollectionViewController ()

@end

@implementation BestCollectionViewController
{
    NSArray *images;
    UICollectionView *_collectionView;
}

@synthesize _collectionView = _collectionView;

static NSString * const reuseIdentifier = @"Cell";

//- (instancetype)init{
//    self = [super init];
//    
//    if (self) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        
//        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
//        [_collectionView setDataSource:self];
//        [_collectionView setDelegate:self];
//        
//        [self.view addSubview:_collectionView];
//    }
//    
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view.
    
    // Register cell classes
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [self._collectionView registerClass:[BestCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    images = [NSArray arrayWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg", nil];
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
    return images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForItem");
    BestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImage *image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    float resizeWidth = self.view.frame.size.width;
    float resizeHeight = 250.0;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resizeWidth, resizeHeight), NO, [UIScreen mainScreen].scale);
    NSLog(@"mainScreen scale : %lf", [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:scaledImage];
    
    [cell addSubview:imageView];
    cell.backgroundColor = [UIColor whiteColor];
    
    /*
     UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
     imageView.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
     UILabel *label = (UILabel *)[cell viewWithTag:200];
     label.text = [NSString stringWithString:[texts objectAtIndex:indexPath.row]];
     cell.backgroundColor = [UIColor whiteColor]; */
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 250);
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
