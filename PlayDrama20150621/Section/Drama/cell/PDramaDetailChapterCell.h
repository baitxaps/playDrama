//
//  PDramaDetailChapterCell.h
//  PlayDrama
//
//  Created by hairong.chen on 15/9/2.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDramaEntity;

@interface PDramaDetailChapterCell : UITableViewCell

@property (nonatomic,strong)PDramaEntity *dramaEntity;
@property (nonatomic,strong)NSString     *movieName;
+ (PDramaDetailChapterCell*)initCellWithNib;
@end
