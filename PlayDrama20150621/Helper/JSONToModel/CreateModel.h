//
//  CreateModel.h
//  WallPaper
//
//  Created by hairong.chen on 15/8/25.
//  Copyright (c) 2015年 times. All rights reserved.
//
/*
 *如果你还在手动写每一个model,亲,用这个可以解放你,而且,还会过滤掉null值......,
 *当然,你还可以把字典或者数组进一步替换成其他生成的model,提示已经写好了,就靠你自己的觉悟了.
 
 Method of use:
 // JSON数据(模拟的)
 NSDictionary *data = @{@"name"       : @"baitxaps",
 @"age"        : @(6),
 @"address"    : @[@"深圳", @"南山区"],
 @"infomation" : @{@"A" : @"B"}};
 
 // 创建文件
 [CreateModel createFileWithModelName:@"PeopleModel"
 dictionary:data];
 */


#import <Foundation/Foundation.h>

@interface CreateModel : NSObject

/**
 *  文件名字
 */
@property (nonatomic, strong) NSString      *modelName;

/**
 *  输入的字典
 */
@property (nonatomic, strong) NSDictionary  *inputDictionary;

/**
 *  创建出model
 */
- (void)createModel;

/**
 *  便利的创建model的方法
 *
 *  @param modelName  model的名字
 *  @param dictionary 输入的字典
 */
+ (void)createFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary;

@end
