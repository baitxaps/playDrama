//
//  PNetWorkRequest.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface PNetWorkRequest : NSObject

@property(nonatomic ,strong) NSURL* url;
@property(nonatomic , copy)  NSString* (^cachePath)(void);
@property(nonatomic ,strong) AFHTTPRequestOperation* requestOperation;
@property(nonatomic , copy)  void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);



+ (PNetWorkRequest *) getInstance;

-(void)downloadWithUrl:(id)url
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  GET请求
 *
 *  @param path    请求的URL
 *  @param paraDic 请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)httpGETWithPath:(NSString *)path
             parameters:(NSDictionary *)paraDic
                success:(void (^)(NSDictionary *dict))success
                failure:(void (^)(NSError *error ))failure;

/**
 *  POST请求
 *
 *  @param path    请求的URL
 *  @param paraDic 请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)httpPOSTWithPath:(NSString *)path
              parameters:(NSDictionary *)paraDic
                 success:(void (^)(NSDictionary *dict))success
                 failure:(void (^)(NSError *error ))failure;


+ (void)httpMultiPOSTWithPath:(NSString *)path
                     filePath:(NSString *)filePath
                   parameters:(NSDictionary *)paraDic
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error ))failure;

@end
