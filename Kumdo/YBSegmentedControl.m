//
//  YBSegmentedControl.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 23..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBSegmentedControl.h"

@implementation YBSegmentedControl
{
    NSInteger selectedSegmentIndex;
    NSArray *titles;
    NSArray *mImages;
    NSUInteger numberOfSegments;
    NSInteger segmentWidth;
    CALayer *indicatorLayer;
    YBSegmentedControlType type;
}


@synthesize type = type;
@synthesize selectedSegmentIndex = selectedSegmentIndex;


- (instancetype)initWithImages:(NSArray *)images
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        mImages = images;
        self.selectedSegmentIndex = 0;
        self.type = YBSegmentedControlTypeImage;
        numberOfSegments = [images count];
        segmentWidth = [[UIScreen mainScreen] bounds].size.width / numberOfSegments;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.type == YBSegmentedControlTypeImage) {
        for (NSInteger index = 0; index < [mImages count]; index++) {
            UIImage *image = [mImages objectAtIndex:index];
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake((segmentWidth * index) + (segmentWidth / 2) - (imageWidth / 2), (self.frame.size.height / 2) - (imageHeight / 2), imageWidth, imageHeight);
            layer.contents = (id)image.CGImage;
            
            if (index == selectedSegmentIndex) {
                indicatorLayer = [CALayer layer];
                indicatorLayer.frame = CGRectMake(segmentWidth * index, self.frame.size.height - 3, segmentWidth, 3);
                [indicatorLayer setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:26.0f/255.0f alpha:1.0f].CGColor];
                [self.layer addSublayer:indicatorLayer];
            }
            [self.layer addSublayer:layer];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [indicatorLayer removeFromSuperlayer];
    
    for (int i = 0; i < numberOfSegments; i++) {
        if (segmentWidth * i < point.x && point.x < segmentWidth * (i + 1)) {
            selectedSegmentIndex = i;
            [self setNeedsDisplay];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

@end
