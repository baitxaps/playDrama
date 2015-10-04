//
//  GOMapNoDataView.h
//
//  Created by chenhairong on 14-7-29.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PNoDataViewBlock)(void);

@interface PNoDataView : UIView

/**
 *  添加没有数据界面
 *
 *  @param name 当 HaveAdd 为YES时可以添加显示的内容；添加 tapAction回调，支持点击事件
 *  @param fg   为YES时，支持自定义显示内容和点击事件
 */
- (void)createNoDataView:(NSString *)name HaveAdd:(BOOL)fg;

- (void)createNoDataViewWithTip:(NSString *)tip btnTitle:(NSString *)btnTitle;

/**
 *  无数据时的提示界面新样式
 *
 *  @param tip      提示内容
 *  @param btnTitle 按钮标题
 */
- (void)createNoDataBGViewWithTip:(NSString *)tip
                         btnTitle:(NSString *)btnTitle;

/**
 *  添加点击回调事件
 *
 *  @param block 回调
 */
- (void) tapAction:(PNoDataViewBlock) block;
@end
