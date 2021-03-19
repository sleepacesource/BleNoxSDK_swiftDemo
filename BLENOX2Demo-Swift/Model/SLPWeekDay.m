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
            weekDayName = NSLocalizedString(@"mon", nil);
            break;
        case WeekDayModeTuesday:
            weekDayName = NSLocalizedString(@"tue", nil);
            break;
        case WeekDayModeWednesday:
            weekDayName = NSLocalizedString(@"wed", nil);
            break;
        case WeekDayModeTursday:
            weekDayName = NSLocalizedString(@"thur", nil);
            break;
        case WeekDayModeFriday:
            weekDayName = NSLocalizedString(@"fri", nil);
            break;
        case WeekDayModeSatarday:
            weekDayName = NSLocalizedString(@"sat", nil);
            break;
        case WeekDayModeSunday:
            weekDayName = NSLocalizedString(@"sun", nil);
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
        repeatDayStr = NSLocalizedString(@"once", nil);
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
