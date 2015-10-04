//
//  PShareTools.m
//  PlayDrama
//
//  Created by RHC on 15/4/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PCustomerBottomBar.h"


@interface PCustomerBottomBar ()

@property (assign,nonatomic) BOOL     executeAnimation;
@property (weak,  nonatomic) IBOutlet UIButton *bottomBtnOne;
@property (weak,  nonatomic) IBOutlet UIButton *bottomBtnTwo;
@property (weak,  nonatomic) IBOutlet UIButton *bottomBtnThree;
@property (assign,nonatomic) PBottomBarType bottomBarType;

//@property (assign,nonatomic) id <PBottomAdapterProtocol>data;
@end

@implementation PCustomerBottomBar

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = RGBAColor(44, 126, 175, 1);//(0x277eb6,0.2);
}

+(PCustomerBottomBar *)initNib
{
    PCustomerBottomBar *view = nil;
    view = [[NSBundle mainBundle] loadNibNamed:@"PCustomerBottomBar" owner:self options:nil][0];
    return view;
}

- (IBAction)bottomBarAction:(id)sender
{
    self.bottomBarType = (PBottomBarType)((UIButton *)sender).tag;

    if (self.delegate) {
        [self.delegate bottomBarActionDelegateShareType:self.bottomBarType];
    }
    [self praiseAnimation];
    [self bottomTwoSelected];
}

#pragma mark - 设置按钮图片

- (void)loadData:(id<PBottomAdapterProtocol>)data
{
    [self.bottomBtnOne setImage:[data bottomTabOneImage] forState:UIControlStateNormal];
    [self.bottomBtnTwo setImage:[data bottomTabTwoImage] forState:UIControlStateNormal];
    [self.bottomBtnThree setImage:[data bottomTabThreeImage] forState:UIControlStateNormal];
    [self.bottomBtnTwo setImage:[data bottomTabTwoSelectedImage] forState:UIControlStateSelected];
    
    self.backgroundColor = [data backGroudColor];
}

- (void)bottomTwoSelected
{
    if (self.bottomBarType == PBottomBarTypeCollection) {
        self.bottomBtnTwo.selected =!self.bottomBtnTwo.selected;
    }
}


#pragma mark - 点赞效果

- (void)praiseAnimation
{
    if (self.bottomBarType == PBottomBarTypeLike) {
        [self.bottomBtnOne setImage:[UIImage imageNamed:(self.executeAnimation?@"beautyBarLike_up":@"beautyBarLike_down")] forState:UIControlStateNormal];
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [self.bottomBtnOne.layer addAnimation:k forKey:@"SHOW"];
        
        self.executeAnimation = !self.executeAnimation;
    }
}



@end
