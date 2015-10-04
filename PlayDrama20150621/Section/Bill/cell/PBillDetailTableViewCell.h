//
//  PBillDetailRoleCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillBaseDetailCell.h"

@class PBillDetailCellFrame;

@interface PBillDetailTableViewCell : PBillBaseDetailCell

@property (nonatomic, strong) PBillDetailCellFrame *cellFrame;
@property (assign, nonatomic) id<PDramaDelegate>delegate;
@end
