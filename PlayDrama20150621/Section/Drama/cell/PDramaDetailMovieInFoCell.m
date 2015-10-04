//
//  PDramaDetailTableViewCell.m
//  PlayDrama
//
//  Created by RHC on 15/4/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

/*
 *RTLabel要确定frame.origin.x,y,Width
 */
#import "PDramaDetailMovieInFoCell.h"
#import "RTLabel.h"
#import "PDramaEntity.h"
#import  "PUILayoutConst.h"

#define  CellBoundsOffset  119
#define  kRTlabelX         12
#define  kRTlabelY         CellBoundsOffset
#define  kRTlabelOffset    11
#define  kRTLabelWidth     UIScreenWidth -32 -30


@interface PDramaDetailMovieInFoCell()

@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDistrictLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moviePlayCountLabel;
@property (weak, nonatomic) IBOutlet RTLabel *movieDescLabel;
@property (weak, nonatomic) IBOutlet UIView  *lineView;

@end

@implementation PDramaDetailMovieInFoCell

- (void)awakeFromNib
{
    [self.lineView setBackgroundColor:RGBAColor(96, 174, 243, 1)];
    self.movieDescLabel.font        = kBase13Font;
    self.movieDescLabel.frame       = (CGRect){{kRTlabelX,kRTlabelY}, {kRTLabelWidth, 0}};
}

+ (PDramaDetailMovieInFoCell *)loadCell
{
    return  [[NSBundle mainBundle]loadNibNamed:@"PDramaDetailMovieInFoCell"
                                         owner:self
                                       options:nil].firstObject;
}

- (CGFloat)tableViewWithData:(PDramaEntity *)dramaEntity heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dramaEntity                = dramaEntity;
    self.movieDescLabel.text        = dramaEntity.movieDesc;
    self.movieDescLabel.lineSpacing = klineSpacing;
    
    CGSize pSize                    = [self.movieDescLabel optimumSize];
    self.dramaEntity.movieDescFram  = (CGRect){{kRTlabelX,kRTlabelY}, {pSize.width, pSize.height+ kRTlabelOffset}};
    
    CGFloat height                  = pSize.height+ kRTlabelOffset + CellBoundsOffset ;
    if (height <=self.bounds.size.height) {
        height = self.bounds.size.height;
    }
    return height ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.movieDescLabel.frame =  self.dramaEntity.movieDescFram;
}

- (void)setDramaEntity:(PDramaEntity *)dramaEntity
{
    _dramaEntity                    = dramaEntity;
    self.movieDescLabel.lineSpacing = klineSpacing;
  
    self.movieDescLabel.text    = dramaEntity.movieDesc ;
    _movieNameLabel.text        = dramaEntity.movieName;
    _movieDistrictLabel.text    = [NSString stringWithFormat:@"地区:%@",dramaEntity.movieDist];
    _movieYearLabel.text        = [NSString stringWithFormat:@"年份:%@",dramaEntity.movieYear];
    _movieTypeLabel.text        = [NSString stringWithFormat:@"类型:%@",dramaEntity.movieType];
    _moviePlayCountLabel.text   = [NSString stringWithFormat:@"播放:%@",dramaEntity.moviePlayCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
