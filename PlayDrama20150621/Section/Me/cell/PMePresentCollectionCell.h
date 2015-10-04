//
//  PMePresentCollectionCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentEntity.h"

@interface PMePresentCollectionCell : UITableViewCell

@property (nonatomic,strong)PresentEntity *presentEntity;

- (void)updateColorWithIndexPath:(NSIndexPath *)indexPath;
@end
