//
//  CategoryViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryViewCell.h"
#import "CategoryCollectionViewController.h"
#import "YBCategory.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    UICollectionView *_collectionView;
    YBCategory *categories;
}

@synthesize _collectionView = _collectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up collectionView and register collectionViewCell
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [self._collectionView registerClass:[CategoryViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    // init category
    categories = [[YBCategory alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    categories = nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Set image of imageView in the cell
    UIImage *scaledImage = [self loadScaledImageAtIndexPath:indexPath];
    [cell.imageView setImage:scaledImage];
    
    // Set text of label in the cell
    [cell setAttributedText:[categories.names objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 250);
}

- (UIImage *)loadScaledImageAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageNamed:[categories.images objectAtIndex:indexPath.row]];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewController *categoryCollectionViewController = [[CategoryCollectionViewController alloc] initWithCategory:indexPath.row];
    
    [self.navigationController pushViewController:categoryCollectionViewController animated:YES];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
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
