//
//  SLPWeekDay.m
//  Sleepace
//
//  Created by Shawley on 01/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPWeekDay.h"

@implementation SLPWeekDay

+ (NSString *)getNameWithIndex:(WeekDayMode)index {
    NSString *weekDayName = @"";
    switch (index) {
        case WeekDayModeMonday:
            weekDayName = @"周一";
            break;
        case WeekDayModeTuesday:
            weekDayName = @"周二";
            break;
        case WeekDayModeWednesday:
            weekDayName = @"周三";
            break;
        case WeekDayModeTursday:
            weekDayName = @"周四";
            break;
        case WeekDayModeFriday:
            weekDayName = @"周五";
            break;
        case WeekDayModeSatarday:
            weekDayName = @"周六";
            break;
        case WeekDayModeSunday:
            weekDayName = @"周日";
            break;
        default:
            break;
    }
    return weekDayName;
}

+ (NSString *)getAlarmRepeatDayStringWithWeekDay:(UInt8)weekDay {
    NSString *repeatDayStr = @"";
    UInt8 weekDayNumber = weekDay;
    
    for (int i = 0; i < 7; i++) {
        UInt8 repeatDay = 1 << i;
        BOOL isRepeat = repeatDay & weekDayNumber;
        if (isRepeat) {
            NSString *dayStr = [SLPWeekDay getNameWithIndex:i];
            dayStr = [dayStr stringByAppendingString:@"、"];
            repeatDayStr = [repeatDayStr stringByAppendingString:dayStr];
        }
    }
    if (repeatDayStr.length) {
        repeatDayStr = [repeatDayStr substringToIndex:repeatDayStr.length - 1];
    } else {
        repeatDayStr = @"仅一次";
    }
    return repeatDayStr;
}

+ (NSArray *)getRepeatDays:(UInt8)weekday {
    NSMutableArray *repeatDaysArr = [NSMutableArray array];
    NSInteger repeatDays = weekday;
    for (int i = 0; i < 7; i++) {
        NSInteger offset = 0x01 << i;
        BOOL isSelected = repeatDays & offset;
        [repeatDaysArr addObject:@(isSelected)];
    }
    return [repeatDaysArr copy];
}

@end
