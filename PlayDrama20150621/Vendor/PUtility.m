//
//  PUtility.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PUtility.h"
#define kMSG_Tag                10010

@implementation PUtility
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg
{
    UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [win makeToast:msg duration:1.0 position:@"center" tag:kMSG_Tag];
}
@end
