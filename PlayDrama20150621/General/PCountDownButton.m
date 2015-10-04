//
//  PCountDownButton.m
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PCountDownButton.h"

@interface PCountDownButton()
{
    NSTimer         *_timer;
    NSTimeInterval  _countTime;
    NSTimeInterval  _count;
    
    NSString        *_startStr;
    NSString        *_endStr;
    
}
@end

@implementation PCountDownButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    _tileLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 51, 200, 21)];
    _tileLabel.textAlignment    = NSTextAlignmentCenter;
    _tileLabel.textColor        =  [UIColor whiteColor];
    _tileLabel.backgroundColor  = [UIColor clearColor];
    _tileLabel.font             = [UIFont systemFontOfSize:13.0];
    [self addSubview:_tileLabel];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _tileLabel.frame =  CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height - 12);
    _tileLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setStartTitle:(NSString *)stl withTime:(NSTimeInterval)t endTitle:(NSString *)etl
{
    _startStr   = nil;
    _startStr   = [stl copy];
    _endStr     = nil;
    _endStr     = [etl copy];
    _countTime  = t;
    _tileLabel.text = NSLocalizedString(@"获取验证码", nil);
//   [self addTarget:self action:@selector(startCount) forControlEvents:UIControlEventTouchUpInside];
//    _tileLabel.text = [NSString stringWithFormat:_endStr,_countTime] ;
}

- (void)startCount
{
    self.enabled = NO;
    _count = _countTime;
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(countDown)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}

- (void)countDown
{
    --_count;
    if (_count <= 0){
        [_timer invalidate];
        self.enabled = YES;
        _tileLabel.text = NSLocalizedString(@"重新获取验证码", nil);
    }
    else{
        _tileLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%0.f秒后重新获取", nil),_count] ;
    }
}


@end
