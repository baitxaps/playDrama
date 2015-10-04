//
//  PToyCollectionViewCell.m
//  PlayDrama
//
//  Created by RHC on 15/6/23.
//  Copyright (c) 2015年 times. All rights reserved.
//
#define SPACE 3

#import "PToyCollectionViewCell.h"

@implementation PToyCollectionViewCell

- (void)awakeFromNib {
    
    //_bottomView.backgroundColor = RGB(0xffffff, 0.8);
    
    CGRect moneyRect    = _moneyImgView.frame;
    CGFloat x           = (UIScreenWidth/2-20)/2 - moneyRect.size.width;
    CGFloat y           = moneyRect.origin.y;
    [_moneyImgView setFrame:CGRectMake(x,
                                       y,
                                       moneyRect.size.width,
                                       moneyRect.size.height)];
    
    CGRect moneyLabelRect   = _moneyLabel.frame;
    CGPoint point           =\
    [PContainerCoords widgetWithUpperRightCoordinates:_moneyImgView.frame];
    [_moneyLabel setFrame:CGRectMake(point.x +SPACE,
                                     point.y ,
                                     moneyLabelRect.size.width,
                                     moneyLabelRect.size.height)];
}

@end
