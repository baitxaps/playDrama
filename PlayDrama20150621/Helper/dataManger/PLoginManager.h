//
//  PLoginManager.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PlayTabBarViewController;

@interface PLoginManager : NSObject

@property (nonatomic,strong)PlayTabBarViewController *playTabbarVC;

+(PLoginManager *) sharedInstance;

@end
