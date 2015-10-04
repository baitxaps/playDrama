//
//  PBillBaseCellFrame.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUILayoutConst.h"

@class PBillEntitiy;

@interface PBillBaseCellFrame : NSObject
{
    CGFloat _cellHeight;
}

@property (strong, nonatomic) PBillEntitiy *billEntity;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic,readonly) CGRect billTypeNameLabelRect;
@property (assign, nonatomic,readonly) CGRect billTypeImageViewRect;
@property (assign, nonatomic,readonly) CGRect lineViewRect;
@property (assign, nonatomic,readonly) CGRect voteBtnRect;


@end
