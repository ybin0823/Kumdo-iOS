//
//  CategoryTableViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CategoryViewCell.h"
#import "CategoryBestTableViewController.h"
#import "YBCategory.h"
#import "YBImageManager.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerClass:[CategoryViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    categories = nil;
    imageManager = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage *scaledImage = [imageManager scaleImageWithNamed:[categories.images objectAtIndex:indexPath.row]
                                                      toSize:CGSizeMake(self.view.frame.size.width, 200.0)];
    [cell.imageView setImage:scaledImage];
    [cell setAttributedText:[categories.names objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryBestTableViewController *categoryBestViewController = [[CategoryBestTableViewController alloc] initWithCategory:indexPath.row];
    
    [self.navigationController pushViewController:categoryBestViewController animated:YES];
}

@end
