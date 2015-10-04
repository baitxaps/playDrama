//
//  PForeGroundColorStyle.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PForeGroundColorStyle.h"

@implementation PForeGroundColorStyle
+ (id)withColor:(UIColor *)color range:(NSRange)range {
    
    id style = [super attributeName:NSForegroundColorAttributeName
                              value:color
                              range:range];
    
    return style;
}

@end
