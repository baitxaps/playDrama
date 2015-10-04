//
//  PTabAdapterProtocol.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTabAdapterProtocol <NSObject>
- (UIColor *)buttonTintColor;
- (UIColor *)backgroundColor;
- (NSString *)tabOne;
- (NSString *)tabTwo;
- (NSString *)tabThree;
@end
