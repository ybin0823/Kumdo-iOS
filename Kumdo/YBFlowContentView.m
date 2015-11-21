//
//  YBFlowContentView.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 2..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBFlowContentView.h"

@implementation YBFlowContentView
{
    float x;
    float y;
    float marginLeft;
    float marginRight;
    float marginTop;
    float maxWidth;
    float maxHeight;
    int defaultSubViewWidth;
    int defaultSubViewHeight;
    NSUInteger maxLength;
    NSUInteger currentLength;
    __weak id <YBFlowContentViewDelegate> delegate;
}

@synthesize maxLength = maxLength;
@synthesize delegate = delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        maxWidth = self.frame.size.width;
        maxHeight = self.frame.size.height;
        marginLeft = 10;
        marginRight = 10;
        marginTop = 10;
        x = marginLeft;
        y = marginTop;
        defaultSubViewWidth = 80;
        defaultSubViewHeight = 20;
        maxLength = 9999;
        currentLength = 0;
    }
    
    return self;
}


#pragma mark - Add textField

- (void)addTextField
{
    [self calculateSubViewPosition];
    
    if (y + defaultSubViewHeight > maxHeight) {
        NSLog(@"You can't add subView : maxHeight!");
        return;
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, defaultSubViewWidth, defaultSubViewHeight)];
    [textField setDelegate:self];
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [textField setTextColor:[UIColor whiteColor]];
    [textField becomeFirstResponder];
    
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setReturnKeyType:UIReturnKeyDone];
    
    [self addSubview:textField];
}

- (IBAction)textFieldEditingChanged:(UITextField*) textField
{
    // 글자가 수 대로 textField size변경
    [textField sizeToFit];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (x + textField.frame.size.width + marginRight > maxWidth) {
        [textField deleteBackward];
        [self addTextField];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentLength += textField.text.length;
    [self isMaxLength];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark - Add label

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
    [self addSubview:label];
    
    currentLength += label.text.length;
    [self isMaxLength];
}

#pragma mark - Calculate Subview Position

- (void)calculateSubViewPosition
{
    if ([[self subviews] count] == 0) {
        return;
    }
    
    UIView *lastSubView = [[self subviews] lastObject];
    x += lastSubView.frame.size.width;
    x += marginRight;

    if (x + defaultSubViewWidth > maxWidth) {
        x = marginLeft;
        y += defaultSubViewHeight;
        y += marginTop;
    }
}

- (BOOL)isMaxLength
{
    if (currentLength >= maxLength) {
        [self.delegate contentDidReachMaxLength];
        return YES;
    }
    
    return NO;
}

- (void)removeLastSubview
{
    UIView *willRemoveSubview = [[self subviews] lastObject];
    
    if ([willRemoveSubview isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)willRemoveSubview;
        currentLength -= label.text.length;
    } else if ([willRemoveSubview isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)willRemoveSubview;
        currentLength -= textField.text.length;
    }
    
    [willRemoveSubview removeFromSuperview];
    
    UIView *lastSubview = [[self subviews] lastObject];
    x = lastSubview.frame.origin.x;
    y = lastSubview.frame.origin.y;
    
    if (lastSubview == nil) {
        x = marginLeft;
        y = marginTop;
    }
}

@end
