//
//  PVoteView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

/*
 *投票Button
 */
#import <UIKit/UIKit.h>

@interface PVoteView : UIView

@property (nonatomic,copy) NSArray              *data;
@property (nonatomic,copy) NSArray              *colors;
@property (nonatomic,assign)id <PDramaDelegate> delegate;
+ (PVoteView *)initNib;

- (void)showAnimaitonDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        point:(CGPoint)point;

- (void)hideAnimationDuration:(NSTimeInterval)duration
                    animation:(BOOL)animation
                        point:(CGPoint)point;
@end
