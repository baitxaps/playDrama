//
//  RedGradientColor.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/21.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "RedGradientColor.h"

@implementation RedGradientColor
- (void)createColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //////////////////////////////////////////////////////////
    
    size_t count        = 4;
    
    CGFloat locations[] = {0.0, 0.33, 0.66, 1.0};
    
    CGFloat colorComponents[] = {
        //red, green, blue, alpha
        0.85, 0, 0,  1.0,
        1, 0, 0,  1.0,
        0.85, 0.3, 0, 1.0,
        0.1, 0, 0.9, 1.0,
    };
    
    //////////////////////////////////////////////////////////
    
    self.gradientRef = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, count);
    
    CGColorSpaceRelease(colorSpace);
}
@end
