//
//  PAttributedStyle.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAttributedStyle.h"

@implementation PAttributedStyle

+ (PAttributedStyle *)attributeName:(NSString *)attributeName value:(id)value range:(NSRange)range {
    
    PAttributedStyle *style = [[self class] new];
    
    style.attributeName = attributeName;
    style.value         = value;
    style.range         = range;
    
    return style;
}

@end
