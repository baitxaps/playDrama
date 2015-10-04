//
//  PBeautyCollectionHeadView.h
//  PlayDrama
//
//  Created by hairong chen on 15/6/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBeautyCollectionHeadView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *boyBGView;
@property (weak, nonatomic) IBOutlet UIView *girlBGView;
@property (weak, nonatomic) IBOutlet UIImageView *maleImgView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImgView;

- (void)feframe;
@end
