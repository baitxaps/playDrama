//
//  PEnums.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#ifndef PlayDrama_PEnums_h
#define PlayDrama_PEnums_h

typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeNetworkError               = 404,
    ErrorTypeFailedConfigReopenError    = 405,
    ErrorTypeUnknowError                = 500,
    
    ErrorTypeVerifyFailed               = 110101,
    ErrorTypeAlreadyRegistered          = 110001,
    ErrorTypeErrorUsernameOrPassword    = 100001,
    ErrorTypeErrorUsernameNotExist      = 100002,
    ErrorTypeErrorHavenotRegistered     = 110002,
    ErrorTypeErrorZoneErr               = 40000,
    ErrorTypeErrorVersionErr            = 40001,
    ErrorTypeErrorParametersInvalid     = 40011,
    
    ErrorTypeErrorStaryThanEndTime     = 10002,
    ErrorTypeErrorEventsCycleTime      = 100400,
    ErrorTypeErrorAcitvityAbnormal     = 100401,
    ErrorTypeErrorActivityOutdated     = 100402,
    ErrorTypeErrorActivityMustBeCar    = 100403,
    ErrorTypeErrorGroupMembersOnly     = 100404,
    ErrorTypeErrorGroupAuthority       = 100405,
    ErrorTypeErrorOperatorNotLeader    = 100406,
    ErrorTypeErrorActivityIdNotAllow   = 100407,
    ErrorTypeErrorActivityTypeNotAllow = 100408,
    ErrorTypeErrorActivityRangeNotAllow= 100409,
    ErrorTypeErrorActivityIfNotCar     = 100410,
    ErrorTypeErrorActivityHasApply     = 100411,
    ErrorTypeErrorActivityHasCancel    = 100412,
    ErrorTypeErrorActivityNoCarNo      = 100413,
    ErrorTypeErrorActivityDelete       = 100414
};


#pragma mark - login NSEnum

typedef NS_ENUM(NSInteger, thirdpartyLoginType) {
    thirdpartyLoginTypeWX = 1,
    thirdpartyLoginTypeQQ,
    thirdpartyLoginTypeSina,
};


#pragma mark - share NSEnum
//typedef NS_ENUM(NSUInteger, PShareType) {
//    PShareTypeSina                      = 100,       //新浪 share
//    PShareTypeQQFriends                 = 101,       //qq 好友
//    PShareTypeQQZone                    = 102,       //qq zone
//    PShareTypeWechatCricelOfFriends     = 103,       //wechat CricelOfFriends
//    PShareTypeWechatFriends             = 104        //wechat friend share
//};
//
//#pragma mark - PBottomBarType NSEnum
typedef NS_ENUM(NSInteger, PBottomBarType) {
     PBottomBarTypeLike  ,        //like
     PBottomBarTypeCollection,   //collection
     PBottomBarTypeForwarding,   //forwarding
};



#pragma mark - PBottomBarType NSEnum
typedef NS_ENUM(NSInteger, PDramaSectionType) {
    PDramaSectionTypeDetail,        //影片详情
    PDramaSectionTypeComments,      //影片评论
    PDramaSectionTypeSection        //影片章节
};

typedef NS_ENUM(NSInteger, BottomKindType) {
    PDramaKindOfType,   //影片详情类型
    PJoyKindOfType,     //商品详情类型
    PBeautyStarInfoType,//玩美明星详情类型
   // ...
};

// 明星详情类型
typedef NS_ENUM(NSInteger, TabInformationType) {
    StarInformationTypeResumeType,   //resume类型
    StarInformationTypeLeaveAMSGType,//留言类型
    StarInformationTypePresentType,  //present类型
};

#define MP4_1   @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
#define MP4_2   @"http://www.qeebu.com/newe/Public/Attachment/99/52958fdb45565.mp4"
#define MP4_3   @"http://www.wowza.com/_h264/BigBuckBunny_175k.mov"
#define MP4_4   @"http://221.204.189.54:80/play/0F7758AF15BD3895E07E360C34B95AB42E631487.mp4"
#define MP4_5   @"http://123.134.67.198:80/play/BFD75E46DE50B2D8BBD810F259B2CC892DE9F690.mp4"
#define MP4_6   @"http://123.134.67.201:80/play/BEDF14F6FF4FF604DCCB053EEE20536EB33EFC37.mp4"
#define MP4_7   @"http://58.244.255.12/play/82846AEB3B80981E4A674374C05B3F771144D3AF/1074654_smooth.mp4"
#define MP4_8   @"http://krtv.qiniudn.com/150522nextapp"
#define MP4_9   @"http://123.134.67.197:80/play/4B07614CBE84228E2645AC9F14C4BABFC5E6F0E1.mp4"
#define MP4_10  @"http://7xj7y3.com1.z0.glb.clouddn.com/test.mp4"
#define MP4_11  @"http://ws.v.chuanke.com/vedio/c/8e/d7/c8ed78bcd1f3e699e6e05ffaae607735.mp4"

#endif
