//
//  HourMinutePicker.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/19.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinishSelectHourMinuteBlock)(NSInteger hour);
typedef void(^CancelSelectHourMinuteBlock)(void);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HourMinutePickerComponent) {
    HourMinutePickerComponent_Hour = 0,
    HourMinutePickerComponent_HourUnit,
    HourMinutePickerComponent_Minute,
    HourMinutePickerComponent_MinuteUnit,
};

@interface HourMinutePicker : UIView

+ (HourMinutePicker *)hourMinutePickerSelectView;

- (void)showInView:(UIView *)view hour:(NSInteger)hour finishHandle:(FinishSelectHourMinuteBlock)finishHandle cancelHandle:(CancelSelectHourMinuteBlock)cancelHandle;

@end

NS_ASSUME_NONNULL_END
