//
//  PlayDramaDelegate.h
//  PlayDrama
//
//  Created by RHC on 15/4/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayDramaDelegate <NSObject>

@end

//the color of Navgation delegate
@protocol NavgationBackGroundColorDelegate <NSObject>
- (void)navgationBackGroundColorDelegate:(BOOL)isColor;
@end