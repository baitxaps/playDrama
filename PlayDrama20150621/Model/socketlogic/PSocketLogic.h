//
//  PSocketLogic.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/14.
//  Copyright (c) 2015年 times. All rights reserved.
//
//http://my.oschina.net/joanfen/blog/287238?p=3#comments

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};




@interface PSocketLogic : NSObject

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的port

//在PSocketLogic中声明一个定时器
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器

+ (PSocketLogic *)sharedInstance;

- (void)socketConnectHost;// socket连接
- (void)cutOffSocket;     // 断开socket连接
@end
