//
//  PLoginManager.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PLoginManager.h"
#import "PlayTabBarViewController.h"

@implementation PLoginManager

+(PLoginManager *) sharedInstance
{
    static PLoginManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

- (PlayTabBarViewController *)playTabbarVC
{
    if (nil == _playTabbarVC) {
        _playTabbarVC = [PlayTabBarViewController shareInstance];
    }
    return _playTabbarVC;
}



@end
