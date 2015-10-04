//
//  NSString+Category.h
//  PlayDrama
//
//  Created by hairong.chen on 15/9/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
/*
 *  将空字符用空格代替（OC 风格）
 *
 *  @return 字符
 */

- (NSString *)replaceNilWithSpace;

/*
 *  将空字符用空格代替(C 风格)
 *
 *  @param sourceStr 原始字符串
 *
 *  @return 目标字符串
 */
NSString *replaceNilWithSpace(NSString *sourceStr);


/**
 *	@brief	去掉空格（前后）
 *
 *	@param 	string 	:
 *
 *	@return
 */
- (NSString *)stringByTrimmingWhitespace:(NSString *)string;


@end
