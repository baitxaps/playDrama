//
//  PCountDownButton.h
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCountDownButton : UIButton

@property (nonatomic,strong) UILabel  *tileLabel;

- (void)setStartTitle:(NSString *)stl withTime:(NSTimeInterval)t endTitle:(NSString *)etl;
- (void)startCount;
@end
