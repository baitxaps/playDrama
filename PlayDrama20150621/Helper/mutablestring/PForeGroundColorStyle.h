//
//  PForeGroundColorStyle.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAttributedStyle.h"

@interface PForeGroundColorStyle : PAttributedStyle

+ (id)withColor:(UIColor *)color range:(NSRange)range;

@end

/**
 *  内联函数
 *
 *  @param color 颜色
 *  @param range 范围
 *
 *  @return 实例对象
 */
static inline PAttributedStyle* colorStyle(UIColor *color, NSRange range) {
    return [PForeGroundColorStyle withColor:color range:range];
}