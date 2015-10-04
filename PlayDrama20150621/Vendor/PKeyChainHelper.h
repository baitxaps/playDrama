//
//  MyKeyChainHelper.h
//  KeyChainDemo
//
//  Created by chenhairong on 14/11/17.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKeyChainHelper : NSObject

+ (void) saveUserName:(NSString*)userName 
      userNameService:(NSString*)userNameService 
             psaaword:(NSString*)pwd 
      psaawordService:(NSString*)pwdService;

+ (void) deleteWithUserNameService:(NSString*)userNameService 
                   psaawordService:(NSString*)pwdService;

+ (NSString*) getUserNameWithService:(NSString*)userNameService;

+ (NSString*) getPasswordWithService:(NSString*)pwdService;

+ (void)deleteUserNameService:(NSString*)userNameService;

+ (void)deletePsaawordService:(NSString*)pwdService;

@end
