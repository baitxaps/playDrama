//
//  PBottomAdapterProtocol.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBottomAdapterProtocol <NSObject>

- (UIImage *)bottomTabOneImage;
- (UIImage *)bottomTabTwoImage;
- (UIImage *)bottomTabThreeImage;
- (UIColor *)backGroudColor;

@optional

- (UIImage *)bottomTabOneSelectedImage;
- (UIImage *)bottomTabTwoSelectedImage;
- (UIImage *)bottomTabThreeSelectedImage;

@end
