//
//  PShareTools.h
//  PlayDrama
//
//  Created by RHC on 15/4/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PShareToolsDelegate.h"
#import "PBottomAdapterProtocol.h"

@interface PCustomerBottomBar : UIView


@property (strong,nonatomic) UIColor           *color;
@property (assign,nonatomic) BottomKindType    kindType;
@property (assign,nonatomic) id<PShareToolsDelegate>delegate;

+ (PCustomerBottomBar *)initNib;
- (void)loadData:(id<PBottomAdapterProtocol>)data;

@end
