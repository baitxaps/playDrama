//
//  PDramaDetailChapterCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/9/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PDramaDetailChapterCell.h"
#import "PDramaEntity.h"

@interface PDramaDetailChapterCell ()

@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;

@end

@implementation PDramaDetailChapterCell

- (void)awakeFromNib
{
    
}

+ (PDramaDetailChapterCell *)initCellWithNib
{
    return  [[NSBundle mainBundle]loadNibNamed:@"PDramaDetailChapterCell"
                                         owner:self
                                       options:nil].firstObject;
}

- (void)setMovieName:(NSString *)movieName
{
    self.movieNameLabel.text = movieName;
}

- (void)setDramaEntity:(PDramaEntity *)dramaEntity
{
    _dramaEntity             = dramaEntity;
    self.movieNameLabel.text = _dramaEntity.movieName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
