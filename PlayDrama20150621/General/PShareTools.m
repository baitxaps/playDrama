//
//  PShareTools.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PShareTools.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UIImage+DSP.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "PLoginViewController.h"

@interface PShareTools()<WXApiDelegate, WeiboSDKDelegate, TencentSessionDelegate,WBHttpRequestDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSMutableArray *permissions;
@end

@implementation PShareTools

/*------------微信登录较为特殊 需要先得到授权取到code，再通过code取到access_token和openid------------*/
/*授权后接口调用
 接口说明
 通过code获取access_token的接口。
 http请求方式: GET
 参数说明
 参数	是否必须	说明
 appid	是	应用唯一标识，在微信开放平台提交应用审核通过后获得
 secret	是	应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
 code	是	填写第一步获取的code参数
 grant_type	是	填authorization_code*/
#define WX_GET_ACCESS_TOKEN  @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

/*------------刷新或续期access_token使用------------*/
/*接口说明
 access_token是调用授权关系接口的调用凭证，由于access_token有效期（目前为2个小时）较短，当access_token超时后，可以使用refresh_token进行刷新，access_token刷新结果有两种：
 1.若access_token已超时，那么进行refresh_token会获取一个新的access_token，新的超时时间；
 2.若access_token未超时，那么进行refresh_token不会改变access_token，但超时时间会刷新，相当于续期access_token。
 refresh_token拥有较长的有效期（30天），当refresh_token失效的后，需要用户重新授权。
 请求方法
 使用/sns/oauth2/access_token接口获取到的refresh_token进行以下接口调用：
 http请求方式: GET
 参数说明
 参数	是否必须	说明
 appid	是	应用唯一标识
 grant_type	是	填refresh_token
 refresh_token	是	填写通过access_token获取到的refresh_token参数*/
#define WX_GET_REFRESH_ACCESS_TOKEN  @" https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@"


static PShareTools *_sharedInstance = nil;
+ (id)sharedInstance
{
    if (!_sharedInstance){
        _sharedInstance = [[PShareTools alloc] init];
        
        [WXApi registerApp:APP_ID_FOR_WECHAT withDescription:@"weixin"];//注册微信
        _sharedInstance.tencentOAuth = (TencentOAuth *)[[TencentOAuth alloc] initWithAppId:APP_ID_FOR_QQ andDelegate:_sharedInstance];//注册QQ
        [WeiboSDK registerApp:APP_ID_FOR_SINA_WEIBO];//注册新浪微博
    }
    
    return _sharedInstance;
}

+ (void)destory
{
    if (_sharedInstance) {
        _sharedInstance = nil;
    }
}

- (BOOL)handleApplicationOpenURL:(NSURL *)url;
{
    if ([[url scheme] isEqualToString:APP_ID_FOR_WECHAT])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([[url scheme] isEqualToString:SINA_WEIBO_URL_SCHEME])
    {
        return [WeiboSDK handleOpenURL:url delegate:self ];
    }
    else if ([[url scheme] isEqualToString:QQ_URL_SCHEME])
    {
        PDebugLog(@"%d", [TencentOAuth HandleOpenURL:url]);
        return [TencentOAuth HandleOpenURL:url];
    }
    return NO;
}



- (void)loginWithPlatformWithType:(LoginPlatFormType)type {
    switch (type) {
        case LoginPlatFormTypeWX:
            [self loginWithWechat];
            break;
            
        case LoginPlatFormTypeQQ:
            [self loginWithQQ];
            break;
            
        case LoginPlatFormTypeSinaWeibo:
            [self loginWithSinaWeibo];
            break;
            
        default:
            PDebugLog(@"Not supported yet!");
            break;
    }
}
- (void)loginWithSinaWeibo {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_WEIBO_REDIR_URI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)loginWithWechat
{
    PDebugLog(@"%@", NSStringFromSelector(_cmd));
    if ([WXApi isWXAppInstalled]) {
        if ([WXApi isWXAppSupportApi]) {
            SendAuthReq* req =[[SendAuthReq alloc ] init];
            //req.scope = @"snsapi_userinfo,snsapi_base";
            req.scope = @"snsapi_userinfo";
            //req.state = @"0744" ;
            req.state = @"none" ;
            [WXApi sendReq:req];
        }else{
            //当前微信版本不支持
            [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"当前微信版本不支持", nil)];
        }
        
    }else{
        //没有安装微信
        [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"您还没有安装微信，无法授权登录", nil)];
    }
    
    
}
- (void)loginWithQQ
{
    if ([TencentOAuth iphoneQQInstalled]) {
        if ([TencentOAuth iphoneQQSupportSSOLogin]) {
            _permissions = [NSMutableArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
            
            [self.tencentOAuth authorize:_permissions inSafari:NO];
        }else{
            //当前手机qq不支持sso登录
            [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"当前手机qq不支持sso登录", nil)];
        }
        
    }else{
        //当前手机没有安装手机qq
        [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"当前手机没有安装手机qq,无法授权登录", nil)];
    }
}


//登录回调----是否成功（与登录相关）
#pragma mark - TencentSessionDelegate -
- (void)tencentDidLogin
{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]) {
        self.userID = self.tencentOAuth.openId;
        self.userToken = self.tencentOAuth.accessToken;
        PDebugLog(@"accessToken: %@, openID: %@", self.tencentOAuth.accessToken, self.tencentOAuth.openId);
        [[PLoginViewController sharedInstance] thirdLoginSeverWithTpye:thirdpartyLoginTypeQQ openId:self.userID accessToken:self.userToken];
    }
    else {
        //登录不成功 没有获取accesstoken
        [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"登录不成功，没有获取到accesstoken", nil)];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        //取消qq登录
        [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"取消qq登录", nil)];
        return;
    }
    //登录失败
    [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"登录失败", nil)];
    
}

- (void)tencentDidNotNetWork
{
    //网络连接不成功
    [[PLoginViewController sharedInstance] showAlertWithTitle:nil message:NSLocalizedString(@"网络连接不成功", nil)];
}


#pragma mark - WeiboSDKDelegate -微博登陆授权回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        PDebugLog(@"WBProvideMessageForWeiboRequest");
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])//微博认证的响应
    {
        if (![(WBAuthorizeResponse *)response userID]) {
            return;
        }
        //认证结果  登录客户端
        [[PLoginViewController sharedInstance] thirdLoginSeverWithTpye:thirdpartyLoginTypeSina
                                                                   openId:[(WBAuthorizeResponse *)response userID]
                                                              accessToken:[(WBAuthorizeResponse *)response accessToken]];
    }
}


#pragma mark - WXApiDelegate Method

- (void)onReq:(BaseReq *)req
{
    PDebugLog(@"onReq,req = %@", req);
}

//分享后----回调的结果
- (void)onResp:(BaseResp *)resp
{
    PDebugLog(@"onResp, resp = %@", resp);
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) // QQ分享
    {
        SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
        if ([sendResp.result isEqualToString:@"0"])
        {
            if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)])
            {
                // [_delegate shareContentToPlatformCompletion:ShareToPlatFormResultSuccess errorCode:0];
                [_delegate shareContentToPlatformCompletion:SharePlatFormTypeQQFriend platformResult:ShareToPlatFormResultSuccess errorCode:0];
            }
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)])
            {
                // [_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotKnown];
                [_delegate shareContentToPlatformCompletion:SharePlatFormTypeQQFriend platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotKnown];
                
            }
        }
        return;
    }
    
    if (resp.errCode == WXSuccess) // 成功
    {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            //登录授权
            SendAuthResp *aresp = (SendAuthResp *)resp;
            NSString *code = aresp.code;
            [self getAccessToken:code]; //Get token
        } else {
            //分享
            if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
                
                [_delegate shareContentToPlatformCompletion:SharePlatFormTypeWXSession platformResult:ShareToPlatFormResultSuccess errorCode:0];
            }
        }
    }
    else if (resp.errCode == WXErrCodeUserCancel)//用户取消
    {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            //[_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorUserCanceled];
            [_delegate shareContentToPlatformCompletion:SharePlatFormTypeWXSession platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorUserCanceled];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            //[_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotKnown];
            [_delegate shareContentToPlatformCompletion:SharePlatFormTypeWXSession platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotKnown];
        }
    }
}
//微信授权--通过code获取access_token的接口
- (void)getAccessToken:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:WX_GET_ACCESS_TOKEN,APP_ID_FOR_WECHAT, APP_KEY_FOR_WECHAT, code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *access_token = dic[@"access_token"];
                NSString *openid = dic[@"openid"];
                //NSString *refresh_token = dic[@"refresh_token"];
                //登录
                [[PLoginViewController sharedInstance] thirdLoginSeverWithTpye:thirdpartyLoginTypeWX openId:openid accessToken:access_token];
                
            }
        });
    });
}


#pragma mark - Helper methods

//分享QQ后回调的错误结果
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    if (sendResult != EQQAPISENDSUCESS) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            [_delegate shareContentToPlatformCompletion:SharePlatFormTypeQQFriend platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorParametersInvalid];
        }
    }
}

#pragma mark -- 分享
- (void)shareContentToPlatFormWithType:(SharePlatFormType)type
                                 bText:(BOOL)bText
                                 title:(NSString *)title
                           description:(NSString *)description
                                 image:(UIImage *)image
                            webpageUrl:(NSString *)urlString
                              delegate:(id<PShareToolDeleage>)delegate
{
    _delegate = delegate;
    
    if (type == SharePlatFormTypeWXSession || type == SharePlatFormTypeWXTimeline)
    {
        [self shareToWeiXinWithType:type bText:bText title:title description:description image:image webpageUrl:urlString];
    }
    else if (type == SharePlatFormTypeQQFriend || type == SharePlatFormTypeQQZone)
    {
        [self shareToQQWithType:type title:title description:description image:image webpageUrl:urlString];
    }
}


#pragma mark - WXPlatForm

- (void)shareToWeiXinWithType:(SharePlatFormType)type
                        bText:(BOOL)bText
                        title:(NSString *)title
                  description:(NSString *)description
                        image:(UIImage *)image
                   webpageUrl:(NSString *)urlString
{   //未安装时---错误回调。如果已安装，直接往下走
    if (![WXApi isWXAppInstalled]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            //[_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotInstalled];
            [_delegate shareContentToPlatformCompletion:type platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotInstalled];
        }
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            //[_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotSupported];
            [_delegate shareContentToPlatformCompletion:type platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotSupported];
        }
        return;
    }
    
    if (!bText) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData.length >= 31800) { // 压缩处理，缩略图大小不能超过32K
            CGFloat compressionQuality = 0.5;
            UIImage *thumb = [image makeThumbnailByScale:compressionQuality];
            imageData = UIImageJPEGRepresentation(thumb, compressionQuality);
            if (imageData.length >= 31000) {
                compressionQuality = 0;
                imageData = UIImageJPEGRepresentation(thumb, compressionQuality);
                if (imageData.length >= 31000) {
                    PDebugLog(@"imageData文件太大微信不支持，imageData.length = %lu", imageData.length);
                    return;
                }
            }
        }
        
        PDebugLog(@"imageData.length = %lu", imageData.length);
        [message setThumbData:imageData];
        
        if (urlString && [urlString length] > 0) {
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = urlString;
            message.mediaObject = ext;
        } else {
            WXImageObject *imageObject = [WXImageObject object];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            imageObject.imageData = imageData;
            message.mediaObject = imageObject;
        }
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = bText;
        if (type == SharePlatFormTypeWXTimeline) {
            req.scene = WXSceneTimeline;
        }
        
        BOOL result = [WXApi sendReq:req];
        if (!result) {
            PDebugLog(@"****Failed to send req to Wechat***");
        }
    }else{
        //纯文本
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = description;
        req.bText = bText;
        if (type == SharePlatFormTypeWXTimeline) {
            req.scene = WXSceneTimeline;
        }
        BOOL result = [WXApi sendReq:req];
        if (!result) {
            PDebugLog(@"****Failed to send req to Wechat***");
        }
        
    }
}


#pragma mark - QQPlatForm

- (void)shareToQQWithType:(SharePlatFormType)type
                    title:(NSString *)title
              description:(NSString *)description
                    image:(UIImage *)image
               webpageUrl:(NSString *)urlString
{
    if (![QQApiInterface isQQInstalled]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            [_delegate shareContentToPlatformCompletion:type platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotInstalled];
        }
        return;
    }
    
    if (![QQApiInterface isQQSupportApi]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            [_delegate shareContentToPlatformCompletion:type platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotSupported];
        }
        return;
    }
    
    SendMessageToQQReq *req = nil;
    if (urlString && [urlString length] > 0) {
        //分享新闻类型
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString]
                                                            title:title
                                                      description:description
                                                 previewImageData:UIImageJPEGRepresentation(image, kCGInterpolationDefault)];
        
        [newsObj setCflag:0];
        req = [SendMessageToQQReq reqWithContent:newsObj];
    } else if (image){
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSData *previewImageData = imageData;
        QQApiImageObject *imageObject = [[QQApiImageObject alloc] initWithData:imageData previewImageData:previewImageData title:title description:description];
        req = [SendMessageToQQReq reqWithContent:imageObject];
    }else{
        QQApiTextObject *textObject = [[QQApiTextObject alloc] initWithText:description];
        req = [SendMessageToQQReq reqWithContent:textObject];
    }
    
    QQApiSendResultCode sent = 0;
    if (type == SharePlatFormTypeQQFriend)
    {
        //分享到QQ
        sent = [QQApiInterface sendReq:req];
    }
    else
    {
        //分享到QZone 不支持纯图片分享
        if (urlString && [urlString length] > 0) {
            sent = [QQApiInterface SendReqToQZone:req];
        } else {
            sent = [QQApiInterface sendReq:req];
        }
    }
    
    [self handleSendResult:sent];
}

#pragma mark - Sina Weibo -
- (void)shareToSinaWeiboWithMsg: (NSString *)msg {
    if (![WeiboSDK isWeiboAppInstalled]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            // [_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotInstalled];
            [_delegate shareContentToPlatformCompletion:SharePlatFormTypeSinaWeibo platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotInstalled];
        }
        return;
    }
    
    if (![WeiboSDK isCanShareInWeiboAPP]) {
        if ([_delegate respondsToSelector:@selector(shareContentToPlatformCompletion:platformResult:errorCode:)]) {
            //[_delegate shareContentToPlatformCompletion:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotSupported];
            [_delegate shareContentToPlatformCompletion:SharePlatFormTypeSinaWeibo platformResult:ShareToPlatFormResultFailure errorCode:ShareToPlatFormErrorNotSupported];
        }
        return;
    }
    
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = msg;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage: message];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

@end
