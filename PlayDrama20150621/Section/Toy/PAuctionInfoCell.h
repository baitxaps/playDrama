//
//  PAuctionInfoCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/15.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAuctionInfoCell : UITableViewCell

@property (strong,nonatomic) NSIndexPath     *indexPath;

+ (PAuctionInfoCell*)loadCell;
- (void)updateAucationWithData:(NSArray *)data
                     indexPath:(NSIndexPath*)indexPath;
@end
