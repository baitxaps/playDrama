//
//  Macro.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/12.
//  Copyright (c) 2015年 times. All rights reserved.
//

#ifndef PlayDrama_PConfig_h
#define PlayDrama_PConfig_h

#pragma mark - API URLs

#define APP_DEV_MODE            0

//(APP_DEV_MODE == 0)     //开发环境  各种调试地址
//(APP_DEV_MODE == 1)     //正式环境  用于发布

#define  DEVELOP_CONFIG_URL     @"http://118.123.21.72:8081/sbms/"
/*
 ticket = 746ccc8b9994cc1724ebe2884a627546;
 type = "ios_update";
 */
//@"http://www.sfshare.com.cn/service/getSystemConstant"


#define  G_GOLOAPPAREASPANISH      @"http://118.123.21.72:8081/sbms/"

#if (APP_DEV_MODE == 0)
#define SERVICE_CONFIG_URL     DEVELOP_CONFIG_URL
#elif  (APP_DEV_MODE == 1)
#define SERVICE_CONFIG_URL     G_GOLOAPPAREASPANISH
#endif

#define PLAY_BASE_URL_STR       @"http://116.6.96.154:8888"


#define UIScreenHeight      [UIScreen mainScreen].bounds.size.height
#define UIScreenWidth       [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE5          (568.0f==[UIScreen mainScreen].bounds.size.height)
#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_UP_IOS6          ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)


#pragma mark - 颜色 -
#define RGB(c,a)                [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGBAColor(R, G, B, A)   [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define LightGreenColor         [UIColor colorWithRed:2.0/255 green:147.0/255 blue:135.0/255 alpha:1.0]
#define kGrayBorderColor        [UIColor colorWithRed:198.0/255 green:198.0/255 blue:198.0/255 alpha:1.0]
#define kUnreadBgColor          RGBAColor(255.0,59.0,48.0,1)
#define LightBlackColor         [UIColor colorWithRed:34.0/255 green:34.0/255 blue:34.0/255 alpha:1.0]
#define LightGrayColor          [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1.0]
#define PNAVGATION_Font         [UIFont systemFontOfSize:19.0]
#define Drama_Content_Font      [UIFont systemFontOfSize:12.0]

#pragma mark - PlayDrama Color
#define FilmTextWhiteColor      RGB(0xffffff,1)
#define FilmViewBGColor         RGB(0x111010,0.7)

#pragma mark -the personal center
#define HeadBGColor             #d9552a
#define TableViewBGColor        #d0cfc6
#define TableCellTextColor      #212121


#pragma mark - DEbug Log

/******* GO DEBUG LOG ********/
#if DEBUG
#define PDebugLog(frmt, ...)   {NSLog((frmt), ##__VA_ARGS__);}

#ifdef USE_NSLOGGER
#define LoggerStream(level, ...)   LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Stream", level, __VA_ARGS__)
#define LoggerVideo(level,  ...)   LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Video",  level, __VA_ARGS__)
#define LoggerAudio(level,  ...)   LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Audio",  level, __VA_ARGS__)
#else
#define LoggerStream(level, ...)   NSLog(__VA_ARGS__)
#define LoggerVideo(level,  ...)   NSLog(__VA_ARGS__)
#define LoggerAudio(level,  ...)   NSLog(__VA_ARGS__)
#endif

#else
#define PDebugLog(frmt, ...)

#define LoggerStream(...)           while(0) {}
#define LoggerVideo (...)           while(0) {}
#define LoggerAudio (...)           while(0) {}
#endif
/*******  DEBUG LOG ********/

#pragma mark - weakPoint
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;



//-----------video capture
#define DEVICE_BOUNDS       [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE         [[UIScreen mainScreen] applicationFrame].size
#define DEVICE_OS_VERSION   [[[UIDevice currentDevice] systemVersion] floatValue]

#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)
#define VIDEO_FOLDER @"videos"

#define MIN_VIDEO_DUR 2.0f
#define MAX_VIDEO_DUR 10.0f
//---------------------------------

#pragma mark - 路径 -

#define PATH_IN_DOCUMENTS_DIR(f)    ([NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),f])
#define PATH_IN_TEMP_DIR(f)         ([NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(),f])

#define PATH_IN_USER                ([NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),[GOUCUser currentUser].user_id])

#define PATH_IN_VIDEO              ([NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),@"VIDEO"])
#define PATH_IN_VIDEOFILE(f)       ([NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),@"VIDEO",f])

#define PATH_IN_USERCENTER(f)       ([NSString stringWithFormat:@"%@/Documents/%@/%@",NSHomeDirectory(),[GOUCUser currentUser].user_id,f])
#define PATH_IN_SayHello(f)         ([NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),f])
#define USER_AVATAR_DIR             ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Avatar"])
#define PATH_IN_USER_AVATAR_DIR(f)  ([NSString stringWithFormat:@"%@/Documents/Avatar/%@", NSHomeDirectory(),f])





#endif
