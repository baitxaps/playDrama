//
//  PMeTableViewCell.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMeTableViewCell.h"
@interface PMeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *movieBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation PMeTableViewCell

- (void)awakeFromNib {
    [self.movieBtn drawBounderWidth:.05 Color:[UIColor clearColor] radius:self.movieBtn.frame.size.height/2.0];
    self.shareBtn.backgroundColor = RGBAColor(253, 152, 51, 1);
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareBtn drawBounderWidth:0.5 Color: RGBAColor(253, 152, 51, 1) radius:3.0];
    self.dateLabel.textColor = RGBAColor(206, 207, 208, 1);
    self.timeLabel.textColor = RGBAColor(206, 207, 208, 1);
    
}

- (void)cellWithIndexPath:(NSIndexPath *)indexPath data:(NSArray *)data
{
 
}

- (IBAction)shareAction:(UIButton *)sender
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
