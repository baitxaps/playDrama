//
//  PBeautyDetailResumeCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBeautyEntity;

@interface PBeautyDetailResumeCell : UITableViewCell

@property (nonatomic,strong)PBeautyEntity *beautyEntity;

+ (PBeautyDetailResumeCell*)loadCell;

@end
