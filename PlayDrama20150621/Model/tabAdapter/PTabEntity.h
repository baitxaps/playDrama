//
//  PBeautyTabEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTabEntity : NSObject

/**
 *  选项卡1名称
 */
@property (nonatomic, strong) NSString *tabOne;

/**
 *  选项卡2名称
 */
@property (nonatomic, strong) NSString *tabTwo;

/**
 *  选项卡3名称
 */
@property (nonatomic, strong) NSString *tabThree;

/**
 *  按钮字体颜色
 */
@property (nonatomic, strong) UIColor  *buttonTintColor;


/**
 *  控件背颜色
 */
@property (nonatomic, strong) UIColor  *backgroundColor;
@end
