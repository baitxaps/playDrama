//
//  PVerifyMobile.h
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVerifyFunc : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (id) checkObjectInvalid: (id) param;

//直接退出
+ (void)loginOut:(UIViewController *)vc;

//没有登录，显示登录
+ (void)showLogin:(UIViewController *)vc;
@end
