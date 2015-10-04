//
//  UIBarButtonItem+PBarButtonItem.h
//  PlayDrama
//
//  Created by chenhairong on 15/3/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PBarButtonItemType) {
    PBarButtonItemTypeCancel,
    PBarButtonItemTypeClose,
    PBarButtonItemTypeClear,
    PBarButtonItemTypeOK,
    PBarButtonItemTypeAdd,
    PBarButtonItemTypeSave,
    PBarButtonItemTypeOthers,
    PBarButtonItemTypeSearch,
    PBarButtonItemTypeRefresh,
    PBarButtonItemTypeTxtNext,
    PBarButtonItemTypeTxtComplete,
    PBarButtonItemTypeStreamPicture,
    PBarButtonItemTypeStreamValue,
    PBarButtonItemTypeHistogram,
    PBarButtonItemTypeExit,
    PBarButtonItemTypeMore,
    PBarButtonItemTypeMyShareOthers,
    PBarButtonItemTypeMessageMore,
    PBarButtonItemTypeMessageMode,
    PBarButtonItemTypeDriveMode,
    PBarButtonItemTypeWrite,
    PBarButtonItemTypeSuperSearch,
    PBarButtonItemTypeShare,
    PBarButtonItemTypeExchange,
    PBarButtonItemTypePosts,
    PBarButtonItemTypeReply
} ;

@interface UIBarButtonItem (PBarButtonItem)



- (id)initWithBarButtonItemType:(PBarButtonItemType)type target:(id)target action:(SEL)action;
- (id)initWithText:(NSString*)text target:(id)target action:(SEL)action;
/**
 *  初始化plain style的barButtonItem
 *
 *  @param title  标题
 *  @param target target
 *  @param action action
 *
 *  @return GOLO风格的barButtonItem
 */
- (instancetype)initPlainStyleItemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

/**
 *  车神榜  带分隔线
 *
 *  @param text
 *  @param target
 *  @param action
 *
 *  @return
 */
- (id)initWithLineAndText:(NSString*)text target:(id)target action:(SEL)action;

//没有Action

- (instancetype)initWithNavigationItem:(UINavigationItem *)item WithText:(NSString*)text;
//the right with imgView button
- (instancetype)initWithNavigationItem:(UINavigationItem *)barItem
                                target:(id)target
                                action:(SEL)action
                           bgImgString:(NSString*)bgImgString;

@end