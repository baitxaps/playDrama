//
//  PDramaEntity.m
//  PlayDrama
//
//  Created by chenhairong on 15/3/19.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PDramaEntity.h"
#import "PNetWorkRequest.h"
#import "PConfig.h"

@implementation PDramaEntity

+ (void)fetchDataWithName:(NSString *)name
                      sex:(NSString *)sex
                  success:(void(^)(NSDictionary * dict))success
                  failure:(void(^)(NSError *error))failure
{
    NSDictionary *dict = @{@"name":name,@"sex":sex};
    [PNetWorkRequest httpGETWithPath:@"http://www.baiduc.com" parameters:dict success:^(NSDictionary *dict) {
        if (success) {
            success(dict);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)fetchDataWithFilm:(NSString *)name
                      sex:(NSString *)sex
                  success:(void(^)(NSArray * dict))success
                  failure:(void(^)(NSError *error))failure
{
    NSDictionary *dict = @{@"name":name,@"sex":sex};
    [PNetWorkRequest httpGETWithPath:@"http://www.baiduc.com" parameters:dict success:^(NSDictionary *dict) {
        if (success) {
            success(nil);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
