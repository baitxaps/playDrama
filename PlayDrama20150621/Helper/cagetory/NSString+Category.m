//
//  NSString+Category.m
//  PlayDrama
//
//  Created by hairong.chen on 15/9/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

#pragma mark - 将空字符用空格代替（OC 风格）
- (NSString *)replaceNilWithSpace
{
    NSString *tempStr = self;
    if (tempStr.length == 0) {
        tempStr = @"";
    }
    
    return tempStr;
}

#pragma mark - 将空字符用空格代替(C 风格)
NSString *replaceNilWithSpace(NSString *sourceStr)
{
    if (sourceStr.length == 0) {
        sourceStr = @"";
    }
    return sourceStr;
}


- (NSString *)stringByTrimmingWhitespace:(NSString *)string
{
    NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimString;
}
@end
