//
//  YBTimeManager.m
//  Kumdo
//
//  달력은 그레고리 력을 사용하고, 시간은 UTC로 고려하여 제작
//  현재 시간을 기준으로 연 -> 월 -> 일 -> 시 -> 분 -> 초로 비교하여
//  방금 전 -> ㅁ분 전 -> ㅁ시간 전 -> ㅁ일 전 -> ㅁ웖 ㅁ일 AM(PM)ㅁ:ㅁㅁ -> ㅁㅁㅁㅁ년 ㅁ월 ㅁ일 Am(PM)ㅁ:ㅁㅁ으로 출력
//
//  Created by Jang Young bin on 2015. 11. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBTimeManager.h"
#import "NSCalendar+YBOtherMethod.h"


@implementation YBTimeManager

typedef NS_ENUM(NSInteger, YBDateComparisonResult) {
    YBSecondsAgo = 0L, YBMinutesAgo, YBHoursAgo, YBDaysAgo, YBThisYear, YBLastYear
};

- (NSString *)stringWithDate:(NSDate *)date
{
    NSDate *now = [NSDate date];
   
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *componentsOfDate = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    NSDateComponents *componentsOfNow = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    switch ([self compareDate:now toDate:date]) {
        case YBSecondsAgo:
            return @"방금 전";
            
        case YBMinutesAgo:
            return [NSString stringWithFormat:@"%ld분 전", [componentsOfNow minute] - [componentsOfDate minute]];
            
        case YBHoursAgo:
            // 59분 이하의 차이는 분으로 표시.
            // now의 minute가 date의 minute보다 작으므로 음수가 나오기 때문에 date minute에서 now의 minute을 빼준다
            if ([componentsOfNow minute] - [componentsOfDate minute] < 0) {
                return [NSString stringWithFormat:@"%ld분 전", 60 - ([componentsOfDate minute] - [componentsOfNow minute])];
            }
            
            return [NSString stringWithFormat:@"%ld시간 전", [componentsOfNow hour] - [componentsOfDate hour]];
            
        case YBDaysAgo:
            return [NSString stringWithFormat:@"%ld일 전", [componentsOfNow day] - [componentsOfDate day]];
        case YBThisYear:
            [dateFormat setDateFormat:@"M월 d일 ah:mm"];
            return [dateFormat stringFromDate:date];
            
        case YBLastYear:
            [dateFormat setDateFormat:@"YYYY년 M월 d일 ah:mm"];
            return [dateFormat stringFromDate:date];
            
        default:
            NSLog(@"Error");
            return nil;
    }
}

- (YBDateComparisonResult)compareDate:(NSDate *)date1 toDate:(NSDate *)date2
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    if ([gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitYear] == NSOrderedDescending) {
        return YBLastYear;
    } else if ([gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitMonth] == NSOrderedDescending) {
        return YBThisYear;
    } else if ([gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitDay] == NSOrderedDescending) {
        return YBDaysAgo;
    } else if ([gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitHour] == NSOrderedDescending) {
        return YBHoursAgo;
    } else if ([gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitMinute] == NSOrderedDescending) {
        return YBMinutesAgo;
    } else {
        return YBSecondsAgo;
    }
}
        
@end
