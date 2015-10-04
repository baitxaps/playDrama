//
//  PlayDrama

//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.

#define kStartLocation 20
#import <UIKit/UIKit.h>

@class PKeyBoardView;
@protocol PKeyBoardViewDelegate <NSObject>

-(void)keyBoardViewHide:(PKeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end

@interface PKeyBoardView : UIView
@property (nonatomic,strong) UITextView                 *msgTextView;
@property (nonatomic,strong) UILabel                    *placeHoderLabel;
@property (nonatomic,assign) id <PKeyBoardViewDelegate> delegate;

- (void)setInputBarViewResignFirstResponder;
- (void)setInputBarViewResignNoClearFirstResponder;
- (void)setKeyBoardOffsetGap:(int)gap; // 键盘弹出时，输入框位置微调
- (void)setTextPlaceholder:(NSString *)placeholder;
- (void)changeKeyBoard:(NSNotification *)aNotifacation;

- (void)registerNotification;
- (void)removeNotification;
@end
