//
//  MenuController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "MenuViewController.h"
#import "BestCollectionViewController.h"
#import "CategoryViewController.h"
#import "MyListViewController.h"
#import "YBSegmentedControl.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    YBSegmentedControl *mySegmentedControl;
    NSArray *viewControllers;
    NSArray *titles;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[self.navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:26.0f/255.0f green:179.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];

    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    // Set custome segmented control
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_home_white_36pt.png"], [UIImage imageNamed:@"ic_list_white_36pt.png"], [UIImage imageNamed:@"ic_collections_white_36pt.png"], nil];
    mySegmentedControl = [[YBSegmentedControl alloc] initWithImages:images];
    mySegmentedControl.frame = CGRectMake(0, 0, size.width, 50);
    [mySegmentedControl setBackgroundColor:[UIColor colorWithRed:26.0f/255.0f green:179.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [mySegmentedControl addTarget:self action:@selector(selectSegmentItem) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySegmentedControl];

    
    // Set view controllers
    BestCollectionViewController *bestCollectionViewController = [[BestCollectionViewController alloc] init];
    bestCollectionViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    categoryViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    MyListViewController *myListViewController = [[MyListViewController alloc] init];
    myListViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    viewControllers = [NSArray arrayWithObjects:bestCollectionViewController, categoryViewController, myListViewController, nil];
    [self displayContent:[viewControllers objectAtIndex:[mySegmentedControl selectedSegmentIndex]]];
    
    // Set view controller titles
    titles = [NSArray arrayWithObjects:@"홈", @"카테고리", @"내 목록", nil];
    self.title = [titles objectAtIndex:[mySegmentedControl selectedSegmentIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    mySegmentedControl = nil;
    viewControllers = nil;
    titles = nil;
}

//TODO method name 더 적합한 것이 없는지 고민해볼 것
- (void)displayContent:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    self.title = [titles objectAtIndex:[mySegmentedControl selectedSegmentIndex]];
}

- (void)selectSegmentItem
{
    [self displayContent:[viewControllers objectAtIndex:[mySegmentedControl selectedSegmentIndex]]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqualToString:@"LoadWrite"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        WriteViewController *writeViewController = [[navigationController viewControllers] objectAtIndex:0];
        writeViewController.delegate = self;
    }
}

- (void)writeViewControllerDidCancel:(WriteViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
