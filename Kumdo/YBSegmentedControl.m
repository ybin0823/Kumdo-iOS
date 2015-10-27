//
//  YBSegmentedControl.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 23..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBSegmentedControl.h"

@interface YBSegmentedControl()

@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *images;
@property (nonatomic, readonly) NSUInteger numberOfSegments;
@property (nonatomic) NSInteger segmentWidth;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic) CALayer *indicatorLayer;

@end

@implementation YBSegmentedControl

- (instancetype)initWithImages:(NSArray *)images
{
    NSLog(@"init");
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _images = images;
        self.selectedSegmentIndex = 0;
        self.type = YBSegmentedControlTypeImage;
        _numberOfSegments = [images count];
        _segmentWidth = [[UIScreen mainScreen] bounds].size.width / _numberOfSegments;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
    [super drawRect:rect];
    
    if (self.type == YBSegmentedControlTypeImage) {
        for (NSInteger index = 0; index < [self.images count]; index++) {
            UIImage *image = [self.images objectAtIndex:index];
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake((_segmentWidth * index) + (_segmentWidth / 2) - (imageWidth / 2), (self.frame.size.height / 2) - (imageHeight / 2), imageWidth, imageHeight);
            layer.contents = (id)image.CGImage;
            
            if (index == _selectedSegmentIndex) {
                _indicatorLayer = [CALayer layer];
                _indicatorLayer.frame = CGRectMake(_segmentWidth * index, self.frame.size.height - 3, _segmentWidth, 3);
                [_indicatorLayer setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:125.0f/255.0f blue:26.0f/255.0f alpha:1.0f].CGColor];
                [self.layer addSublayer:_indicatorLayer];
            }
            [self.layer addSublayer:layer];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [_indicatorLayer removeFromSuperlayer];
    
    for (int i = 0; i < _numberOfSegments; i++) {
        
        if (_segmentWidth * i < point.x && point.x < _segmentWidth * (i + 1)) {
            NSLog(@"%ld", _segmentWidth * i);
            NSLog(@"%ld", _segmentWidth * (i + 1));
            NSLog(@"%f, %f", point.x, point.y);
            NSLog(@"segment index : %d", i);
            
            _selectedSegmentIndex = i;

            NSLog(@"%ld", _selectedSegmentIndex);
            [self setNeedsDisplay];
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    NSLog(@"%f, %f", self.frame.size.width, self.frame.size.height);
}


@end
