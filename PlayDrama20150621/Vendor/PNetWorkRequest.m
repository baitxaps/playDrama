//
//  PNetWorkRequest.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PNetWorkRequest.h"
#import "AFNetworking.h"


@implementation PNetWorkRequest


+ (PNetWorkRequest *) getInstance {
    static dispatch_once_t pred = 0;
    __strong static PNetWorkRequest *object = nil;
    
    dispatch_once(&pred, ^{
        object = [[PNetWorkRequest alloc] init];
    });
    return object;
}


+ (void)httpGETWithPath:(NSString *)path
             parameters:(NSDictionary *)paraDic
                success:(void (^)(NSDictionary *dict))success
                failure:(void (^)(NSError *error ))failure
{
    if ([PNetWorkRequest checkStringInvalid:path]) {
        if (failure) {
            PDebugLog(@"%s path is nil.", __FUNCTION__);
            
            NSError *err = [NSError errorWithDomain:PLAY_BASE_URL_STR code:1001 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"GO_Base_NetworkError", nil)}];
            failure(err);
        }
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PDebugLog(@"JSON: %@", responseObject);
        [[self class] parseResult:responseObject success:success failure:failure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PDebugLog(@"Error: %@", error);
        if (failure && (![operation isCancelled])) {
            failure([NSError networkError]);
        }
        
    }];
    
}



+ (void)httpPOSTWithPath:(NSString *)path
              parameters:(NSDictionary *)paraDic
                 success:(void (^)(NSDictionary *dict))success
                 failure:(void (^)(NSError *error ))failure
{
    if ([PNetWorkRequest checkStringInvalid:path]) {
        if (failure) {
            PDebugLog(@"%s path is nil.", __FUNCTION__);
            
            NSError *err = [NSError errorWithDomain:PLAY_BASE_URL_STR code:1002 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"GO_Base_NetworkError", nil)}];
            failure(err);
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[self class] parseResult:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure && (![operation isCancelled])) {
            failure([NSError networkError]);
        }
    }];
}


//Post Multi-Part Request
+ (void)httpMultiPOSTWithPath:(NSString *)path
                     filePath:(NSString *)filePath
                   parameters:(NSDictionary *)paraDic
                      success:(void (^)(NSDictionary *dict))success
                      failure:(void (^)(NSError *error ))failure
{
    if ([self checkStringInvalid:path]) {
        if (failure) {
            PDebugLog(@"%s path is nil.", __FUNCTION__);
            
            NSError *err = [NSError errorWithDomain:PLAY_BASE_URL_STR code:1004 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"GO_Base_NetworkError", nil)}];
            failure(err);
        }
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [manager POST:path parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:fileUrl name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PDebugLog(@"Success: %@", responseObject);
        [[self class] parseResult:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PDebugLog(@"Error: %@", error);
        if (error) {
            failure([NSError networkError]);
        }
    }];
}

#pragma mark - private method
+ (void) parseResult:(id)responseObject
             success:(void (^)(NSDictionary *dict))success
             failure:(void (^)(NSError *error ))failure {
    
#if DEBUG
    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    PDebugLog(@"Request responseObject: %@",str);
#endif
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    if ((!dic) || (![dic isKindOfClass:[NSDictionary class]])) {
        if (failure) {
            failure([NSError unknowError]);
        }
        return;
    }
    
    NSString *code = [dic objectForKey:@"code"];
    
    // 如果有认为非零成功的再次考虑扩展
    if (![code intValue]) {
        if (success) {
            success(dic);
        }
    }
    else {
        if (failure) {
            NSString *msgString = [dic objectForKey:@"msg"];
            PDebugLog(@"%s, debug_msg:%@",__FUNCTION__, [dic objectForKey:@"debug_msg"]);
            NSError *error = [NSError errorWithMsg:([msgString isEqual:[NSNull null]] ? @"" : msgString)
                                              code:[code intValue]];
            failure(error);
        }
    }
}

+ (BOOL) checkStringInvalid: (NSString *)param {
    if ((!param) ||
        ([param isEqual:[NSNull null]]) ||
        (0 == param.length) ||
        ([param isEqualToString:@"<null>"]) ||
        ([param isEqualToString:@"(null)"])) {
        return YES;
    }
    
    return NO;
}


-(void)downloadWithUrl:(id)url
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    self.cachePath = cacheBlock;
    //获取缓存的长度
    long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
    
    NSLog(@"cacheLength = %llu",cacheLength);
    
    //获取请求
    NSMutableURLRequest* request = [[self class] requestWithUrl:url Range:cacheLength];
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.requestOperation setOutputStream:[NSOutputStream outputStreamToFileAtPath:self.cachePath() append:NO]];
    
    //处理流
    [self readCacheToOutStreamWithPath:self.cachePath()];
    [self.requestOperation addObserver:self forKeyPath:@"isPaused" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //获取进度块
    self.progressBlock = progressBlock;
    
    //重组进度block
    [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    
    //获取成功回调块
    void (^newSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"responseHead = %@",[operation.response allHeaderFields]);
        
        success(operation,responseObject);
    };
    [self.requestOperation setCompletionBlockWithSuccess:newSuccess
                                                 failure:failure];
    [self.requestOperation start];
}



#pragma mark - 获取本地缓存的字节
+(long long)cacheFileWithPath:(NSString*)path
{
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* contentData = [fh readDataToEndOfFile];
    return contentData ? contentData.length : 0;
}


#pragma mark - 重组进度块
-(void(^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))getNewProgressBlockWithCacheLength:(long long)cachLength
{
   //typeof(self)newSelf = self;
    WS(weafSelf);
    void(^newProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        NSData* data = [NSData dataWithContentsOfFile:weafSelf.cachePath()];
        [weafSelf.requestOperation setValue:data forKey:@"responseData"];
        // self.requestOperation.responseData = ;
        weafSelf.progressBlock(bytesRead,totalBytesRead + cachLength,totalBytesExpectedToRead + cachLength);
    };
    
    return newProgressBlock;
}


#pragma mark - 读取本地缓存入流
-(void)readCacheToOutStreamWithPath:(NSString*)path
{
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* currentData = [fh readDataToEndOfFile];
    
    if (currentData.length) {
        //打开流，写入data ， 未打卡查看 streamCode = NSStreamStatusNotOpen
        [self.requestOperation.outputStream open];
        
        NSInteger       bytesWritten;
        NSInteger       bytesWrittenSoFar;
        
        NSInteger  dataLength = [currentData length];
        const uint8_t * dataBytes  = [currentData bytes];
        
        bytesWrittenSoFar = 0;
        do {
            bytesWritten = [self.requestOperation.outputStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
            assert(bytesWritten != 0);
            if (bytesWritten == -1) {
                break;
            } else {
                bytesWrittenSoFar += bytesWritten;
            }
        } while (bytesWrittenSoFar != dataLength);
    }
}

#pragma mark - 获取请求

+(NSMutableURLRequest*)requestWithUrl:(id)url Range:(long long)length
{
    NSURL* requestUrl = [url isKindOfClass:[NSURL class]] ? url : [NSURL URLWithString:url];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:5*60];
    if (length) {
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",length] forHTTPHeaderField:@"Range"];
    }
    NSLog(@"request.head = %@",request.allHTTPHeaderFields);
    
    return request;
}



#pragma mark - 监听暂停
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keypath = %@ changeDic = %@",keyPath,change);
    //暂停状态
    if ([keyPath isEqualToString:@"isPaused"] && [[change objectForKey:@"new"] intValue] == 1) {

        long long cacheLength = [[self class] cacheFileWithPath:self.cachePath()];
        //暂停读取data 从文件中获取到NSNumber
        cacheLength = [[self.requestOperation.outputStream propertyForKey:NSStreamFileCurrentOffsetKey] unsignedLongLongValue];
        NSLog(@"cacheLength = %lld",cacheLength);
        [self.requestOperation setValue:@"0" forKey:@"totalBytesRead"];
        //重组进度block
        [self.requestOperation setDownloadProgressBlock:[self getNewProgressBlockWithCacheLength:cacheLength]];
    }
}



@end
