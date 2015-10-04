//
//  GOMenuCollectionCell.m
//  golo
//
//  Created by chenhairong on 14/11/17.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import "PMenuCollectionCell.h"


//const CGFloat TextFontSizeUnselected = 16.0;
@implementation PMenuCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuBtn.frame = self.bounds;
    [_menuBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _menuBtn.exclusiveTouch = YES;
    _menuBtn.titleLabel.numberOfLines = 0;
    _menuBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_menuBtn];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = kGrayBorderColor.CGColor;
}

@end
