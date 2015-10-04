//
//  PVerifyMobile.m
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PVerifyFunc.h"

@implementation PVerifyFunc

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //    ^(130|131|132|133|134|135|136|137|138|139)\d{8}$
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * extra = @"^147\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextextex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", extra];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextextex evaluateWithObject:mobileNum] == YES)
        ) {
        return YES;
    }
    return NO;
}

+ (id) checkObjectInvalid: (id) param {
    if ((!param) || ([param isEqual:[NSNull null]])) {
        return @"";
    }
    
    return param;
}

+ (void)loginOut:(UIViewController *)vc
{
    UIStoryboard *drama_storyboard = [UIStoryboard storyboardWithName:PLOGIN_STORYBOARD bundle:[NSBundle mainBundle]];
    UIViewController *loginVC = drama_storyboard.instantiateInitialViewController;
    [vc presentViewController:loginVC animated:YES completion:nil];
    
}

+ (void)showLogin:(UIViewController *)vc;
{
    if (![PUserEntity sharedInstance].userId) {
        [PVerifyFunc loginOut:vc];
    }
}

@end
