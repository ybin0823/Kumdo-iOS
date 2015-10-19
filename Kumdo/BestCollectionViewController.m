//
//  BestCollectionViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "BestCollectionViewController.h"
#import "BestCollectionViewCell.h"
#import "DetailViewController.h"
#import "Writing.h"

@interface BestCollectionViewController ()

@end

@implementation BestCollectionViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *writings;
}

@synthesize _collectionView = _collectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set collectionView and register cell classes
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [self._collectionView registerClass:[BestCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    writings = [[NSMutableArray alloc] init];
    
    // Set dummy data start
    NSArray *images = [NSArray arrayWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg", nil];
    NSArray *words = [NSArray arrayWithObjects:@"사과", @"바나나", @"책", @"햇빛", @"바다", @"사랑", @"아름다운", @"여행", nil];
    NSArray *sentences = [NSArray arrayWithObjects:@"이것은 테스트 문장입니다1",
                          @"이것은 테스트 문장입니다2", @"이것은 테스트 문장입니다3",
                          @"이것은 테스트 문장입니다4", @"이것은 테스트 문장입니다5",
                          @"이것은 테스트 문장입니다6", @"이것은 테스트 문장입니다7",
                          @"이것은 테스트 문장입니다8", nil];
    
    for (int i = 0; i < 8; i++) {
        @autoreleasepool {
            Writing *writing = [[Writing alloc] init];
            writing.imageUrl = [images objectAtIndex:i];
            writing.words = [words objectAtIndex:i];
            writing.sentence = [sentences objectAtIndex:i];
            
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
    BestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Writing *writing = [writings objectAtIndex:indexPath.row];
    
    UIImage *scaledImage = [self loadScaledImageAtIndexPath:indexPath];
    [cell.imageView setImage:scaledImage];
    [cell.sentenceLabel setText:writing.sentence];
    [cell.wordsLabel setText:writing.words];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 250);
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
