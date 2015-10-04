//
//  PAttributedStyle.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PAttributedStyle : NSObject

@property (nonatomic, strong) NSString  *attributeName;
@property (nonatomic, strong) id         value;
@property (nonatomic)         NSRange    range;

/**
 *  便利构造器
 *
 *  @param attributeName 属性名字
 *  @param value         设置的值
 *  @param range         取值范围
 *
 *  @return 实例对象
 */
+ (PAttributedStyle *)attributeName:(NSString *)attributeName value:(id)value range:(NSRange)range;

@end
