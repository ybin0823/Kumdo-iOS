//
//  MenuController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController
{
    __weak UISegmentedControl *mySegmentedControl;
    NSArray *viewControllers;

}

@synthesize mySegmentedControl = mySegmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];

    [mySegmentedControl addTarget:self
                         action:@selector(action:)
               forControlEvents:UIControlEventValueChanged];
    
    // segment value가 바뀌면 view controller를 바꾼다
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.frame = CGRectMake(0, 110, size.width, size.height);
    [[viewController view] setBackgroundColor:[UIColor yellowColor]];
    
    UIViewController *viewController2 = [[UIViewController alloc] init];
    viewController2.view.frame = CGRectMake(0, 110, size.width, size.height);
    [[viewController2 view] setBackgroundColor:[UIColor redColor]];
    
    UIViewController *viewController3 = [[UIViewController alloc] init];
    viewController3.view.frame = CGRectMake(0, 110, size.width, size.height);
    [[viewController3 view] setBackgroundColor:[UIColor blueColor]];
    
    viewControllers = [NSArray arrayWithObjects:viewController, viewController2, viewController3, nil];
    
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
    
    NSLog(@"sub views count is %lu", (unsigned long)[[[self view] subviews] count]);
}

- (void)action:(id)sender
{
    NSLog(@"segment changed!");
    [self displayContent:[viewControllers objectAtIndex:[mySegmentedControl selectedSegmentIndex]]];
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
