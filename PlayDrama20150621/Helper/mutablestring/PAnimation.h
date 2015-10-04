//
//  PAnimation.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAnimation : NSObject

+ (void)showAnimaitonDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        sView:(UIView*)sView
                        dView:(UIView*)dView
                   offsetSize:(CGSize)offsetSize;

+ (void)hideAnimationDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                         view:(UIView*)view;

+ (void)transformAnimationDruation:(NSTimeInterval)duration
                              view:(UIView *)view
                         transform:(CGAffineTransform)transform;
@end
