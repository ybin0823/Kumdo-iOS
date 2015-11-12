//
//  MenuController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "MenuViewController.h"
#import "CategoryTableViewController.h"
#import "BestTableViewController.h"
#import "MyListViewController.h"
#import "YBSegmentedControl.h"
#import "UIColor+YBColorAdditions.h"


@interface MenuViewController ()

@end

@implementation MenuViewController
{
    YBSegmentedControl *mySegmentedControl;
    NSArray *viewControllers;
}


#pragma mark - Override method#import "BestTableViewController.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setBarTintColor:[UIColor primaryColor]];

    [self setSegmentedControl];
    
    viewControllers = [NSArray arrayWithObjects:[self makeChildViewController:NSStringFromClass(BestTableViewController.class)],
                       [self makeChildViewController:NSStringFromClass(CategoryTableViewController.class)],
                       [self makeChildViewController:NSStringFromClass(MyListViewController.class)], nil];

    [self displayFirstChildViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    mySegmentedControl = nil;
    viewControllers = nil;
}


#pragma mark - Set custom segmented control

- (void)setSegmentedControl
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_home_white_36pt.png"], [UIImage imageNamed:@"ic_list_white_36pt.png"], [UIImage imageNamed:@"ic_collections_white_36pt.png"], nil];
    mySegmentedControl = [[YBSegmentedControl alloc] initWithImages:images];
    
    mySegmentedControl.frame = CGRectMake(0, 0, size.width, 50);
    [mySegmentedControl setBackgroundColor:[UIColor primaryColor]];
    
    [mySegmentedControl addTarget:self action:@selector(didchangeSegmentedIndex) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:mySegmentedControl];
}

- (void)didchangeSegmentedIndex
{
    UIViewController *childeViewController = [viewControllers objectAtIndex:[mySegmentedControl selectedSegmentIndex]];
    [self displayChildViewController:childeViewController];
}


#pragma mark - ChildViewController

- (UIViewController *)makeChildViewController:(NSString *)className
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    UIViewController *childeViewController = [[NSClassFromString(className) alloc] init];
    childeViewController.view.frame = CGRectMake(0, 50, size.width, size.height);
    
    return childeViewController;
}

- (void)displayFirstChildViewController
{
    [self displayChildViewController:[viewControllers objectAtIndex:0]];
}

- (void)displayChildViewController:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    [self setTitle:[viewController title]];
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
