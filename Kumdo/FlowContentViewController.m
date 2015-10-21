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

int defaultSubViewWidth = 80;
int defaultSubViewHeight = 30;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        [self.view setFrame:frame];
        maxWidth = self.view.frame.size.width;
        maxHeight = self.view.frame.size.height;
        marginLeft = 10;
        marginRight = 10;
        marginTop = 10;
        x = marginLeft;
        y = marginTop;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [textField setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [textField setTextColor:[UIColor whiteColor]];
    [self.view addSubview:textField];
}

- (IBAction) textFieldDidChange: (UITextField*) textField
{
    [textField sizeToFit];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (x + textField.frame.size.width + marginRight > maxWidth) {
        [textField deleteBackward];
        return NO;
    }
    
    return YES;
}

- (void)addLabelWithText:(NSString *)text
{
    [self calculateSubViewPosition];
    
    if (y + defaultSubViewHeight > maxHeight) {
        NSLog(@"You can't add subView : maxHeight!");
        return;
    }
    
    // label의 width는 한 글자당 20으로 계산하여 글자 수만큼 늘리도록 한다
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, text.length * 20, defaultSubViewHeight)];
    [label setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [label setTextColor:[UIColor whiteColor]];
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
