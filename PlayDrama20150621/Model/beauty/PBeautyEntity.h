//
//  PBeautyEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/11.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBeautyEntity : NSObject

@property (nonatomic, copy) NSString        *castUrl;           //演员图片url
@property (nonatomic, copy) NSMutableArray  *castDatas;         //演员图片数组
@property (nonatomic, copy) NSString        *castName;          //演员名
@property (nonatomic, copy) NSString        *castJob;           //演员职务
@property (nonatomic, copy) NSString        *castBirth;         //演员生日
@property (nonatomic, copy) NSString        *castHoroscope;     //星座
@property (nonatomic, copy) NSMutableArray  *commentDatas;      //评论数组
@property (nonatomic, copy) NSMutableArray  *precentDatas;      //礼物数组

@end
