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

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    __weak UISegmentedControl *mySegmentedControl;
    NSArray *viewControllers;
    NSArray *titles;

}

@synthesize mySegmentedControl = mySegmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];

    [mySegmentedControl addTarget:self
                         action:@selector(action:)
               forControlEvents:UIControlEventValueChanged];
    
    // segment value가 바뀌면 view controller를 바꾼다
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    BestCollectionViewController *bestCollectionViewController = [[BestCollectionViewController alloc] init];
    bestCollectionViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    CategoryViewController *categoryViewController = [[CategoryViewController alloc] init];
    categoryViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    UIViewController *viewController3 = [[UIViewController alloc] init];
    viewController3.view.frame = CGRectMake(0, 110, size.width, size.height);
    [[viewController3 view] setBackgroundColor:[UIColor blueColor]];
    
    viewControllers = [NSArray arrayWithObjects:bestCollectionViewController, categoryViewController, viewController3, nil];
    titles = [NSArray arrayWithObjects:@"홈", @"카테고리", @"내 목록", nil];
    [self displayContent:[viewControllers objectAtIndex:[mySegmentedControl selectedSegmentIndex]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)displayContent:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    self.title = [titles objectAtIndex:[mySegmentedControl selectedSegmentIndex]];
    
    NSLog(@"sub views count is %lu", (unsigned long)[[[self view] subviews] count]);
}

- (void)action:(id)sender
{
    NSLog(@"segment changed!");
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
