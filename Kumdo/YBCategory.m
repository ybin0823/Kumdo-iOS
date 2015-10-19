//
//  Category.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBCategory.h"

@implementation YBCategory
{
    NSArray *images;
    NSArray *names;
}

@synthesize images = images;
@synthesize names = names;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        images = [NSArray arrayWithObjects:@"romance.jpg", @"friend.jpg", @"family.jpg", @"adventure.jpg", nil];
        names = [NSArray arrayWithObjects:@"연애/사랑", @"친구/우정", @"가족", @"모험/여행", nil];
    }
    
    return self;
}

- (NSInteger)count
{
    return 4;
}

@end
