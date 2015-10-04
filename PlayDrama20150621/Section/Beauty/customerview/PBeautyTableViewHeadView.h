//
//  PBeautyTableViewHeadView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^StartInfoTypeBlock)(NSInteger index);

@interface PBeautyTableViewHeadView : UIView
+ (PBeautyTableViewHeadView *) initWithNib;

@property (copy,nonatomic)StartInfoTypeBlock startInfoTypeBlock;
@end
