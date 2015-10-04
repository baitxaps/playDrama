//
//  PHistogramView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/21.
//  Copyright (c) 2015年 times. All rights reserved.
//
/*
 *画柱状图
 */

#import <UIKit/UIKit.h>
#import "PBillEntitiy.h"

@interface PHistogramView : UIView
@property (assign,nonatomic) BOOL         isText;
@property (strong,nonatomic) PBillEntitiy *billEntity;
@property (copy,  nonatomic)NSArray *datas;
@property (copy,  nonatomic)NSArray *colors;

- (void)noData;

@end
