//
//  PVoteTableViewCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PVoteTableViewCell.h"

@implementation PVoteTableViewCell

- (void)awakeFromNib {
    self.backgroundColor             = RGBAColor(240, 79, 48, 0.98);
    self.contentView.backgroundColor = RGBAColor(240, 79, 48, 0.98);
}

+ (PVoteTableViewCell *)loadCell
{
    PVoteTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"PVoteTableViewCell"
                                                            owner:self
                                                          options:nil].firstObject;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.backgroundColor = [UIColor yellowColor];
    // Configure the view for the selected state
}

@end
