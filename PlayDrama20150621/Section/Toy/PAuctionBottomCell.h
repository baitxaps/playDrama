//
//  PAuctionBottomCellT.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PUserEntity;
@class PAuctionEntity;

@interface PAuctionBottomCell : UITableViewCell<PDramaDelegate>

@property (assign,nonatomic) id <PDramaDelegate> delegate;
@property (strong,nonatomic) NSIndexPath        *indexPath;

@property (strong,nonatomic) PUserEntity        *userEntity;
@property (strong,nonatomic) PAuctionEntity     *auctionEntity;

+(instancetype)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
