//
//  UIImage+DSP.m
//  PlayDrama
//
//  Created by RHC on 15/4/9.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "UIImage+DSP.h"

@implementation UIImage (DSP)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



+ (UIImage *)getImageInRect:(UIView *)shotView
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(shotView.frame.size.width, shotView.frame.size.height), YES, 0.0f);  //NO，YES 控制是否透明
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)makeThumbnailByScale:(double)imageScale
{
    UIImage *thumbnail = nil;
    CGSize imageSize = CGSizeMake(self.size.width * imageScale, self.size.height * imageScale);
    if (self.size.width != imageSize.width || self.size.height != imageSize.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [self drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = self;
    }
    return thumbnail;
}


@end
