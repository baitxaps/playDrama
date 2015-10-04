//
//  PBillDetailHeadCellTableViewCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/17.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBillDetailCellFrame;

@interface PBillDetailHeadCell : UITableViewCell

-(void)headCellWithData:(PBillDetailCellFrame *)cellFrame
              indexPath:(NSIndexPath *)indexPath
                  image:(UIImage *)image;

@property (nonatomic,strong)UIImage *images;
@end
