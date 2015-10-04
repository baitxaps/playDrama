//
//  PAuctionInfoCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/15.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAuctionInfoCell.h"
#import "PUserEntity.h"

@interface PAuctionInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *aucationStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *aucationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aucationCoinLabel;
@end

@implementation PAuctionInfoCell

- (void)awakeFromNib
{
    self.backgroundColor =RGB(0xffffff, 0.4);
}

+ (PAuctionInfoCell*)loadCell
{
    return [[NSBundle mainBundle ]loadNibNamed:@"PAuctionInfoCell"
                                         owner:self
                                       options:nil].firstObject;
}

- (void)updateAucationWithData:(NSArray *)data
                     indexPath:(NSIndexPath*)indexPath
{
    UIColor     *color ;
    NSString    *auctionState;
    if (indexPath.row ==0) {
        auctionState = @"领先";
        color = RGB(0xf75050, 1);
    }else{
        color = RGB(0x868686, 1);
        auctionState = @"出局";
    }
    self.aucationStateLabel.backgroundColor = color;
    self.aucationNameLabel.textColor        = color;
    self.aucationCoinLabel.textColor        = color;
    self.aucationStateLabel.text            = auctionState;
    
    
    self.aucationStateLabel.text = @"出局";
    PUserEntity *userEnity = data[indexPath.row];
    self.aucationCoinLabel.text = @"1212";
    self.aucationNameLabel.text = userEnity.userName;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
