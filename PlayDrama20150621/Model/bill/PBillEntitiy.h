//
//  PBillEntitiy.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBillEntitiy : NSObject
@property (nonatomic, copy) NSString        *dramaImgUrl;      //剧集图片url
@property (nonatomic, copy) NSString        *dramaContent;     //剧集内容
@property (nonatomic, copy) NSString        *billTypeName;     //剧集类型（下季提要，角色介绍）
@property (nonatomic, copy) NSString        *billTypeImageUrl; //剧集类型 图
@property (nonatomic, copy) NSString        *dramaRoleText;    //角色介绍
@property (nonatomic, copy) NSString        *dramaRoleName;    //角色姓名:医生
@property (nonatomic, copy) NSMutableArray  *datas;            //柱状图人员个数
@property (nonatomic, copy) NSMutableArray  *colors;            //颜色数组
@property (nonatomic, assign)BOOL           isRole;            //是否是演员投票
@end
