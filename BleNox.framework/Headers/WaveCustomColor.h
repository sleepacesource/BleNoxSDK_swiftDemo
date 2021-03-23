//
//  WaveCustomColor.h
//  BleNox
//
//  Created by jie yang on 2021/3/22.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaveCustomColor : NSObject

@property (nonatomic, assign) UInt8 colorId;//颜色id

@property (nonatomic, strong) SLPLight *light;

@property (nonatomic, assign) UInt8 valid;//是否有效

@end

NS_ASSUME_NONNULL_END
