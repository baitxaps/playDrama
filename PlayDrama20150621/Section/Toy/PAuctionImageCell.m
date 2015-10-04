//
//  PAuctionImageCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAuctionImageCell.h"
#import "PAuctionEntity.h"

@interface PAuctionImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *joyImageView;

@end

@implementation PAuctionImageCell

- (void)awakeFromNib {
    
    self.backgroundColor = RGBAColor(225, 226, 228,1);
}

+ (PAuctionImageCell *)initCellWithNib
{
    return [[NSBundle mainBundle]loadNibNamed:@"PAuctionImageCell" owner:self options:nil].firstObject;
}

+(instancetype)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    PAuctionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [PAuctionImageCell initCellWithNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void)setAuctionEntity:(PAuctionEntity *)auctionEntity
{
    _auctionEntity = auctionEntity;
    self.joyImageView.image = [UIImage imageNamed:auctionEntity.goodsImageUrl];
    
#if 0
    [self.joyImageView sd_setImageWithURL:[NSURL URLWithString:auctionEntity.goodsImageUrl]
                         placeholderImage:[UIImage imageNamed:@"Userdefault"]
                                  options:SDWebImageLowPriority|SDWebImageRetryFailed ];
#endif
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
