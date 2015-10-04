//
//  PContainerCoords.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/13.
//  Copyright (c) 2015年 times. All rights reserved.
//

/*
 (minX,minY)
 A--------------------B(maxX,minY)
 -                    -
 -                    -
 -                    -
 C--------------------D(maxX,maxY)
 (minX,maxY)
 */

#import "PContainerCoords.h"

@implementation PContainerCoords

//左下角坐标
+ (CGPoint)widgetWithLowerLeftCoordinates :(CGRect)frame
{
    CGPoint point;
    CGFloat x   = CGRectGetMinX(frame);
    CGFloat y   = CGRectGetMaxY(frame);
    point.x     = x;
    point.y     = y;
    return point;
}

//左上角坐标
+ (CGPoint)widgetWithUpperLeftCoordinates :(CGRect)frame
{
    CGPoint point;
    CGFloat x   = CGRectGetMinX(frame);
    CGFloat y   = CGRectGetMinY(frame);
    point.x     = x;
    point.y     = y;
    return point;
}

//右下角坐标
+ (CGPoint)widgetWithLowerRightCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x   = CGRectGetMaxX(frame);
    CGFloat y   = CGRectGetMaxY(frame);
    point.x     = x;
    point.y     = y;
    return point;
}

//右上角坐标
+ (CGPoint)widgetWithUpperRightCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x   = CGRectGetMaxX(frame);
    CGFloat y   = CGRectGetMinY(frame);
    point.x     = x;
    point.y     = y;
    return point;
}


//上部中点坐标
+ (CGPoint)widgetWithUpperMidCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x       = CGRectGetMinX(frame);
    CGFloat y       = CGRectGetMinY(frame);
    CGFloat width   = CGRectGetWidth(frame);
    
    point.x     = x + width/2.0;
    point.y     = y;
    return point;
}


//下部中点坐标
+ (CGPoint)widgetWithLowerMidCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x       = CGRectGetMinX(frame);
    CGFloat y       = CGRectGetMaxY(frame);
    CGFloat width   = CGRectGetWidth(frame);
    
    point.x     = x + width/2.0;
    point.y     = y;
    return point;
}

//左部中点坐标
+ (CGPoint)widgetWithLeftMidCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x       = CGRectGetMinX(frame);
    CGFloat y       = CGRectGetMinY(frame);
    CGFloat width   = CGRectGetWidth(frame);
    
    point.x     = x ;
    point.y     = y + width/2.0;
    return point;
}

//右部中点坐标
+ (CGPoint)widgetWithRightMidCoordinates:(CGRect)frame
{
    CGPoint point;
    CGFloat x       = CGRectGetMaxX(frame);
    CGFloat y       = CGRectGetMinY(frame);
    CGFloat width   = CGRectGetWidth(frame);
    
    point.x     = x ;
    point.y     = y + width/2.0;
    return point;
}

/*
 *sFrame: 源Frame
 *dWitdh: 目的Witdh
 *offset: 偏移量
 */
+ (CGPoint)getMidCoordWithSFrame:(CGRect)sframe
                          dWitdh:(CGFloat)dWidth
                          offset:(CGFloat)offset
{
    CGPoint point       = [PContainerCoords widgetWithLowerLeftCoordinates:sframe];;
    CGFloat sWidth      = sframe.size.width;
    CGFloat x           = point.x +sWidth/2.0 - dWidth/2.0;
    CGFloat y           = point.y - offset;
    
    point.x = x;
    point.y = y;
    return point;
}


@end
