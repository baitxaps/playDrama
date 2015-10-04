//
//  PMeSilderTableViewCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/29.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMeSilderTableViewCell : UITableViewCell

-(void)updateData:(NSArray *)datas
           images:(NSArray*)iamges
        indexPath:(NSIndexPath *)indexPath;
+ (PMeSilderTableViewCell *)loadCell;
@end
