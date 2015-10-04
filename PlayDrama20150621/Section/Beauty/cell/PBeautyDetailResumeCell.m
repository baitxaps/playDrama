//
//  PBeautyDetailResumeCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyDetailResumeCell.h"
#import "PBeautyEntity.h"

@interface PBeautyDetailResumeCell ()
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;//职务
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;//生日
@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;//星座
@property (weak, nonatomic) IBOutlet UILabel *animalLabel;  //生肖
@property (weak, nonatomic) IBOutlet UIView  *lineView;
@end

@implementation PBeautyDetailResumeCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = RGB(0xd8d8d8, 1);
    self.lineView.backgroundColor =  RGBAColor(250, 164, 164, 1);
}

+ (PBeautyDetailResumeCell*)loadCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"PBeautyDetailResumeCell" owner:self options:nil].firstObject;
}


- (void)setBeautyEntity:(PBeautyEntity*)beautyEntity
{
    if (beautyEntity) {
        _beautyEntity = beautyEntity;
        
        self.nameLabel.text     = [NSString stringWithFormat:@"姓名:%@",_beautyEntity.castName];
        self.jobLabel.text      = [NSString stringWithFormat:@"职务:%@", _beautyEntity.castJob];
        self.birthdayLabel.text = [NSString stringWithFormat:@"生日:%@", _beautyEntity.castBirth];
        self.animalLabel.text   =  [NSString stringWithFormat:@"星肖:%@",_beautyEntity.castHoroscope];
        self.constellationLabel.text =  [NSString stringWithFormat:@"星座:%@",_beautyEntity.castHoroscope];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
