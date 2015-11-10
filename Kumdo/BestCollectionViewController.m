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
#import "YBEmptyView.h"

@interface BestCollectionViewController ()

@end

@implementation BestCollectionViewController
{
    UICollectionView *mCollectionView;
    NSMutableArray *writings;
    YBImageManager *imageManager;
    YBEmptyView *emptyView;
}

static NSString * const reuseIdentifier = @"Cell";
static NSString * const GET_BEST_FROM_SERVER = @"http://125.209.198.90:3000/best?category=-1";

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.title = @"홈";
        
        imageManager = [[YBImageManager alloc] init];
        [imageManager setDelegate:self];
    }
    
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad
{
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
        
        // TODO perforSelectorOnMainThread와 비교해보기
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [mCollectionView reloadData];
        //        });
        
    }] resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
    writings = nil;
    imageManager = nil;
    emptyView = nil;
}

- (void)didReceiveData
{
    [mCollectionView reloadData];
}


#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([writings count] == 0) {
        emptyView = [[YBEmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [emptyView setBackgroundColor:[UIColor yellowColor]];
        [self.view addSubview:emptyView];
    } else {
        if (emptyView) {
            [emptyView setHidden:YES];
        }
    }
    
    return writings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    YBWriting *writing = [writings objectAtIndex:indexPath.row];
    
    [imageManager loadImageWithURL:[writing imageUrl] receiveMainThread:YES withObject:cell];
    
    [cell setSentenceWithAttributedText:writing.sentence];
    [cell.nameLabel setText:writing.name];
    [cell setWordsWithAttributedText:[writing stringWithCommaFromWords]];
    [cell setFormattedDate:writing.date];
    
    return cell;
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


#pragma mark - Image manager Delegate

- (void)didLoadImage:(UIImage *)image withObject:(nullable id)object
{
    YBCollectionViewCell *cell = object;
    [cell.imageView setImage:[imageManager centerCroppingImage:image toSize:CGSizeMake(self.view.frame.size.width, 250.0)]];
}


@end
