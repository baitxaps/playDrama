//
//  PlayTabBarViewController.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayTabBarViewController : UITabBarController

+ (PlayTabBarViewController *)shareInstance;

/**
 *	@brief	回归初始状态
 *
 *	@return	void
 */
- (void)reSetTabbarInitial;



/**
 *  强制竖屏
 */
- (void) limitPortraitScreen;

@end