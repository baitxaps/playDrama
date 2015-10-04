//
//  PBillDetailRoleCellFrame.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillBaseCellFrame.h"
#import "PBillEntitiy.h"

@interface PBillDetailCellFrame : PBillBaseCellFrame
@property (assign, nonatomic,readonly) CGRect sexImgViewRect;
@property (assign, nonatomic,readonly) CGRect roleTextLabelRect;
@property (assign, nonatomic,readonly) CGRect roleNameLabelRect;
@property (assign, nonatomic)          CGFloat histogramViewWidth;
@property (assign, nonatomic,readonly) CGRect histogramViewRect;
@property (assign, nonatomic,readonly) CGRect scrollViewRect;
@end
