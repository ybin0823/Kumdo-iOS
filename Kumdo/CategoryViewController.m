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
#import "YBImageManager.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    UICollectionView *mCollectionView;
    YBCategory *categories;
    YBImageManager *imageManager;
}

@synthesize mCollectionView = mCollectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up collectionView and register collectionViewCell
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [mCollectionView setDataSource:self];
    [mCollectionView setDelegate:self];
    
    [self.mCollectionView registerClass:[CategoryViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:mCollectionView];
    
    // init category
    categories = [[YBCategory alloc] init];
    
    // init imageManger for using image scale.
    imageManager = [[YBImageManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    categories = nil;
    imageManager = nil;
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
    UIImage *scaledImage = [imageManager scaleImageWithNamed:[categories.images objectAtIndex:indexPath.row]
                                                      toSize:CGSizeMake(self.view.frame.size.width, 250.0)];
    [cell.imageView setImage:scaledImage];
    
    // Set text of label in the cell
    [cell setAttributedText:[categories.names objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 250);
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
