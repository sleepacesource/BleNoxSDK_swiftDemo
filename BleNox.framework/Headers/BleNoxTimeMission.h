//
//  BleNoxTimeMission.h
//  SDK
//
//  Created by jie yang on 2021/3/22.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleNoxTimeMission : NSObject

@property (nonatomic, assign) UInt8 timeID;//定时任务编号
@property (nonatomic, assign) BOOL isOpen;//定时任务开关
@property (nonatomic, assign) UInt8 startHour;//开始时间小时
@property (nonatomic, assign) UInt8 startMinute;//开始时间分钟
@property (nonatomic, assign) UInt8 endHour;//结束时间小时
@property (nonatomic, assign) UInt8 endMinute;//结束时间分钟
/*重复
 周1-7 开关(0-6位) 0:关， 1:开
 全0表示单次,设置时间戳作为过期标准
 */
@property (nonatomic, assign) UInt8 repeat;  
@property (nonatomic, assign) UInt8 mode; // 模式  0助眠模式 1照明模式
@property (nonatomic, strong) SLPLight *light;
@property (nonatomic, assign) UInt8 brightness;//亮度 0-100
@property (nonatomic, assign) UInt16 musicID;//音乐ID
@property (nonatomic, assign) UInt8 volume;//音量大小 0-16
@property (nonatomic, assign) UInt8 valid;//0表示该任务已经删除 1该任务有效

@end

NS_ASSUME_NONNULL_END
