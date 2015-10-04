//
//  PShareTools.h
//  PlayDrama
//
//  Created by RHC on 15/4/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PShareToolsView : UIView

@property (nonatomic, weak  ) UIViewController *withController_;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic, strong) UIImage   *shareImageForPlates;

+(PShareToolsView *)initNib;
- (void)show;
- (void)dismiss;
@end
