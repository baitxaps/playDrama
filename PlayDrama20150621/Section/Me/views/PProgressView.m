//
//  PProgressView.m
//  CaptureTest
//
//  Created by hairong.chen on 15/8/31.
//  Copyright (c) 2015年 hairong.chen. All rights reserved.
//


#import "PProgressView.h"
@interface PProgressView ()

@property (nonatomic,strong) CALayer *progressLayer;
@property (nonatomic,assign) CGFloat  currentViewWidth;

@end

@implementation PProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *barView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 18)];
        barView.backgroundColor = BAR_BG_COLOR;
        [self addSubview:barView];
    
        //最短分割线
        UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(BAR_MIN_W-20, 0, 1, BAR_H)];
        intervalView.backgroundColor = [UIColor blackColor];
        [barView addSubview:intervalView];
        
        self.progressLayer       = [CALayer layer];
        self.progressLayer.frame = CGRectMake(0,0, 0, frame.size.height);
        self.progressLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:self.progressLayer];
        
        // 存储当前view的宽度值
        self.currentViewWidth = frame.size.width;
    }
    return self;
}

#pragma mark - 重写setter，getter方法
@synthesize progress =_progress;
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (progress <= 0) {
        self.progressLayer.frame =CGRectMake(0,0,0, self.frame.size.height);
    }else if (progress <=1) {
        self.progressLayer.frame =CGRectMake(0,0,
                                             progress *self.currentViewWidth,
                                             self.frame.size.height);
    }else {
        self.progressLayer.frame =CGRectMake(0,0, self.currentViewWidth,
                                             self.frame.size.height);
    }
}
- (CGFloat)progress {
    return _progress;
}

@synthesize layerColor =_layerColor;
- (void)setLayerColor:(UIColor *)layerColor {
    _layerColor = layerColor;
    self.progressLayer.backgroundColor = layerColor.CGColor;
}
- (UIColor *)layerColor {
    return _layerColor;
}

@end
