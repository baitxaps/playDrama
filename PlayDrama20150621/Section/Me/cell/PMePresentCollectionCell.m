//
//  PMePresentCollectionCell.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PMePresentCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface PMePresentCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionLabel;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;

@end

@implementation PMePresentCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setPresentEntity:(PresentEntity *)presentEntity
{
    if (presentEntity) {
        _presentEntity = presentEntity;
        _goodsNameLabel.text = presentEntity.goodsName;
        _additionLabel .text = presentEntity.additionName;
        [_coinBtn setTitle:presentEntity.coin forState:UIControlStateNormal];
        
        if ([presentEntity.imgUrl hasPrefix:@"http://"]) {
            [ _goodsImageView sd_setImageWithURL:[NSURL URLWithString:presentEntity.imgUrl]
                                placeholderImage:[UIImage imageNamed:@""]//addimtion
                                         options:SDWebImageRetryFailed|SDWebImageLowPriority];
        }else{
            _goodsImageView.image = [UIImage imageNamed:presentEntity.imgUrl];
        }
     
    }
}

- (void)updateColorWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row %4;
    UIColor *color = nil;
    switch (index) {
        case 0:
        {
            color = RGBAColor(69, 166, 251, 1);
        }
            break;
        case 1:
        {
            color = RGBAColor(245, 59, 68, 1);
        }
            break;
        case 2:
        {
            color = RGBAColor(246, 151, 67, 1);
        }
            break;
        case 3:
        {
             color = RGBAColor(242, 227, 17, 1);
        }
            break;
            
        default:
            break;
    }
    
    self.arrowView.backgroundColor = color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
