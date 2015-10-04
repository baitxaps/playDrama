//
//  NSString+AttributesStyle.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAttributedStyle.h"

@interface NSString (AttributeStyle)

/**
 *  根据styles数组创建出富文本
 *
 *  @param styles AttributedStyle对象构成的数组
 *
 *  @return 富文本
 */
- (NSAttributedString *)createAttributedStringWithStyles:(NSArray *)styles;

@end
