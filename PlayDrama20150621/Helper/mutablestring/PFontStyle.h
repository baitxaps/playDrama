//
//  PFontStyle.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAttributedStyle.h"

@interface PFontStyle : PAttributedStyle
+ (id)withFont:(UIFont *)font range:(NSRange)range;

@end

/**
 *  内联函数
 *
 *  @param font  字体
 *  @param range 范围
 *
 *  @return 实例对象
 */
static inline PAttributedStyle* fontStyle(UIFont *font, NSRange range) {
    return [PFontStyle withFont:font range:range];
}
