//
//  PContainerCoords.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/13.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PContainerCoords : NSObject

//The upper left corner coordinates
//左下角部坐标
+ (CGPoint)widgetWithLowerLeftCoordinates :(CGRect)frame;
//左上角坐标
+ (CGPoint)widgetWithUpperLeftCoordinates :(CGRect)frame;
//右下角坐标
+ (CGPoint)widgetWithLowerRightCoordinates:(CGRect)frame;
//右上角坐标
+ (CGPoint)widgetWithUpperRightCoordinates:(CGRect)frame;

//上部中点坐标
+ (CGPoint)widgetWithUpperMidCoordinates:(CGRect)frame;
//下部中点坐标
+ (CGPoint)widgetWithLowerMidCoordinates:(CGRect)frame;
//左部中点坐标
+ (CGPoint)widgetWithLeftMidCoordinates:(CGRect)frame;
//右部中点坐标
+ (CGPoint)widgetWithRightMidCoordinates:(CGRect)frame;

//目的坐标与源坐标居中对齐
+ (CGPoint)getMidCoordWithSFrame:(CGRect)sframe
                          dWitdh:(CGFloat)dWidth
                          offset:(CGFloat)offset;
@end
