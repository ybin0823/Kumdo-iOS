//
//  NSCalendar+YBOtherMethod.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "NSCalendar+YBOtherMethod.h"

@implementation NSCalendar (YBOtherMethod)

- (NSInteger) daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate
{
    NSCalendarUnit units = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components1 = [self components:units fromDate:startDate];
    NSDateComponents *components2 = [self components:units fromDate:endDate];
    [components1 setHour:12];
    [components2 setHour:12];
    
    NSDate *date1 = [self dateFromComponents:components1];
    NSDate *date2 = [self dateFromComponents:components2];
    
    return [[self components:NSCalendarUnitDay fromDate:date1 toDate:date2 options:0] day];
}

@end
