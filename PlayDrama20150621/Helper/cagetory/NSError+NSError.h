//
//  NSError+NSError.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (NSError)
/**
 *  网络错误
 *
 *  @return NSError
 */
+ (NSError *)networkError;

/**
 *  获取网络配置失败，请重新启动客户端
 *
 *  @return NSError
 */
+ (NSError *)failedConfigReopenError;
/**
 *  未知错误
 *
 *  @return NSError
 */
+ (NSError *)unknowError;
/**
 *  其它类型错误
 *
 *  @param msgString 错误信息
 *  @param code      错误码
 *
 *  @return NSError
 */
+ (NSError *)errorWithMsg:(NSString *)msgString code:(int)code;
@end
