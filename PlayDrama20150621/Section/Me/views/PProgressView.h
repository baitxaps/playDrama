//
//  PProgressView.h
//  CaptureTest
//
//  Created by hairong.chen on 15/8/31.
//  Copyright (c) 2015年 hairong.chen. All rights reserved.
//

#define BAR_BG_COLOR color(38, 38, 38, 1)
#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define BAR_H 18
#define BAR_MARGIN 2

#define BAR_BLUE_COLOR color(68, 214, 254, 1)
#define BAR_RED_COLOR color(224, 66, 39, 1)
#define BAR_BG_COLOR color(38, 38, 38, 1)

#define BAR_MIN_W 80


#define BG_COLOR color(11, 11, 11, 1)

#define INDICATOR_W 16
#define INDICATOR_H 22

#define TIMER_INTERVAL 1.0f

#import <UIKit/UIKit.h>

@interface PProgressView : UIView
@property (nonatomic,assign) CGFloat  progress;  // 进度参数（取值范围为 %0 ~ %100）
@property (nonatomic,strong) UIColor *layerColor;// 修改layer的颜色
@end
