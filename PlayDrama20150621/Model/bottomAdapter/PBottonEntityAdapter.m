//
//  PBottonEntityAdapter.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBottonEntityAdapter.h"
#import "PBottomEntity.h"

@implementation PBottonEntityAdapter

- (instancetype)initWithData:(id)data
{
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

-(UIImage *)bottomTabOneImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabOneImage;
}

-(UIImage *)bottomTabTwoImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabTwoImage;
    
}

-(UIImage *)bottomTabThreeImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabThreeImage;
}

-(UIColor *)backGroudColor
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.backGroundColor;
}

-(UIImage *)bottomTabOneSelectedImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabOneSelectedImage;
}

-(UIImage *)bottomTabTwoSelectedImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabTwoSelectedImage;
}

-(UIImage *)bottomTabThreeSelectedImage
{
    PBottomEntity *bottonEntity = self.data;
    return bottonEntity.bottomTabThreeSelectedImage;
}


@end
