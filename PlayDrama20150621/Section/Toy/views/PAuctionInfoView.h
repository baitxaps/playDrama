//
//  PAuctionInfoView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/15.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAuctionInfoView : UIView
@property (nonatomic,strong)NSMutableArray *datas;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

+(PAuctionInfoView *)initNib;

//- (void)showAnimaitonDuration:(NSTimeInterval)duration
//                    animation:(BOOL)animation
//                        point:(CGPoint)point
//                   offsetSize:(CGSize)offsetSize;
//
//- (void)hideAnimationDuration:(NSTimeInterval)duration
//                    animation:(BOOL)animation;

@end
