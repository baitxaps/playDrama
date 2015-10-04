//
//  PTabAdapter.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PTabAdapter.h"

@implementation PTabAdapter

- (instancetype)initWithData:(id)data {
    
    self = [super init];
    if (self) {
        
        self.data = data;
    }
    
    return self;
}



-(UIColor *)buttonTintColor
{
    return nil;
}

-(UIColor *)backgroundColor
{
    return nil;
}

-(NSString*)tabOne
{
    return nil;
}

-(NSString*)tabTwo
{
    return nil;
}

-(NSString*)tabThree
{
    return nil;
}

@end
