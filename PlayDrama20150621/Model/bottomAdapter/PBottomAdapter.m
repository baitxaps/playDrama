//
//  PBottomAdaPter.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBottomAdapter.h"

@implementation PBottomAdapter : NSObject

- (instancetype)initWithData:(id)data {
    
    self = [super init];
    if (self) {
        
        self.data = data;
    }
    
    return self;
}


-(UIImage *)bottomTabOneImage
{
    return nil;
}

-(UIImage *)bottomTabTwoImage
{
    return nil;
    
}

-(UIImage *)bottomTabThreeImage
{
     return nil;
}

-(UIColor *)backGroudColor
{
   return nil;
}

-(UIImage *)bottomTabOneSelectedImage
{
    return nil;
}

-(UIImage *)bottomTabTwoSelectedImage
{
    return nil;
}

-(UIImage *)bottomTabThreeSelectedImage
{
    return nil;
}

@end
