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
        _aidInfo.g = 35;
        _aidInfo.b = 0;
        _aidInfo.w = 0;
        _aidInfo.brightness = 30;
        _aidInfo.volume = 6;
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

        
        //
        
        _lightR = 155;
        _lightG = 32;
        _lightB = 93;
        _lightW = 255;
        _lightBR = 100;
    }
    
    return self;
}

- (void)reset
{
    _selectItemsNum = 7;
    _assistMusicID = 30001;
    
    _aidInfo.aidStopDuration = 1;
    _aidInfo.r = 255;
    _aidInfo.g = 35;
    _aidInfo.b = 0;
    _aidInfo.w = 0;
    _aidInfo.brightness = 30;
//    _aidInfo.aromaRate = 2;
    _aidInfo.volume = 6;
    
    _playMode = 0;
    
    _lightR = 155;
    _lightG = 32;
    _lightB = 93;
    _lightW = 255;
    _lightBR = 100;
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
