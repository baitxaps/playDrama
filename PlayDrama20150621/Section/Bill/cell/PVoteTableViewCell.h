//
//  PVoteTableViewCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/22.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

+ (PVoteTableViewCell *)loadCell;
@end
