//
//  DataManager.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DataManager.h"
#define kUserID @"kUserID"
@implementation DataManager

+ (DataManager *)sharedDataManager {
    static dispatch_once_t onceToken;
    static DataManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _selectItemsNum = 7;
        _assistMusicID = 30001;
        
        _aidInfo = [[BleNoxAidInfo alloc] init];
        _aidInfo.aidStopDuration = 1;
        _aidInfo.r = 255;
        _aidInfo.b = 0;
        _aidInfo.w = 0;
        _aidInfo.brightness = 0;
//        _aidInfo.aromaRate = 2;
        _volumn = 0;
        
        _nightLightInfo = [[BleNoxNightLightInfo alloc] init];
        _nightLightInfo.enable = NO;
        _nightLightInfo.brightness = 38;
        
        SLPLight *light = [[SLPLight alloc] init];
        light.r = 255;
        light.g = 35;
        light.b = 0;
        light.w = 0;
        _nightLightInfo.light = light;
        
        _nightLightInfo.startHour = 23;
        _nightLightInfo.startMinute = 0;
        _nightLightInfo.duration = 420;
        
        _alarmList = [NSArray array];
        
        _timeMissionList = [NSArray array];
        
        _customColorList = [NSArray array];
        
//        NSMutableArray *list = [NSMutableArray array];
//        BleNoxTimeMission *info = [[BleNoxTimeMission alloc] init];
//        info.timeID = 0;
//        info.isOpen = YES;
//        info.startHour = 22;
//        info.startMinute = 0;
//        info.endHour = 7;
//        info.startMinute = 0;
//        info.repeat = 1;
//        info.mode = 1;
//
//        SLPLight *light1 = [[SLPLight alloc] init];
//        light1.r = 255;
//        light1.g = 0;
//        light1.b = 0;
//        light1.w = 0;
//        info.light = light1;
//
//        info.brightness = 80;
//        info.musicID = 30001;
//        info.volume = 10;
//        info.valid = 1;
//        [list addObject:info];
//
//        info = [[BleNoxTimeMission alloc] init];
//        info.timeID = 0;
//        info.isOpen = NO;
//        info.startHour = 22;
//        info.startMinute = 0;
//        info.endHour = 7;
//        info.startMinute = 0;
//        info.repeat = 1;
//        info.mode = 0;
//
//        light1 = [[SLPLight alloc] init];
//        light1.r = 255;
//        light1.g = 0;
//        light1.b = 0;
//        light1.w = 0;
//        info.light = light1;
//
//        info.brightness = 80;
//        info.musicID = 30003;
//        info.volume = 10;
//        info.valid = 1;
//        [list addObject:info];
//
//        self.timeMissionList = list;
    }
    
    return self;
}

- (void)reset
{
    _selectItemsNum = 7;
    _assistMusicID = 30001;
    
    _aidInfo.aidStopDuration = 1;
    _aidInfo.r = 255;
    _aidInfo.b = 0;
    _aidInfo.w = 0;
    _aidInfo.brightness = 0;
//    _aidInfo.aromaRate = 2;
    _volumn = 0;
}

- (void)toInit {
    self.peripheral = nil;
    self.deviceName = nil;
    self.deviceID = nil;
    self.inRealtime = NO;
    
}

- (NSString *)userID {
    NSString *userIDString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    return userIDString;
}

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserID];
}
@end
