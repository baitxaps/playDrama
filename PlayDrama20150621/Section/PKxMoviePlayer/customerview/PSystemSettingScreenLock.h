//
//  PSystemSettingScreenLock.h
//  PlayDrama
//
//  Created by RHC on 15/5/26.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSystemSettingScreenLock : NSObject
//开启锁屏幕
+(void)screenLockSwitchOn;

//关闭锁屏幕
+ (void)screenLockSwitchOff;

+ (void)screenLock:(BOOL)lock;

//是否是全屏模式
+ (void) fullscreenMode: (BOOL) on;
@end
