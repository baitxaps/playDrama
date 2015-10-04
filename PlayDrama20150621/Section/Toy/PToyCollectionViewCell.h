//
//  PToyCollectionViewCell.h
//  PlayDrama
//
//  Created by RHC on 15/6/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PToyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *toyImgView;
@property (weak, nonatomic) IBOutlet UIView      *bottomView;
@property (weak, nonatomic) IBOutlet UILabel     *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImgView;
@end
