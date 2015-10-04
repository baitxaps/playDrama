//
//  UIView+Draw.h
//  PlayDrama
//
//  Created by RHC on 15/4/10.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draw)
- (UIView *)drawBounderWidth:(CGFloat)width Color:(UIColor *)color;
- (UIView *)drawBounderWidth:(CGFloat)width
                      radius:(CGFloat)radius
                       Color:(CGColorRef )color;

- (UIView *)drawBounderWidth:(CGFloat)width
                       Color:(UIColor *)color
                      radius:(CGFloat)radius;

- (UIView *)drawViewShadowWithOffset:(CGFloat)offset
                             radilus:(CGFloat)radius
                               color:(UIColor *)color;

- (void)textFieldPlaceholder:(UIView*)view textWithFont:(CGFloat)font;

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
- (void)setDefaultAnchorPointforView:(UIView *)view;
- (void)correctAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gr;
@end


@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@interface UIImage (Blur)

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;

@end


