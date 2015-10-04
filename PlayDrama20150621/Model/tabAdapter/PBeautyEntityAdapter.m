//
//  PBeautyEntityAdapter.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBeautyEntityAdapter.h"
#import "PTabEntity.h"

@implementation PBeautyEntityAdapter

- (instancetype)initWithData:(id)data {
    
    self = [super init];
    if (self) {
        self.data = data;
    }
    
    return self;
}


-(UIColor *)buttonTintColor
{
    PTabEntity *data = self.data;
    
    return data.buttonTintColor;
}


-(UIColor *)backgroundColor
{
    PTabEntity *data = self.data;
    
    return data.backgroundColor;
}


-(NSString*)tabOne
{
    PTabEntity *data = self.data;
    
    return data.tabOne;
}

-(NSString*)tabTwo
{
    PTabEntity *data = self.data;
    
    return data.tabTwo;
}

-(NSString*)tabThree
{
    PTabEntity *data = self.data;
    
    return data.tabThree;
}
@end
