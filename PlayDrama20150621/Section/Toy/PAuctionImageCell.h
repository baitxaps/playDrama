//
//  PAuctionImageCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PAuctionEntity;

@interface PAuctionImageCell : UITableViewCell

@property(nonatomic,strong)PAuctionEntity *auctionEntity;


+(instancetype)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
