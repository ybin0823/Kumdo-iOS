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
#import "Writing.h"

@interface CategoryCollectionViewController ()

@end

@implementation CategoryCollectionViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    NSInteger mCategory;
}

@synthesize mCollectionView = mCollectionView;

static NSString * const reuseIdentifier = @"Cell";

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
    
    [self.mCollectionView registerClass:[YBCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:mCollectionView];
    
    writings = [[NSMutableArray alloc] init];
    
    // Set dummy data start
    NSArray *images = [NSArray arrayWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg", nil];
    NSArray *words = [NSArray arrayWithObjects:@"사과", @"바나나", @"책", @"햇빛", @"바다", @"사랑", @"아름다운", @"여행", nil];
    NSArray *sentences = [NSArray arrayWithObjects:@"이것은 테스트 문장입니다1",
                          @"이것은 테스트 문장입니다2", @"이것은 테스트 문장입니다3",
                          @"이것은 테스트 문장입니다4", @"이것은 테스트 문장입니다5",
                          @"이것은 테스트 문장입니다6", @"이것은 테스트 문장입니다7",
                          @"이것은 테스트 문장입니다8", nil];
    
    NSMutableArray *tempWritings = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        @autoreleasepool {
            Writing *writing = [[Writing alloc] init];
            writing.imageUrl = [images objectAtIndex:i];
            writing.words = [NSArray arrayWithObject:[words objectAtIndex:i]];
            writing.sentence = [sentences objectAtIndex:i];
            writing.name = @"홍길동";
            writing.date = [NSDate date];
            writing.category = i % 4;
            [tempWritings addObject:writing];
        }
    }
    
    for (Writing *writing in tempWritings) {
        if (writing.category == mCategory) {
            [writings addObject:writing];
        }
    }
    NSLog(@"wrtings : %@", writings);
    // Set dummy data end
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
    Writing *writing = [writings objectAtIndex:indexPath.row];
    
    UIImage *scaledImage = [self loadScaledImageAtIndexPath:indexPath];
    [cell.imageView setImage:scaledImage];
    [cell.sentenceLabel setText:writing.sentence];
    [cell.wordsLabel setText:[writing stringWithCommaFromWords]];
    [cell.nameLabel setText:writing.name];
    [cell setFormattedDate:writing.date];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 350);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Writing *writing = [writings objectAtIndex:indexPath.row];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithWriting:writing];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIImage *)loadScaledImageAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageNamed:[[writings objectAtIndex:indexPath.row] imageUrl]];
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
