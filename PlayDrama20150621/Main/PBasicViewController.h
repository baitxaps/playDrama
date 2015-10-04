//
//  PBasicViewController.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PBasicViewController : UIViewController
{
    MBProgressHUD *_hud;
}

- (void)showHudWithAnimated:(BOOL)animated;
- (void)showHudWithTitle:(NSString *)title;

- (void)showHudScreenAnimated:(BOOL)animated;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg;

@end
