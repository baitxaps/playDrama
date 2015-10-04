//
//  PBeautyCollectionHeadView.m
//  PlayDrama
//
//  Created by hairong chen on 15/6/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyCollectionHeadView.h"

@implementation PBeautyCollectionHeadView

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self =[super initWithCoder:aDecoder]) {
       // self.boyBGView.backgroundColor = RGB(0x4cb17c, 1);
       // self.girlBGView.backgroundColor = RGB(0xe9ca5d, 1);
    }
    
    return self;
}

- (void)feframe
{
    CGRect bFrame           = self.boyBGView.frame;
    bFrame.origin.x         = 10;
    bFrame.size.width       = UIScreenWidth/2 -14;
    self.boyBGView.frame    = bFrame;
    
    CGRect gFrame           = self.girlBGView.frame;
    gFrame.origin.x         = self.boyBGView.frame.size.width +18;
    gFrame.size.width       = UIScreenWidth/2 -14;
    self.girlBGView.frame   = gFrame;
}

@end
