//
//  FlowContentViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "FlowContentViewController.h"

@interface FlowContentViewController ()

@end

@implementation FlowContentViewController
{
    float x;
    float y;
    float marginLeft;
    float marginRight;
    float marginTop;
    float maxWidth;
    float maxHeight;
}

int defaultSubViewWidth = 100;
int defaultSubViewHeight = 50;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        [self.view setFrame:frame];
        maxWidth = self.view.frame.size.width;
        maxHeight = self.view.frame.size.height;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    marginLeft = 10;
    marginRight = 10;
    marginTop = 10;
    x = marginLeft;
    y = marginTop;
    maxWidth = self.view.frame.size.width;
    maxHeight = self.view.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTextField
{
    [self calculateSubViewPosition];

    if (y + defaultSubViewHeight > maxHeight) {
        NSLog(@"You can't add subView : maxHeight!");
        return;
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, defaultSubViewWidth, defaultSubViewHeight)];
    [textField setDelegate:self];
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:textField];
}

- (IBAction) textFieldDidChange: (UITextField*) textField
{
    [textField sizeToFit];
}

- (void)addLabelWithText:(NSString *)text
{
    [self calculateSubViewPosition];
    
    if (y + defaultSubViewHeight > maxHeight) {
        NSLog(@"You can't add subView : maxHeight!");
        return;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, defaultSubViewWidth, defaultSubViewHeight)];
    [label setBackgroundColor:[UIColor whiteColor]];
    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
}

- (void)calculateSubViewPosition
{
    if ([[self.view subviews] count] == 0) {
        return;
    }
    
    UIView *lastSubView = [[self.view subviews] lastObject];
    x += lastSubView.frame.size.width;
    x += marginRight;
    
    if (x + defaultSubViewWidth > maxWidth) {
        x = marginLeft;
        y += defaultSubViewHeight;
        y += marginTop;
    }
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
