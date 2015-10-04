//
//  PFontStyle.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PFontStyle.h"

@implementation PFontStyle
+ (id)withFont:(UIFont *)font range:(NSRange)range {
    
    id fontStyle = [super attributeName:NSFontAttributeName
                                  value:font
                                  range:range];
    
    return fontStyle;
}
@end
