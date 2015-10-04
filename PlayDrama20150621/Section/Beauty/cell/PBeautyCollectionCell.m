//
//  PBeautyCollectionCell.m
//  PlayDrama
//
//  Created by RHC on 15/6/18.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyCollectionCell.h"
@interface PBeautyCollectionCell()
@property (nonatomic,assign) BOOL executeAnimation;
@end

@implementation PBeautyCollectionCell

- (void)awakeFromNib {
    _leftView.alpha = 0.75;
    _presentImgView.userInteractionEnabled      = YES;
    _presentImgView.exclusiveTouch              = YES;
     _priseBtn.exclusiveTouch                   = YES;

    UITapGestureRecognizer *gs = \
    [[UITapGestureRecognizer alloc]initWithTarget:self
                                           action:@selector(showPresentAction:)];
    [_presentImgView addGestureRecognizer:gs];
}

#pragma mark - the present taped
- (void)showPresentAction:(UIGestureRecognizer *)gs
{
    
}


#pragma mark - the btn taped

- (IBAction)praiseAction:(id)sender
{
    [self praiseAnimation];
}


- (void)praiseAnimation
{
    [self.priseBtn setImage:[UIImage imageNamed:(self.executeAnimation?@"beautyBarLike_down":@"beautyBarLike_down")] forState:UIControlStateNormal];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [self.priseBtn.layer addAnimation:k forKey:@"SHOW"];
    
    self.executeAnimation = !self.executeAnimation;
    
}


@end
