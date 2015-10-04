//
//  PAnimation.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAnimation.h"

@implementation PAnimation

+ (void)transformAnimationDruation:(NSTimeInterval)duration
                              view:(UIView *)view
                         transform:(CGAffineTransform)transform
{
    [UIView animateWithDuration:duration animations:^{
        view.transform = transform;
    }];
}
/*
 *duration :时间
 *animation:是否动画
 *sView:    源视图，目标视在源视图的下面位置
 *dView:    目标视图,动画变化
 *offsetSize:目标视图的size
 */

+ (void)showAnimaitonDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                         sView:(UIView*)sView
                         dView:(UIView*)dView
                   offsetSize:(CGSize)offsetSize
{
    CGRect frame        = dView.frame;
    frame.size.height   = offsetSize.height;
    frame.size.width    = offsetSize.width;
    
    CGPoint point = [PContainerCoords widgetWithLowerLeftCoordinates:sView.frame];
    
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [dView setFrame:CGRectMake(point.x,
                                      point.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [dView setFrame:CGRectMake(point.x,
                                      point.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}

+ (void)hideAnimationDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                         view:(UIView*)view
{
    CGRect frame        = view.frame;
    frame.size.height   = 0;
    if (animation) {
        [UIView animateWithDuration:duration animations:^{
            [view setFrame:CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            [view setFrame:CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      frame.size.width,
                                      frame.size.height)];
        }];
    }
}

@end
