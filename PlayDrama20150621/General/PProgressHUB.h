//
//  PProgressHUB.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef MB_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define MB_INSTANCETYPE instancetype
#else
#define MB_INSTANCETYPE id
#endif
#endif

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif

@interface PProgressHUB : UIView
@property (weak, nonatomic) IBOutlet UILabel *loadingTLabelext;

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view ;
+ (MB_INSTANCETYPE)showHUDAddedToForScreen:(UIView *)view;
- (void)hide;
- (void)hideForScreen;
@end
