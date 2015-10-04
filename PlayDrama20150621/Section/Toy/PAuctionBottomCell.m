//
//  PAuctionBottomCellT.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PAuctionBottomCell.h"
#import "PUserEntity.h"
#import "PAuctionEntity.h"

@interface PAuctionBottomCell ()

@property (weak, nonatomic) IBOutlet UILabel      *cutdownLabel;        //倒计时
@property (weak, nonatomic) IBOutlet UILabel      *heightPriceLabel;    //最高竞价
@property (weak, nonatomic) IBOutlet UILabel      *startPriceLabel;     //开始竞价
@property (weak, nonatomic) IBOutlet UIButton     *auctionBtn;          //竞拍按钮
@property (weak, nonatomic) IBOutlet UIButton     *showDetailBtn;       //查看详情按钮
@property (weak, nonatomic) IBOutlet UILabel      *auctionUserName;     //用户名
@property (weak, nonatomic) IBOutlet UIImageView  *loundImgView;        //扬声器

@end

@implementation PAuctionBottomCell


- (void)awakeFromNib
{
    //[self drawBounderWidth:1 Color:[UIColor redColor]];
    self.layer.contents  = (__bridge id)([UIImage imageNamed:@"toy_BottomBG"].CGImage);
}

+ (PAuctionBottomCell *)initCellWithNib
{
    return [[NSBundle mainBundle]loadNibNamed:@"PAuctionBottomCell" owner:self options:nil].firstObject;
}

+(instancetype)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    PAuctionBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [PAuctionBottomCell initCellWithNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAuctionEntity:(PAuctionEntity *)auctionEntity
{
    _auctionEntity              = auctionEntity ;
    self.cutdownLabel.text      = auctionEntity.startTime;
    self.heightPriceLabel.text  = auctionEntity.maxPrice;
    self.startPriceLabel.text   = auctionEntity.initiatePrice;
    
}

#pragma mark - 白卖接口请求

- (void)excuteAfterDelay
{
    [UIView animateWithDuration:0.3 animations:^{
        _auctionBtn.selected = !_auctionBtn.selected;
    }];
}


#pragma mark - 发送命令
- (void)aucationCmd
{
    if ([self.delegate respondsToSelector:@selector(tableViewCellClickInCell:)]) {
        [self.delegate tableViewCellClickInCell:self];
    }
    
//    [self performSelector:@selector(btnImageViewAnimation)
//               withObject:nil
//               afterDelay:0.2];
}

#pragma mark - 竞拍
- (IBAction)auctionAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self performSelector:@selector(excuteAfterDelay)
               withObject:nil
               afterDelay:0.2];
    
    [self aucationCmd];
}

//- (void)didMoveToSuperview{
//    double x = self.auctionEntity.isExpand ? M_PI:0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.showDetailBtn.transform = CGAffineTransformMakeRotation(x);
//    }];
//}


- (void)arrowAnimation
{
    double x = self.auctionEntity.isExpand ? M_PI:0;
    [UIView animateWithDuration:0.3 animations:^{
        self.showDetailBtn.transform = CGAffineTransformMakeRotation(x);
    }];
}

#pragma mark - 详情
- (IBAction)detailAction:(id)sender
{
    [self performSelector:@selector(arrowAnimation)
               withObject:self
               afterDelay:.2];
    
    self.auctionEntity.isExpand = ! self.auctionEntity.isExpand;
    if ([self.delegate respondsToSelector:@selector(tableViewCellClickWithView:indexPath:)]) {
        [self.delegate tableViewCellClickWithView:self indexPath:self.indexPath];
    }
}


-(void)btnImageViewAnimation
{
    CABasicAnimation* shake = \
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.1];
    shake.toValue = [NSNumber numberWithFloat:+0.1];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    self.loundImgView.alpha = 1.0;
    [UIView animateWithDuration:2.0
                          delay:2.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:nil completion:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


@end
