//
//  PDramaEntity.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/19.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDramaEntity : NSObject

@property (nonatomic, strong) NSString *movieName;      //影片名
@property (nonatomic, strong) NSString *movieDist;      //影片地区：内地，海外
@property (nonatomic, strong) NSString *movieType;      //影片类型
@property (nonatomic, strong) NSString *movieYear;      //影片年份
@property (nonatomic, strong) NSString *moviePlayCount; //影片播放次数
@property (nonatomic, strong) NSString *movieDesc;      //影片描述
@property (nonatomic, assign) CGRect   movieDescFram;     //影片描述



+ (void)fetchDataWithName:(NSString *)name
                      sex:(NSString *)sex
                  success:(void(^)(NSDictionary *dict))success
                  failure:(void(^)(NSError *error))failure;

+ (void)fetchDataWithFilm:(NSString *)name
                      sex:(NSString *)sex
                  success:(void(^)(NSArray * dict))success
                  failure:(void(^)(NSError *error))failure;


@end
