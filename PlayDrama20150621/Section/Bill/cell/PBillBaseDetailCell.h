//
//  PBillBaseDetailCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLSPACE 8

@class PBillBaseCellFrame;
@interface PBillBaseDetailCell : UITableViewCell
{
    UILabel          *_billTypeNameLabel;
    UIImageView      *_billTypeImageView;
    UIButton         *_voteBtn;
    UIView           *_lineView;
    CGFloat          cellHeight;
}

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) PBillBaseCellFrame *baseCellFrame;

@end
