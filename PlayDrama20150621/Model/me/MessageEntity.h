//
//  MessageEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageEntity : NSObject

@property (nonatomic,assign,readonly) CGRect    rtLabelViewRect;
@property (nonatomic,strong )         NSString  *msg;

+ (instancetype)GroupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithString:(NSString *)string;
@end
