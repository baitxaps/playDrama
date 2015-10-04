//
//  UIImage+DSP.h
//  PlayDrama
//
//  Created by RHC on 15/4/9.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DSP)
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)getImageInRect:(UIView *)shotView;

- (UIImage *)makeThumbnailByScale:(double)imageScale;
@end
