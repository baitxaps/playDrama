//
//  PBottomEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBottomEntity : NSObject

/**
 *	@brief	底部标签1图
 */
@property (nonatomic,strong)UIImage *bottomTabOneImage;

/**
 *	@brief	底部标签2图
 */
@property (nonatomic,strong)UIImage *bottomTabTwoImage;

/**
 *	@brief	底部标签3图
 */
@property (nonatomic,strong)UIImage *bottomTabThreeImage;

/**
 *	@brief	底部标签选定1图
 */
@property (nonatomic,strong)UIImage *bottomTabOneSelectedImage;

/**
 *	@brief	底部标签选定2图
 */
@property (nonatomic,strong)UIImage *bottomTabTwoSelectedImage;

/**
 *	@brief	底部标签选定3图
 */
@property (nonatomic,strong)UIImage *bottomTabThreeSelectedImage;

/**
 *	@brief	控件背景颜色
 */
@property (nonatomic,strong)UIColor *backGroundColor;
@end
