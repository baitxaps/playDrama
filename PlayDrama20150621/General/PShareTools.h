//
//  PShareTools.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SharePlatFormType) { // 第三方平台类型
    SharePlatFormTypeWXSession  =0,         // 微信聊天界面
    SharePlatFormTypeWXTimeline =1,         // 微信朋友圈
    SharePlatFormTypeQQFriend   =2,         // QQ好友
    SharePlatFormTypeQQZone     =3,         // QQ空间
    SharePlatFormTypeSinaWeibo  =4,         // 新浪微博
};


typedef NS_ENUM(NSInteger, LoginPlatFormType) { // 登录类型
    LoginPlatFormTypeSinaWeibo  = 100,       // 新浪微博
    LoginPlatFormTypeQQ         = 101,       // QQ
    LoginPlatFormTypeWX         = 102,       // 微信
    LoginPlatFormTypeSystem     = 103        // 系统登录
    
};

typedef NS_ENUM(NSInteger, ShareToPlatFormResult) { // 第三方平台类型
    ShareToPlatFormResultSuccess = 0,   // 成功
    ShareToPlatFormResultFailure        // 失败
};

typedef NS_ENUM(NSInteger, ShareToPlatFormError) { // 错误码
    ShareToPlatFormErrorNotInstalled = 1,   // 软件未安装
    ShareToPlatFormErrorNotSupported,       // 当前的软件版本不支持api接口
    ShareToPlatFormErrorNotKnown,           // 未知错误
    ShareToPlatFormErrorParametersInvalid,  // 参数无效
    ShareToPlatFormErrorUserCanceled,       // 用户取消
    ShareToPlatFormErrorTypeNotSupported    // 分享类型不支持
};


@protocol PShareToolDeleage <NSObject>
@optional
//错误回调
- (void)shareContentToPlatformCompletion:(SharePlatFormType)platform
                          platformResult:(ShareToPlatFormResult)result
                               errorCode:(ShareToPlatFormError)errorCode;
@end

@interface PShareTools : NSObject
@property (nonatomic, weak) id <PShareToolDeleage> delegate;
@property (nonatomic, strong) NSString              *userID;
@property (nonatomic, strong) NSString              *userToken;


+ (id)sharedInstance;
+ (void)destory;

// 处理应用程序的跳转---与登录相关，登录第三方后，第三方通过此回调给客户端结果--是否登录成功
- (BOOL)handleApplicationOpenURL:(NSURL *)url;

//分享入口
- (void)shareContentToPlatFormWithType:(SharePlatFormType)type
                                 bText:(BOOL)bText
                                 title:(NSString *)title
                           description:(NSString *)description
                                 image:(UIImage *)image
                            webpageUrl:(NSString *)urlString
                              delegate:(id<PShareToolDeleage>)delegate;

//登录入口
- (void)loginWithPlatformWithType:(LoginPlatFormType)type;

@end
