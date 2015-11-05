//
//  BestCollectionViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "BestCollectionViewController.h"
#import "YBCollectionViewCell.h"
#import "DetailViewController.h"
#import "YBWriting.h"

@interface BestCollectionViewController ()

@end

@implementation BestCollectionViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    YBImageManager *imageManager;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_BEST_FROM_SERVER = @"http://125.209.198.90:3000/best?category=-1";

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
    [[defaultSession dataTaskWithURL:[NSURL URLWithString:GET_BEST_FROM_SERVER] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Got response %@ with error %@. \n", response, error);
        
        writings = [[NSMutableArray alloc] init];
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        for (id json in jsonData) {
            @autoreleasepool {
                YBWriting *writing = [YBWriting writingWithJSON:json];
                
                [writings addObject:writing];
            }
        }
        [self performSelectorOnMainThread:@selector(didReceiveData) withObject:nil waitUntilDone:NO];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [mCollectionView reloadData];
//        });
        
    }] resume];
    
    imageManager = [[YBImageManager alloc] init];
    [imageManager setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
    writings = nil;
    imageManager = nil;
}

- (void)didReceiveData
{
    [mCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return writings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[[writings objectAtIndex:indexPath.row] imageUrl]];
    [imageManager loadImageWithURL:imageUrl receiveMainThread:YES withObject:cell];
    
    [cell setSentenceWithAttributedText:writing.sentence];
    [cell.nameLabel setText:writing.name];
    [cell setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell setFormattedDate:writing.date];
    
    return cell;
}

- (void)imageDidLoad:(UIImage *)image withObject:(nullable id)object
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
