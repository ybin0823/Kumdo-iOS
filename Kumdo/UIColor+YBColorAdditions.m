//
//  UIColor+YBColorAdditions.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 5..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "UIColor+YBColorAdditions.h"

@implementation UIColor (YBColorAdditions)

+ (UIColor *)primaryColor
{
    return [UIColor colorWithRed:26.0f/255.0f green:179.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)transParentColor
{
    return [UIColor colorWithWhite:0.5f alpha:0.5f];
}

+ (UIColor *)navyColor
{
    return [UIColor colorWithRed:0.0f green:0.0f blue:102.0f/255.0f alpha:1.0f];
}
@end
