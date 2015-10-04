//
//  GCDTimer.h
//  GCD
//
//
//  Created by hairong.chen on 15/7/21.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDQueue;

@interface GCDTimer : NSObject

@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initInQueue:(GCDQueue *)queue;

#pragma 用法
- (void)event:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)start;
- (void)destroy;


@end
