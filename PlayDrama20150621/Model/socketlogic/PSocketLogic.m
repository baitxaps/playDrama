//
//  PSocketLogic.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/14.
//  Copyright (c) 2015年 times. All rights reserved.
//

//#import <sys/socket.h>
//#import <netinet/in.h>
//#import <arpa/inet.h>
//#import <unistd.h>

#import "PSocketLogic.h"

@interface PSocketLogic()<AsyncSocketDelegate>

@end

@implementation PSocketLogic

+(PSocketLogic *) sharedInstance
{
    static PSocketLogic *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

// socket连接
-(void)socketConnectHost
{
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    
}

// 连接成功回调
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString  *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    
    // 每隔30s像服务器发送心跳包
    // 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                         target:self
                                                       selector:@selector(longConnectToSocket)
                                                       userInfo:nil
                                                        repeats:YES];
    
    [self.connectTimer fire];
}

// 切断socket
-(void)cutOffSocket
{
    // 声明是由用户主动切断
    self.socket.userData = SocketOfflineByUser;
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}


- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    PDebugLog(@"The Socket is connectting state: %ld",sock.userData);
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}

// 心跳连接
-(void)longConnectToSocket
{
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    
    NSString *longConnect = @"longConnect";
    
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送命令，Data由包拼接
    //[client writeData:mutableData withTimeout:-1 tag:0];
    [self.socket writeData:dataStream withTimeout:1 tag:1];
    
}

//为了能时刻接收到socket的消息，我们在长连接方法中进行读取数据
//返回收到数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    [self.socket readDataWithTimeout:30 tag:0];
    
    //对data进行解包
}

@end
