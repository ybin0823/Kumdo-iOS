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
        defaultSubViewHeight = 30;
        maxLength = 9999;
        currentLength = 0;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"maxLength : %lu", (unsigned long)maxLength);
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
    [self addSubview:textField];
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentLength += textField.text.length;
    [self isMaxLength];
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
    [self addSubview:label];
    
    currentLength += label.text.length;
    [self isMaxLength];
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
