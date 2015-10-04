//
//  PBeautyDetailLeaveMsgCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/10.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCommentsCellContentDelegate.h"

@class PCommentsEntity;
@class PBeautyEntity;

@interface PCommentsTableViewCell : UITableViewCell<PDramaDelegate>

@property (nonatomic,strong)id <PCommentsCellContentDelegate>data;
@property (nonatomic,assign)id <PDramaDelegate>delegate;

+ (PCommentsTableViewCell*)loadCell;
- (CGFloat)tableViewWithData:(id<PCommentsCellContentDelegate>)data heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
