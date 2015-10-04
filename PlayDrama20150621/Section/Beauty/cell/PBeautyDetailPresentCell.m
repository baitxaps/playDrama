//
//  PBeautyDetailPresentCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/10.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyDetailPresentCell.h"

@interface PBeautyDetailPresentCell ()
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@end

@implementation PBeautyDetailPresentCell

- (void)awakeFromNib {
   self.backgroundColor = RGB(0xd8d8d8, 1);
}

+ (PBeautyDetailPresentCell *)loadCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"PBeautyDetailPresentCell" owner:self options:nil].firstObject;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
