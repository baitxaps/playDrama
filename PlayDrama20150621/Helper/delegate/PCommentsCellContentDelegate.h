//
//  PComentsCellContentDelegate.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/13.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCommentsCellContentDelegate <NSObject>

@required
@property (nonatomic, assign) NSInteger uniqueId;       // 唯一id
@property (nonatomic, strong) NSString *fromUserId;     //发评论的用户id
@property (nonatomic, strong) NSString *fromUserName;   //发评论的用户名
@property (nonatomic, strong) NSString *fUserFaceUrl;   //发评论人的头像
@property (nonatomic, strong) NSString *toUserId;       //被评论的用户id
@property (nonatomic, strong) NSString *toUserName;     //被评论的用户名
@property (nonatomic, strong) NSString *tUserFaceUrl;   //被评论人的头像
@property (nonatomic, strong) NSString *content;        //评论内容
@property (nonatomic, strong) NSString *level;          //用户等级

@optional

@end
