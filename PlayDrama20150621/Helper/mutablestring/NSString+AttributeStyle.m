//
//  NSString+AttributesStyle.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "NSString+AttributeStyle.h"

@implementation NSString (AttributeStyle)
- (NSAttributedString *)createAttributedStringWithStyles:(NSArray *)styles {
    if (self.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    
    for (int count = 0; count < styles.count; count++) {
        PAttributedStyle *style = styles[count];
        
        [attributedString addAttribute:style.attributeName
                                 value:style.value
                                 range:style.range];
    }
    
    
    return attributedString;
}

@end
