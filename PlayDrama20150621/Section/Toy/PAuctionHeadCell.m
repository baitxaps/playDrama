//
//  PAuctionHeadCellTableViewCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAuctionHeadCell.h"
#import "PAuctionEntity.h"

@interface PAuctionHeadCell()

@property (weak, nonatomic) IBOutlet UILabel *toyNameLabel;

@end

@implementation PAuctionHeadCell

- (void)awakeFromNib
{
   // [self drawBounderWidth:1 Color:[UIColor redColor]];
    self.backgroundColor = RGBAColor(225, 226, 228,1);
}

+ (PAuctionHeadCell *)initCellWithNib
{
    return [[NSBundle mainBundle]loadNibNamed:@"PAuctionHeadCell" owner:self options:nil].firstObject;
}

+(instancetype)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    PAuctionHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [PAuctionHeadCell initCellWithNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAuctionEntity:(PAuctionEntity *)auctionEntity
{
    _auctionEntity = auctionEntity;
    self.toyNameLabel.text = auctionEntity.goodsName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
