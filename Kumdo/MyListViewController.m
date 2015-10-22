//
//  MyListViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "MyListViewController.h"
#import "Writing.h"

@interface MyListViewController ()

@end

@implementation MyListViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *writings;
}

@synthesize _collectionView = _collectionView;

static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set collectionView and register cell classes
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [self._collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    writings = [[NSMutableArray alloc] init];
    
    // Set dummy data start
    NSArray *images = [NSArray arrayWithObjects:@"iu.jpg", @"iu2.jpg", @"boyoung.jpg", @"boyoung2.jpg", @"boyoung3.jpg", nil];
    NSArray *words = [NSArray arrayWithObjects:@"사과", @"바나나", @"책", @"햇빛", @"바다", nil];
    NSArray *sentences = [NSArray arrayWithObjects:@"이것은 테스트 문장입니다1",
                          @"이것은 테스트 문장입니다2", @"이것은 테스트 문장입니다3",
                          @"이것은 테스트 문장입니다4", @"이것은 테스트 문장입니다5", nil];
    
    for (int i = 0; i < 5; i++) {
        @autoreleasepool {
            Writing *writing = [[Writing alloc] init];
            writing.imageUrl = [images objectAtIndex:i];
            writing.words = [NSArray arrayWithObject:[words objectAtIndex:i]];
            writing.sentence = [sentences objectAtIndex:i];
            writing.name = @"홍길동";
            writing.date = [NSDate date];
            writing.category = i % 4;
            [writings addObject:writing];
        }
    }
    
    NSLog(@"wrtings : %@", writings);
    // Set dummy data end

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    Writing *writing = [writings objectAtIndex:indexPath.row];
    NSLog(@"%@", indexPath);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self loadScaledImageAtIndexPath:indexPath resizeWidth:(self.view.frame.size.width / 2)]];
    [cell addSubview:imageView];
    [cell setBackgroundColor:[UIColor yellowColor]];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Writing *writing = [writings objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageNamed:[writing imageUrl]];
    float originWidth = image.size.width;
    float frameWidth = self.view.frame.size.width / 2;
    float scaleFactor = frameWidth / originWidth;
    
    float frameHeight = image.size.height * scaleFactor;
    
    return CGSizeMake(frameWidth, frameHeight);
}

- (UIImage *)loadScaledImageAtIndexPath:(NSIndexPath *)indexPath resizeWidth:(float)width
{
    UIImage *image = [UIImage imageNamed:[[writings objectAtIndex:indexPath.row] imageUrl]];
    float originWidth = image.size.width;
    float resizeWidth = width;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
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
