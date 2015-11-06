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

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.title = @"카테고리";
        
        categories = [[YBCategory alloc] init];
        
        imageManager = [[YBImageManager alloc] init];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up collectionView and register collectionViewCell
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [mCollectionView setBackgroundColor:[UIColor whiteColor]];
    [mCollectionView setDataSource:self];
    [mCollectionView setDelegate:self];
    
    [mCollectionView registerClass:[CategoryViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:mCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    categories = nil;
    imageManager = nil;
}


#pragma mark - CollectionView

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
    
    UIImage *scaledImage = [imageManager scaleImageWithNamed:[categories.images objectAtIndex:indexPath.row]
                                                      toSize:CGSizeMake(self.view.frame.size.width, 250.0)];
    [cell.imageView setImage:scaledImage];
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

@end
