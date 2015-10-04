//
//  PTabAdapter.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTabAdapterProtocol.h"

@interface PTabAdapter : NSObject<PTabAdapterProtocol>

/**
 *  输入对象
 */
@property (nonatomic, strong) id data;

/**
 *  与输入对象建立联系
 *
 *  @param data 输入的对象
 *
 *  @return 实例对象
 */
- (instancetype)initWithData:(id)data;
@end
