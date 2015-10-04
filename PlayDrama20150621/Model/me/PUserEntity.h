//
//  PUserEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/14.
//  Copyright (c) 2015年 times. All rights reserved.
//
#define kDeviceTokenStorage @"DeviceTokenStorage"

#import <Foundation/Foundation.h>

@interface PUserEntity : NSObject<NSCoding>

@property (nonatomic, copy) NSString      *userName;  
@property (nonatomic, copy) NSString      *userId;    
@property (nonatomic, copy) NSString      *sex;       
@property (nonatomic, copy) NSString      *level;     
@property (nonatomic, copy) NSString      *faceUrl;
@property (nonatomic, copy) NSString      *deviceToken;
@property (nonatomic, copy) NSString      *token;

+ (PUserEntity *) sharedInstance;

- (void)updateWithLoginDict:(NSDictionary *)loginDic;

//+ (void)saveToken:(NSString *)token;
//
//+ (NSString *)deviceToken;

+ (void)deleteToken;
- (void)destroy;
- (NSString *)currentDeviceType;

@end
