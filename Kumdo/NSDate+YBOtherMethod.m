//
//  NSDate+YBOtherMethod.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "NSDate+YBOtherMethod.h"

@implementation NSDate (YBOtherMethod)

+ (instancetype)dateWithTimeIntervalSince1970MiliSecond:(NSTimeInterval)secs
{
    return [self dateWithTimeIntervalSince1970:secs / 1000];
}

@end
