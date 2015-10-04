//
//  PAuctionEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/14.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAuctionEntity : NSObject

@property (nonatomic, copy) NSString  *goodsName;         //拍卖物名
@property (nonatomic, copy) NSString  *goodsImageUrl;     //拍卖物图片url
@property (nonatomic, copy) NSString  *startTime;         //拍卖物开始时间
@property (nonatomic, copy) NSString  *maxPrice;          //拍卖物最高竞价
@property (nonatomic, copy) NSString  *initiatePrice;     //拍卖物初始价

@property (nonatomic,assign) BOOL     isExpand;
@end
