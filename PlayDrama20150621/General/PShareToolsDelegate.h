//
//  PshareToolsDelegate.h
//  PlayDrama
//
//  Created by RHC on 15/4/24.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PShareToolsDelegate <NSObject>
@optional
//- (void)shareToolsDelegateWithShareType:(PShareType)type;
- (void)bottomBarActionDelegateShareType:(PBottomBarType)type;
@end

