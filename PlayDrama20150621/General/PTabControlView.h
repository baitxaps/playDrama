//
//  PBeautyTableViewHeadView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTabAdapterProtocol.h"

typedef void (^StartInfoTypeBlock)(NSInteger index);

@interface PTabControlView : UIView

@property (copy,nonatomic)StartInfoTypeBlock startInfoTypeBlock;

+ (PTabControlView *) initWithNib;
- (void)updateWithListType:(NSInteger)listType;
- (void)loadData:(id <PTabAdapterProtocol>)data;

@end
