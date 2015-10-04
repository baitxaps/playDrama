//
//  PSystemSettingScreenLock.m
//  PlayDrama
//
//  Created by RHC on 15/5/26.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PSystemSettingScreenLock.h"

@implementation PSystemSettingScreenLock
+(void)screenLockSwitchOff
{
    //不自动锁屏幕
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

+ (void)screenLockSwitchOn
{
    //自动所屏幕
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

+ (void)screenLock:(BOOL)lock
{
    [UIApplication sharedApplication].idleTimerDisabled = lock;
}

+ (void)fullscreenMode: (BOOL) on
{
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:on withAnimation:UIStatusBarAnimationNone];
}


@end
