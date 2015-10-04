//
//  PLoginViewController.h
//  PlayDrama
//
//  Created by RHC on 15/4/14.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBasicViewController.h"

@interface PLoginViewController : PBasicViewController
+ (id)sharedInstance;

- (void)thirdLoginSeverWithTpye:(thirdpartyLoginType)type openId:(NSString *)openId accessToken:(NSString *)accessToken;
@end
