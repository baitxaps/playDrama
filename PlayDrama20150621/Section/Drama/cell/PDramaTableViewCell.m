//
//  PDramaTableViewCell.m
//  PlayDrama
//
//  Created by chenhairong on 15/4/11.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PDramaTableViewCell.h"
@interface PDramaTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView    *filmImageView;
@property (weak, nonatomic) IBOutlet UIView         *filmTextView;
@property (weak, nonatomic) IBOutlet UILabel        *filmTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@end

@implementation PDramaTableViewCell

- (void)awakeFromNib {

    self.filmTextLabel.textColor       = FilmTextWhiteColor;
    //self.filmTextView.backgroundColor  = FilmViewBGColor;
}

- (void)cellUpdateForData:(NSString *)data
{
    self.playImageView.image = [UIImage imageNamed:@"drama_cell_play"];
    self.filmTextLabel.text = data;
    self.filmImageView.image = [UIImage imageNamed:data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
